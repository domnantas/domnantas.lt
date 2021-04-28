#!/bin/bash
. $(dirname $0)/getoptions.sh

parser_definition() {
	prog=${2:?The program name is not set}
	setup REST plus:true help:usage abbr:true error alt:true -- \
		"Usage: ${prog##*/} [options...]" ''
	msg -- 'build script for aušra static site generator' ''
	msg -- 'options:'
	param COMPILER -c --compiler init:="gcc" pattern:"gcc | gcc-debug | tcc | pcc" -- "accepts gcc, gcc-debug, tcc or pcc. default to gcc."
	flag FORMAT -f --format -- "format source files"
	flag VALGRIND --valgrind -- "use valgrind to analyse source"
	disp :usage -h --help
}

eval "$(getoptions parser_definition parse "$0")"
parse "$@"
eval "set -- $REST"

# Lint
if [ $FORMAT ]; then
	echo "formatting" *.c
	clang-format -i *.c
fi

# Cleanup
rm -f ./main
rm -rf dist
mkdir dist

cp -a public/* dist

echo "using $COMPILER compiler"

case $COMPILER in
gcc)
	# Linux(fast)
	cc src/main.c -std=c89 -Os -DNDEBUG -g0 -s -Wall -Wno-unknown-pragmas -o main
	;;
gcc-debug)
	# Linux(debug)
	cc -std=c89 -DDEBUG -Wall -Wno-unknown-pragmas -Wpedantic -Wshadow -Wuninitialized -Wextra -Werror=implicit-int -Werror=incompatible-pointer-types -Werror=int-conversion -Wvla -g -Og -fsanitize=address -fsanitize=undefined src/main.c -o main
	;;
tcc)
	# RPi
	tcc -Wall src/main.c -o main
	;;
pcc)
	# Plan9
	pcc src/main.c -o main
	;;
esac

# Valgrind
if [ $VALGRIND ]; then
	echo "running valgrind"
	valgrind ./main
fi

# Build Size
echo "$(du -b ./main | cut -f1) bytes written"

# Run
./main

# Cleanup
rm -f ./main
