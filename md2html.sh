#!/bin/sh

which 2>&1 markdown >/dev/null
if [ $? != 0 ]; then
	echo "Program markdown not found, please install it with your package manager"
	exit 1
fi

if [ $# != 1 ]; then
	echo "Usage: md2html.sh markdown-file"
	exit 1
fi

echo "<head><link rel="stylesheet" type="text/css" href="stylesheet.css" /></head>"
markdown $1
