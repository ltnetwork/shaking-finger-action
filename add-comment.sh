#!/bin/bash
set -e
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
	exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

GIF_URL=https://github.com/jessfraz/shaking-finger-action/raw/master/finger.gif

post_gif() {
	echo "posting gif to PR #${NUMBER}"
	curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" -d '{"body":"![finger.gif]('${GIF_URL}')"}' -H "Content-Type: application/json" -X POST "${URI}/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
}

main() {
	# Get the pull request number.
	NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")

	echo "running $GITHUB_ACTION for PR #${NUMBER}"

	post_gif;

	echo "execution finished"
}

main
