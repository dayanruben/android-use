import type { ScreenElement } from "../contracts/outputs.ts";

export function parseBounds(
	boundsStr: string,
): [number, number, number, number] {
	const match = boundsStr.match(/\[(\d+),(\d+)\]\[(\d+),(\d+)\]/);
	if (!match) return [0, 0, 0, 0];
	const m1 = match[1];
	const m2 = match[2];
	const m3 = match[3];
	const m4 = match[4];
	return [
		m1 ? Number.parseInt(m1, 10) : 0,
		m2 ? Number.parseInt(m2, 10) : 0,
		m3 ? Number.parseInt(m3, 10) : 0,
		m4 ? Number.parseInt(m4, 10) : 0,
	];
}

export function calculateCenter(
	bounds: [number, number, number, number],
): [number, number] {
	const [left, top, right, bottom] = bounds;
	return [Math.floor((left + right) / 2), Math.floor((top + bottom) / 2)];
}

function getAttr(nodeStr: string, attr: string): string | undefined {
	const match = nodeStr.match(RegExp(`${attr}="([^"]*)"`, "i"));
	return match?.[1];
}

function parseNode(nodeStr: string): ScreenElement | null {
	const text = getAttr(nodeStr, "text") ?? "";
	const resourceId = getAttr(nodeStr, "resource-id") ?? "";
	const contentDesc = getAttr(nodeStr, "content-desc") ?? "";
	const clickable = getAttr(nodeStr, "clickable") === "true";
	const scrollable = getAttr(nodeStr, "scrollable") === "true";
	const focused = getAttr(nodeStr, "focused") === "true";
	const boundsStr = getAttr(nodeStr, "bounds");

	if (!boundsStr) return null;

	const bounds = parseBounds(boundsStr);
	const center = calculateCenter(bounds);

	return {
		text,
		resourceId,
		contentDesc,
		clickable,
		scrollable,
		focused,
		bounds,
		center,
	};
}

function isUsefulElement(
	text: string,
	contentDesc: string,
	clickable: boolean,
	scrollable: boolean,
): boolean {
	return (
		(Boolean(text) && text !== "") ||
		(Boolean(contentDesc) && contentDesc !== "") ||
		clickable ||
		scrollable
	);
}

export function parseScreenXml(xml: string): ScreenElement[] {
	const elements: ScreenElement[] = [];
	const nodeRegex = /<node[^>]+\/>/g;

	for (;;) {
		const match = nodeRegex.exec(xml);
		if (!match) break;

		const nodeStr = match[0];

		const text = getAttr(nodeStr, "text");
		const contentDesc = getAttr(nodeStr, "content-desc");
		const clickable = getAttr(nodeStr, "clickable") === "true";
		const scrollable = getAttr(nodeStr, "scrollable") === "true";

		if (isUsefulElement(text ?? "", contentDesc ?? "", clickable, scrollable)) {
			const el = parseNode(nodeStr);
			if (el) elements.push(el);
		}
	}

	return elements;
}
