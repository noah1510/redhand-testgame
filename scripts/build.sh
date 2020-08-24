#!/bin/bash

find_compiler(){
    # get cross-distro version of POSIX command
    COMMAND=""
    if command -v command 2>/dev/null; then
        COMMAND="command -v"
    elif type type 2>/dev/null; then
        COMMAND="type"
    fi

    for comp in clang-12 clang-11 clang-10 clang-9 gcc-10 gcc-9 C:/Program Files/LLVM/bin/clang.exe; do
        if $COMMAND "$comp" 2>/dev/null; then
            export CC="$comp"
            break;
        fi
    done

    for comp in clang++-12 clang++-11 clang++-10 clang++-9 g++-10 g++-9 C:/Program Files/LLVM/bin/clang++.exe; do
        if $COMMAND "$comp" 2>/dev/null; then
            export CXX="$comp"
            break;
        fi
    done
}

THREADS="3"
CLEAN="0"
#parse parameter
pars=$#
for ((i=1;i<=pars;i+=1))
do
  case "$1" in
    "-j")
      shift
      if [ $1 ]
      then
        THREADS="$(($1+1))"
      fi
      shift
      i+=1
      ;;
    "--clean")
      CLEAN="1"
      SETUP="1"
      shift
      ;;
    "--help")
      echo "This script is used to build the testgame and copy it in the deploy folder."
      echo "Usage: scripts/build.sh [options]"
      echo "Options:"
      echo "    --help              Display this information"
      echo "    -j [threadnumber]   Build the project with the specified number of threads."
      echo "    -o [buildname]      Build the project with the specified buildname defaults to main"
      echo "    --lib               Also build the library"
      echo "    --setup             Also setup the environment"
      echo "    --clean             Also clean the environment before compiling"
      echo ""
      echo "view the source on https://github.com/noah1510/redhand"
      exit 1
      ;;
    *)
      echo "Invalid option try --help for information on how to use the script"
      exit 1
      ;;
  esac
done

if [ "$THREADS" == "3" ]
then
  THREADS="$(nproc)"
  THREADS="$(($THREADS+1))"
fi

if [ "$CLEAN" == "1" ]
then
  rm -rf "build"
fi

REPOROOT="$(pwd)"
PROJECTNAME="redhand"

if [ "$OSTYPE" == "linux-gnu" ]
then
    # Linux
    echo "script running on linux"

    EXECUTABLE="$PROJECTNAME-$BUILDNAME"

elif [ "$OSTYPE" == "darwin"* ]
then
    # Mac OSX
    echo "script running on mac osx"

    EXECUTABLE="$PROJECTNAME-$BUILDNAME"
        
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]
then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    # or 
    # POSIX compatibility layer and Linux environment emulation for Windows
    echo "script running on windows"

    EXECUTABLE="$PROJECTNAME-$BUILDNAME.exe"
else
    # Unknown os
    echo "running on something else."
    echo "Not a supported OS: $OSTYPE" >&2
    exit 1
fi

find_compiler

#build actual project
mkdir "build"
cd "build"

meson setup ".."
ninja -j"$THREADS"
if [ $? -eq 0 ]
then
  echo "Successfully compiled $PROJECTNAME"
else
  echo "Could not compile $PROJECTNAME" >&2
  cd ".."
  exit 4
fi
cd ".."
