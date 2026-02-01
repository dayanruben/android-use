import os from "node:os";
import path from "node:path";
import { mkdir } from "node:fs/promises";

/**
 * Get memory-backed cache directory (tmpfs / volatile storage)
 * - Linux: /tmp
 * - macOS: /tmp (tmpfs-backed)
 * - Windows: %TEMP%
 */
export function getCacheDir(): string {
	const platform = os.platform();

	if (platform === "darwin" || platform === "linux") {
		return "/tmp/.ai-artifacts/skills/android-use";
	}

	// Fallback for Windows/others
	return path.join(os.tmpdir(), ".ai-artifacts", "skills", "android-use");
}

/**
 * Ensure cache directory exists
 */
export async function ensureCacheDir(): Promise<string> {
	const cacheDir = getCacheDir();
	await mkdir(cacheDir, { recursive: true });
	return cacheDir;
}

/**
 * Get cache file path for screen dump
 */
export function getScreenCachePath(suffix = "json"): string {
	const cacheDir = getCacheDir();
	return path.join(cacheDir, `screen.${suffix}`);
}
