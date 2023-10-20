#!/bin/bash

# Check if a filename is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 1
fi

# Calculate the MD5 hash of the file
md5_hash=$(md5sum "$1" | awk '{print $1}')

# Create the output directory if it doesn't exist
mkdir -p manifest
mkdir -p dalvik
mkdir -p bytecode

# This script extracts the manifest from an APK file and saves 
# it to a text file named by the MD5 hash of the APK file into
# the manifest directory. It also unzips the APK file into an unzip
# directory named by the MD5 hash of the APK file.

# Extract the manifest from the APK                                                                         & Alternative method for extracting the manifest from the APK
if aapt d xmltree "$1" AndroidManifest.xml > "manifest/${md5_hash}.txt"; then
  echo "aapt succeeded."
else
  echo "FAIL - aapt failed; trying unzip."
  if unzip -p "$1" AndroidManifest.xml > "manifest/${md5_hash}.txt"; then
    echo "Unzip succeeded."
  else
    echo "FAIL - unzip also failed."
  fi
fi

### Start from here as new process to parallelize the tasks

# Extract the dalvik.dex from the APK                                               
if apktool d "$1" -f -o "dalvik/${md5_hash}.dex"; then
  echo "APK tool succeeded."
else
# Alternative method for extracting the classes.dex from the APK
  echo "FAIL - apktool failed; trying unzip."
  if unzip -p "$1" classes.dex > "dalvik/${md5_hash}.dex"; then
    echo "Unzip succeeded to extract dalvik code."
  else
    echo "FAIL - unzip also failed."
  fi
fi


# Convert Dalvik to Java bytecode
if enjarify "$1" -o "bytecode/${md5_hash}.jar" --force; then
  echo "Enjarify succeeded."
else
  echo "FAIL - enjarify failed; trying dex2jar."
  if d2j-dex2jar "dalvik/${md5_hash}.dex" -o "bytecode/${md5_hash}.jar" --force; then
    echo "Dex2jar succeeded."
  else
    echo "FAIL - dex2jar also failed."
  fi
fi
