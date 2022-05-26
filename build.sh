#!/usr/bin/env bash
set -eou pipefail
cd $(dirname $0)

media_dir=media
ssr_dir=${media_dir}/simplescreenrecord
build_dir=build
trimmed_dir=$build_dir/trimmed

_trim() {
  mkdir -p $trimmed_dir

  local file
  local ss
  local to
  for file in $ssr_dir/*.mkv
  do
    file=${file##*/}
    ss=$(yq ".trim.\"$file\".ss" config.yaml)
    to=$(yq ".trim.\"$file\".to" config.yaml)
    ffmpeg -y -i $ssr_dir/$file -ss $ss -to $to -c:v copy $trimmed_dir/$file &> $trimmed_dir/$file.log
  done
}

_all() {
  _trim
}

_media-tar-gz() {
  tar -hcvf - media/ | gzip - > media.tar.gz
}

op=${1:-all}
if ! type "_$op" &> /dev/null
then
  echo "Operation '_$op' not found! Aborting ..."
  exit 1
fi
_$op ${@:-}
