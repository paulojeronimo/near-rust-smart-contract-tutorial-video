#!/usr/bin/env bash
set -eou pipefail
cd $(dirname $0)

input_dir=media/simplescreenrecord
build_dir=build
trimmed_dir=$build_dir/trimmed

_trim() {
  mkdir -p $trimmed_dir
  file=01.1.mkv
  ffmpeg -y -i $input_dir/$file -ss 00:00:02 -to 00:03:19 -c:v copy $trimmed_dir/$file &> $trimmed_dir/$file.log
}

_media-tar-gz() {
  tar -hcvf - media/ | gzip - > media.tar.gz
}

op=${1:-trim}
if ! type "_$op" &> /dev/null
then
  echo "Operation '_$op' not found! Aborting ..."
  exit 1
fi
_$op ${@:-}
