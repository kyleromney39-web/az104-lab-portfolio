#!/bin/bash
#Goal: Write a simple sequence that behaves like a cloud server's startup routine—setting a variable, attempting a download, and acting on the result.
# This is to download a webpage and save it to a file

DOWNLOAD_URL="https://www.google.com"
curl -s "$DOWNLOAD_URL" > index.html

# Check to see if file exist 
file="index.html"
if [ -e "$file" ]; then
	echo "Server setup complete: Assets downloaded."
else
	echo "Server setup failed: Could not reach the network."
fi


