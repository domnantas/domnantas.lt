#!/bin/bash
AUSRA_DIR=$(
	cd "$(dirname "$BASH_SOURCE")"
	cd -P "$(dirname "$(readlink "$BASH_SOURCE" || echo .)")"
	pwd
)

. $AUSRA_DIR/getoptions.sh

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

# Format source
if [ $FORMAT ]; then
	echo "formatting source code"
	clang-format -i $AUSRA_DIR/*.c
fi

# Cleanup
rm -f $AUSRA_DIR/main
rm -rf dist
mkdir dist

cp -a static/* dist

echo "using $COMPILER compiler"

case $COMPILER in
gcc)
	# Linux(fast)
	gcc -std=c89 -Os -DNDEBUG -g0 -Wall -Wno-unknown-pragmas $AUSRA_DIR/main.c -o $AUSRA_DIR/main
	;;
gcc-debug)
	# Linux(debug)
	gcc -std=c89 -DDEBUG -Wall -Wno-unknown-pragmas -Wpedantic -Wshadow -Wuninitialized -Wextra -Werror=implicit-int -Werror=incompatible-pointer-types -Werror=int-conversion -Wvla -g -Og -fsanitize=address -fsanitize=undefined $AUSRA_DIR/main.c -o $AUSRA_DIR/main
	;;
tcc)
	# RPi
	tcc -Wall $AUSRA_DIR/main.c -o $AUSRA_DIR/main
	;;
pcc)
	# Plan9
	pcc $AUSRA_DIR/main.c -o $AUSRA_DIR/main
	;;
esac

# Valgrind
if [ $VALGRIND ]; then
	echo "running valgrind"
	valgrind $AUSRA_DIR/main
fi

echo "-------------"

# Run
$AUSRA_DIR/main

# Cleanup
rm -f $AUSRA_DIR/main
