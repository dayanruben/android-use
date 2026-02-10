import { describe, expect, test } from "bun:test";
import { existsSync, lstatSync, readFileSync } from "node:fs";
import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

function createEnv(overrides: Record<string, string>): Record<string, string> {
	const env: Record<string, string> = {};

	for (const [key, value] of Object.entries(process.env)) {
		if (value !== undefined) {
			env[key] = value;
		}
	}

	return { ...env, ...overrides };
}

describe("install.sh smoke", () => {
	test("creates canonical skill layout", async () => {
		const repoRoot = resolve(import.meta.dir, "../../..");
		const installScript = join(repoRoot, "install.sh");
		const sandboxDir = await mkdtemp(join(tmpdir(), "android-use-install-"));
		const homeDir = join(sandboxDir, "home");

		try {
			await mkdir(homeDir, { recursive: true });
			await writeFile(join(homeDir, ".zshrc"), "# test shell config\n");

			const proc = Bun.spawnSync({
				cmd: ["bash", installScript, "--non-interactive"],
				cwd: repoRoot,
				env: createEnv({
					HOME: homeDir,
					ANDROID_USE_REPO_URL: repoRoot,
					ANDROID_USE_SKIP_DEPENDENCIES_INSTALL: "1",
					ANDROID_USE_SKIP_BUILD: "1",
					ANDROID_USE_SKIP_VERIFY: "1",
				}),
				stdout: "pipe",
				stderr: "pipe",
			});

			if (proc.exitCode !== 0) {
				const stdout = Buffer.from(proc.stdout).toString("utf8");
				const stderr = Buffer.from(proc.stderr).toString("utf8");
				throw new Error(
					`install.sh failed with code ${proc.exitCode}\nstdout:\n${stdout}\nstderr:\n${stderr}`,
				);
			}

			expect(proc.exitCode).toBe(0);

			const skillDir = join(homeDir, ".config/opencode/skill/android-use");
			const scriptsDir = join(skillDir, "scripts");
			const referencesDir = join(skillDir, "references");
			const assetsDir = join(skillDir, "assets");

			expect(existsSync(join(skillDir, "SKILL.md"))).toBe(true);
			expect(existsSync(join(skillDir, "repo", "SKILL.md"))).toBe(true);
			expect(existsSync(join(scriptsDir, "android-use"))).toBe(true);
			expect(existsSync(join(referencesDir, "AGENTS_GETTING_STARTED.md"))).toBe(
				true,
			);
			expect(existsSync(join(referencesDir, "01-taking-a-screenshot.md"))).toBe(
				true,
			);
			expect(existsSync(join(assetsDir, "logo-banner.png"))).toBe(true);

			const compatibilityScript = join(skillDir, "android-use");
			expect(existsSync(compatibilityScript)).toBe(true);
			expect(lstatSync(compatibilityScript).isSymbolicLink()).toBe(true);

			const shellConfig = readFileSync(join(homeDir, ".zshrc"), "utf8");
			expect(shellConfig).toContain(`export PATH="${scriptsDir}:$PATH"`);
		} finally {
			await rm(sandboxDir, { recursive: true, force: true });
		}
	});
});
