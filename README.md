# [exe2dist](https://github.com/rtmigo/exe2dist_dart) #experimental

A CLI tool that packages a binary executable into a redistributable archive. 

`dir/native_binary1` ⮕ `myapp_linux_arm64.tgz`

`dir/native_binary2` ⮕ `myapp_windows_x86-64.zip`

* detects the architecture for which the executable is compiled
* sets executable bits (`chmod 755`)
* archives a file to an archive appropriate for the platform

I use this tool to automate my CI/CD. Therefore, the functionality is limited to
my use cases.

`exe2dist` works on Linux and MacOS. Compressible binaries can be for other
platforms as well.

## Install

Compiled executables can be downloaded manually from the [releases page](https://github.com/rtmigo/exe2dist_dart/releases).

For use as part of CI/CD, a command-line installation is more suitable.

Download and unpack the Linux version to the current directory in one line.

```bash
# install
wget -c https://github.com/rtmigo/exe2dist_dart/releases/download/0.2.2/exe2dist_linux_amd64.tgz -O - | tar -xz

# run
./exe2dist
```

Same for the newest version instead of the fixed one.

```bash
wget -c https://github.com/rtmigo/exe2dist_dart/releases/latest/download/exe2dist_linux_amd64.tgz -O - | tar -xz
```

## Use

Archive file `./native_exe` to a distributable 
like `distros/theapp_macos_arm64.tgz`:

```bash
exe2dist theapp native_exe distros/
```

Archive all files in `./binaries` creating appropriate distributable files in 
`distros`:

```bash
exe2dist theapp binaries/* distros/
```

## License

Copyright © 2022 [Artsiom iG](https://github.com/rtmigo).
Released under the [MIT License](LICENSE).

