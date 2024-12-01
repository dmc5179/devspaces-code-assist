FROM quay.io/devfile/universal-developer-image:ubi8-latest

COPY ./Continue.continue-0.9.237.vsix /home/user/.vscode/extensions/Continue.continue-0.9.237.vsix
COPY config.json /home/user/.continue/config.json
