# APK Analysis Script

This script is designed to analyze Android APK files by extracting important components such as the AndroidManifest.xml file, Dalvik bytecode, and Java bytecode. It uses a variety of tools to perform these tasks and saves the extracted data into separate directories. The script is written in Bash and provides error handling for various scenarios.

## Prerequisites

Before using this script, make sure you have the following tools installed:

- [`aapt` (Android Asset Packaging Tool)](https://developer.android.com/tools/aapt2)
- [`apktool`](https://github.com/iBotPeaches/Apktool)
- [`enjarify`](https://github.com/google/enjarify)
- [`dex2jar`](https://github.com/pxb1988/dex2jar)

Make sure you add these executables to your environment:

I downloaded enjarify to my users Console folder and symlinked it to my bin folder

```bash
ln -s "$PWD/enjarify.sh" ~/Console/bin/enjarify
```

I installed dex2jar via brew
```bash
brew install dex2jar
```

The command is d2j-dex2jar. Make sure you make it available like that via PATH variable or Symlink:

```bash
# Contents of .bash_profile on macOS

export PATH="$PATH:/Users/<user>/Library/Android/sdk/build-tools/34.0.0"
export PATH="$PATH:/Users/<user>/Library/Android/sdk/cmdline-tools/latest/bin"
export PATH="$PATH:/Users/<user>/Console/bin"
```

You also need to have Java installed on your system since some of the tools, like `enjarify` and `dex2jar`, require Java to run.

## Usage

To use this script, follow these steps:

1. Open your terminal.
2. Make sure the script has execute permissions. If not, run the following command:

    ```bash
    chmod +x script_name.sh
    ```

3. Run the script, providing the APK file you want to analyze as a command-line argument:

    ```bash
    ./script_name.sh your_app.apk
    ```

Replace `script_name.sh` with the actual filename of the script.

### Example Usage

```bash
./apk_analysis.sh my_app.apk
```

## Script Overview

1. **Argument Check**: The script first checks if you provided an APK file as an argument. If no argument is provided or if more than one argument is given, it will display the usage instructions and exit.

2. **File Existence Check**: It then checks if the provided APK file exists. If the file is not found, the script will display an error message and exit.

3. **MD5 Hash Calculation**: The MD5 hash of the APK file is calculated and stored for naming the output files and directories.

4. **Directory Creation**: Three directories are created to store extracted data:
    - `manifest`: For the AndroidManifest.xml file.
    - `dalvik`: For Dalvik bytecode.
    - `bytecode`: For Java bytecode.

5. **Manifest Extraction**: The script attempts to extract the AndroidManifest.xml file using the `aapt` tool. If successful, it saves the output to the `manifest` directory. If `aapt` fails, it falls back to using `unzip` to extract the manifest.

6. **Dalvik Bytecode Extraction**: The script tries to extract Dalvik bytecode using `apktool`. If successful, it saves the output to the `dalvik` directory. If `apktool` fails, it attempts to extract Dalvik bytecode using `unzip`.

7. **Java Bytecode Conversion**: The script first tries to convert Dalvik bytecode to Java bytecode using `enjarify`. If successful, it saves the output to the `bytecode` directory. If `enjarify` fails, it falls back to using `dex2jar` to perform the conversion.

## Parallelization

After the manifest extraction, the script launches separate processes for Dalvik bytecode extraction and Java bytecode conversion, which allows these tasks to be performed in parallel. This can significantly speed up the analysis process.

## Error Handling

The script provides error messages in case any of the extraction or conversion processes fail, ensuring that you are aware of any issues encountered during the analysis.

## Conclusion

This script provides a convenient way to analyze Android APK files by extracting key components and saving them in separate directories. Make sure to install the required tools and have Java installed to use this script effectively.