import { GetScreenInputSchema } from "@core/contracts/inputs.ts";
import type { GetScreenOutput } from "@core/contracts/outputs.ts";
import { ok, err } from "@core/types/result.ts";
import type { CommandResult } from "@core/types/result.ts";
import type { CommandContext } from "@shell/registry.ts";
import { registerCommand } from "@shell/registry.ts";
import { parseScreenXml } from "@core/parsers/screen-xml.ts";
import { ensureCacheDir, getScreenCachePath } from "@core/cache.ts";
import { writeFile } from "node:fs/promises";

/**
 * get-screen command - dump UI hierarchy (compact JSON by default)
 */
async function getScreen(
	args: string[],
	ctx: CommandContext,
): Promise<CommandResult<GetScreenOutput>> {
	const input = GetScreenInputSchema.safeParse({
		serial: args[0] ?? null,
		full: args.includes("--full"),
		// Note: includeInvisible is not supported by uiautomator dump
		// The flag is accepted for API consistency but has no effect
	});

	if (!input.success) {
		return err("INVALID_INPUT", input.error.message, {
			trace: ctx.trace.finish(),
		});
	}

	const { serial, full } = input.data;
	const execOpts = {
		timeoutMs: ctx.config.timeoutMs,
		signal: ctx.signal,
		serial,
	};

	// Dump UI hierarchy to file on device
	const dumpPath = "/sdcard/window_dump.xml";
	const dumpResult = await ctx.adb.exec(
		["shell", "uiautomator", "dump", dumpPath],
		execOpts,
	);
	ctx.trace.recordCall(
		["shell", "uiautomator", "dump"],
		dumpResult.durationMs,
		dumpResult.exitCode,
	);

	if (dumpResult.exitCode !== 0) {
		return err("ADB_FAILED", dumpResult.stderr || "UI dump failed", {
			exitCode: dumpResult.exitCode,
			trace: ctx.trace.finish(),
		});
	}

	// Read the dump file
	const catResult = await ctx.adb.exec(["shell", "cat", dumpPath], execOpts);
	ctx.trace.recordCall(
		["shell", "cat", dumpPath],
		catResult.durationMs,
		catResult.exitCode,
	);

	if (catResult.exitCode !== 0) {
		return err("ADB_FAILED", catResult.stderr || "Failed to read UI dump", {
			exitCode: catResult.exitCode,
			trace: ctx.trace.finish(),
		});
	}

	const xml = catResult.stdout;

	// Clean up dump file
	await ctx.adb.exec(["shell", "rm", dumpPath], execOpts);

	const byteSize = new TextEncoder().encode(xml).length;
	await ensureCacheDir();

	if (full) {
		const cachePath = getScreenCachePath("xml");
		await writeFile(cachePath, xml, "utf-8");

		return ok(
			{
				format: "full",
				xml,
				byteSize,
			} as const,
			{
				message: `UI hierarchy dumped (${xml.length} chars)`,
				trace: ctx.trace.finish(),
			},
		);
	}

	const allElements = parseScreenXml(xml);

	const compactOutput = {
		elements: allElements,
		clickable: allElements.filter((e) => e.clickable),
		scrollable: allElements.filter((e) => e.scrollable),
		withText: allElements.filter((e) => e.text && e.text !== ""),
		withContentDesc: allElements.filter(
			(e) => e.contentDesc && e.contentDesc !== "",
		),
	};

	const cachePath = getScreenCachePath("json");
	await writeFile(cachePath, JSON.stringify(compactOutput, null, 2), "utf-8");

	return ok(
		{
			format: "compact",
			compact: compactOutput,
			originalByteSize: byteSize,
		} as const,
		{
			message: `UI hierarchy parsed (${allElements.length} elements, ${byteSize} → ~${Math.round(byteSize * 0.25)} bytes)`,
			trace: ctx.trace.finish(),
		},
	);
}

registerCommand("get-screen", getScreen);

export { getScreen };
