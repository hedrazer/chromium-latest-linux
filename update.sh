#! /bin/bash

cd $(dirname $0)

LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"

REVISION=$(curl -s -S $LASTCHANGE_URL)

echo "latest revision is $REVISION"

if [ -d $REVISION ] ; then
  echo "already have latest version"
  exit
fi

fetch_url() {
	pushd $REVISION
	echo "fetching: $1"
	curl -# "$1" > "$2"
	echo "unzipping: $2"
	unzip "$2"
	[ -f "$2" ] && rm "$2"
	popd
}

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
ZIP_FILE="${REVISION}-chrome-linux.zip"

ZIP_URL_WD="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchromedriver_linux64.zip?alt=media"
ZIP_FILE_WD="${REVISION}-chromedriver_linux64.zip"

echo "fetching $ZIP_URL"

rm -rf $REVISION
mkdir $REVISION

fetch_url $ZIP_URL $ZIP_FILE
fetch_url $ZIP_URL_WD $ZIP_FILE_WD

rm -f ./latest
ln -s $REVISION/chrome-linux/ ./latest

if [ -f $REVISION/chromedriver_linux64/chromedriver ]; then
	mv $REVISION/chromedriver_linux64/chromedriver ./latest/
	rmdir $REVISION/chromedriver_linux64
fi;
