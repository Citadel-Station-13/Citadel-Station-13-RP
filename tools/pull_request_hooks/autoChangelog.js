import { parseChangelog } from "./changelogParser.js";
import * as core from '@actions/core';
import * as github_action from '@actions/github';

const safeYml = (string) =>
	string.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, "\\n");

export function changelogToYml(changelog, login) {
	const author = changelog.author || login;
	const ymlLines = [];

	ymlLines.push(`author: "${safeYml(author)}"`);
	ymlLines.push(`delete-after: True`);
	ymlLines.push(`changes:`);

	for (const change of changelog.changes) {
		ymlLines.push(
			`  - ${change.type.changelogKey}: "${safeYml(change.description)}"`
		);
	}

	return ymlLines.join("\n");
}

export async function processAutoChangelog({ github, context }) {
	console.log("Starting processAutoChangelog");

	const changelog = parseChangelog(context.payload.pull_request.body);
	if (!changelog || changelog.changes.length === 0) {
		console.log("no changelog found");
		return;
	}

	console.log("created changelog with length:");
	console.log(changelog.changes.length);

	const yml = changelogToYml(
		changelog,
		context.payload.pull_request.user.login
	);

	const octokit = github_action.getOctokit(process.env.GITHUB_TOKEN);

	await octokit.rest.repos.createOrUpdateFileContents({
		owner: context.repo.owner,
		repo: context.repo.repo,
		branch: context.payload.pull_request.head.ref,
		path: `html/changelogs/AutoChangeLog-pr-${context.payload.pull_request.number}.yml`,
		message: `Automatic changelog for PR #${context.payload.pull_request.number} [ci skip]`,
		content: Buffer.from(yml).toString("base64"),
	});
}
