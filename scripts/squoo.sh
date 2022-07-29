#!/usr/bin/env bash
# compress images use squoosh cli
# NOTICE: bash version must be 4.0 or higher

START_DIR=$PWD

CMD_NAME=$0
# target format extension
DIST_EXT="webp"

# use default squoosh config
CONFIG='{}'

help() {
  echo "./squoo.sh -s SOURCE_DIR -t DIST_DIR"
  exit 1
}

# process file
squoosh() {
  local FULL_SRC_PATH_FILE=$1

  local FULL_SRC_PATH=${FULL_SRC_PATH_FILE%/*}

  local SRC_FILE=${FULL_SRC_PATH_FILE##/*/}

  # get file extension
  local EXT=${SRC_FILE##*.}

  # get the part of without extension
  local SRC_FILE_WITHOUT_EXT=${SRC_FILE%.$EXT}

  # to lower case
  local LOW_EXT=${EXT,,}
  local DIST_FILE=${SRC_FILE_WITHOUT_EXT}.${DIST_EXT}

  # if not set -t arg, then set dist_dir with the same src dir
  if [[ -z ${DIST_DIR} ]]; then
    local DIST_DIR=$FULL_SRC_PATH
  fi

  local FULL_DIST_FILE=${DIST_DIR}/${DIST_FILE}

  if [ "png" == $LOW_EXT ] || [ "jpg" == $LOW_EXT ] || [ "jpeg" == $LOW_EXT ]; then
    if [ -f $FULL_DIST_FILE ]; then
      echo "$FULL_DIST_FILE already exists, skipped."
    else
      #echo "npx @squoosh/cli --webp $CONFIG ${FULL_SRC_PATH_FILE} -d ${DIST_DIR}"
      npx @squoosh/cli --${DIST_EXT} ${CONFIG} ${FULL_SRC_PATH_FILE} -d ${DIST_DIR}
      if [ $? -eq 0 ]; then
        echo "squoosh $FULL_SRC_PATH_FILE succeed."
      else
        echo "squoosh $FULL_SRC_PATH_FILE failed."
      fi
    fi
  elif [ $DIST_EXT == $LOW_EXT ]; then
    echo "$SRC_FILE has been squooshed, skipped."
  else
    echo "$SRC_FILE is non-supported format,skipped."
  fi
}

# process dir
recurse() {
  for i in $(ls $1); do
    local FULL_PATH=${1}/${i}
    if [ -f "${FULL_PATH}" ]; then
      echo "find ${FULL_PATH}"
      squoosh ${FULL_PATH}
    elif [ -d "${FULL_PATH}" ]; then
      recurse ${FULL_PATH}
    else
      echo "${FULL_PATH} should not find in recursion,it's an error."
      exit 1
    fi
  done
}

main() {
  while getopts "s:t:" OPTS; do
    case $OPTS in
      s) SOURCE_DIR="$OPTARG" ;;
      t) DIST_DIR="$OPTARG" ;;
      ?) help ;;
    esac
  done

  if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR=$PWD
  else
    SOURCE_DIR=$(
      cd $SOURCE_DIR
      pwd
    )
  fi

  if [ ! -z "$DIST_DIR" ]; then
    DIST_DIR=$(
      cd $DIST_DIR
      pwd
    )
  fi

  echo "use $CMD_NAME -s $SOURCE_DIR" " " "-t $DIST_DIR"

  for i in $(ls ${SOURCE_DIR}); do
    local FULL_PATH=${SOURCE_DIR}/${i}
    if [ -f "${FULL_PATH}" ]; then
      squoosh ${FULL_PATH}
    elif [ -d "${FULL_PATH}" ]; then
      recurse ${FULL_PATH}
    else
      echo "${FULL_PATH} skipped."
    fi
  done

  exit 0
}

main $@
