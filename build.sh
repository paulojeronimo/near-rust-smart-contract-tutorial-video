#!/usr/bin/env bash
set -eou pipefail
cd $(dirname $0)

input_dir=media/simplescreenrecord
build_dir=build
trimmed_dir=$build_dir/trimmed

mkdir -p $trimmed_dir
file=01.1.mkv
ffmpeg -i $input_dir/$file -ss 00:00:02 -to 00:03:19 -c:v copy $trimmed_dir/$file &> $trimmed_dir/$file.log
