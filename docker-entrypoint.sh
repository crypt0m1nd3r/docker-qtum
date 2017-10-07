#!/bin/sh

set -e

if [[ "${1}" == "qtum-cli" || "${1}" == "qtum-tx" || "${1}" == "qtumd" ]]; then
	mkdir -p "$QTUM_DATA"
	chown -R qtum "$QTUM_DATA"
	ln -sfn "$QTUM_DATA" /home/qtum/.qtum
	chown -h qtum:qtum /home/qtum/.qtum

	if [[ "${1}" == "qtum-cli" ]]; then
		# For some reason "${@:2}" doesn't work here... (likely an issue with how docker passes the arguments).
		CLI_PARAMS="$(echo "${@}" | cut -d' ' -f2-)"
		CLI_PARAMS2=$(echo -e "${CLI_PARAMS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
		if [[ "${CLI_PARAMS2}" == "qtum-cli" ]]; then
			exec su-exec qtum "${1}"
		else
			exec su-exec qtum "${1}" -conf=/home/qtum/qtum.conf ${CLI_PARAMS2}
		fi
	elif [[ "${1}" == "qtum-tx" ]]; then
		exec su-exec qtum "${@}"
	else
		# qtumd (no parameters)
		exec su-exec qtum "${1}" -conf=/home/qtum/qtum.conf
	fi

else
	echo "ERROR: Command must be one of: 'qtumd', 'qtum-cli', or 'qtum-tx'.  The 'qtumd' command must not be given any command-line arguments.".
fi
