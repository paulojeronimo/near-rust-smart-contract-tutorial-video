#!/usr/bin/env bash
set -eou pipefail
cd $(dirname $0)

media_dir=media
ssr_dir=${media_dir}/simplescreenrecord
build_dir=build
trim_dir=$build_dir/trim

_trim() {
  mkdir -p $trim_dir

  local file
  local ss
  local to
  for file in $ssr_dir/*.mkv
  do
    file=${file##*/}
    ss_to=($(yq ".trim.\"$file\"" config.yaml))
    ffmpeg -y -i $ssr_dir/$file \
      -ss ${ss_to[0]} \
      -to ${ss_to[1]} \
      -c:v copy $trim_dir/$file &> $trim_dir/$file.log
  done
}

_all() {
  _trim
}

_media-tar-gz() {
  tar -hcvf - media/ | gzip - > media.tar.gz
}

_html() {
  # https://gist.github.com/paulojeronimo/95977442a96c0c6571064d10c997d3f2
  docker-asciidoctor-builder
}

_gh-pages() {
  local html=$build_dir/index.html
  if ! [ -f $html ] || [ README.adoc -nt $html ]
  then
    _html
  fi
  docker-asciidoctor-builder gh-pages
}

op=${1:-all}
if ! type "_$op" &> /dev/null
then
  echo "Operation '_$op' not found! Aborting ..."
  exit 1
fi
_$op ${@:-}
