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
BUILDNAME="testgame"
BUILDLIB="0"
SETUP="0"
CLEAN="0"
#parse parameter
pars=$#
for ((i=1;i<=pars;i+=1))
do
  case "$1" in
    "-o")
      shift
      if [ $1 ]
      then
        BUILDNAME="$1"
      else
        BUILDNAME="lib"
      fi
      i+=1
      shift
      ;;
    "-j")
      shift
      if [ $1 ]
      then
        THREADS="$(($1+1))"
      fi
      shift
      i+=1
      ;;
    "--lib")
      BUILDLIB="1"
      shift
      ;;
    "--setup")
      SETUP="1"
      shift
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
  bash scripts/clean.sh
fi

if [ "$SETUP" == "1" ]
then
  bash scripts/setup.sh
fi

if [ "$BUILDLIB" == "1" ]
then
  echo "building library"
  bash scripts/build.sh -j "$THREADS"
  if [ $? -eq 0 ]
  then
    echo "Successfully compiled redhand"
  else
    echo "Could not compile redhand" >&2
    cd "../.."
    exit 4
  fi
fi

REPOROOT="$(pwd)"
PROJECTNAME="redhand"

if [ "$OSTYPE" == "linux-gnu" ]
then
    # Linux
    echo "script running on linux"

    EXECUTABLE="$PROJECTNAME-$BUILDNAME"
    REDHAND_LOCATION="deploy/libredhand.so"

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

echo "number of THREADS:$THREADS"
echo "buildname:$BUILDNAME"

mkdir -p "build"

#build actual project
mkdir -p "build/$BUILDNAME"
cd "build/$BUILDNAME"
cmake -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DOUTPUTFILE="$PROJECTNAME-$BUILDNAME" -DREPOROOT=$REPOROOT -DREDHAND_LOCATION="$REDHAND_LOCATION" "../../testgame"
ninja -j"$THREADS"
if [ $? -eq 0 ]
then
  echo "Successfully compiled $PROJECTNAME"
else
  echo "Could not compile $PROJECTNAME" >&2
  cd "../.."
  exit 4
fi
cd "../.."
cp -r "build/$BUILDNAME/$EXECUTABLE" "deploy"
