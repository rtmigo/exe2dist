# [exe2dist](https://github.com/rtmigo/exe2dist)

CLI utility that packs a binary executable into a redistributable archive.

`outs/1/compiled.kexe` ⮕ `myapp_linux_arm64.tgz` with `myapp` inside

`outs/2/compiled.kexe` ⮕ `myapp_windows_amd64.zip` with `myapp.exe` inside

`outs/3/compiled.kexe` ⮕ `myapp_macos_arm64.tgz` with `myapp` inside

--------------------------------------------------------------------------------

* It detects the architecture for which the executable is compiled
* It sets executable bits for *nix binaries (`chmod 755`)
* It adds `.exe` extension to Windows executables
* It packs the binary to an archive appropriate for the platform

--------------------------------------------------------------------------------

Let's imagine that our automated system compiles executables using Kotlin
Native. Regardless of the platform, the script builds a `compiled.kexe`.

Before the release, we can collect all the built files in one directory.

* `outs/1/compiled.kexe`
* `outs/2/compiled.kexe`
* `outs/3/compiled.kexe`

But how to distinguish and name them? `exe2dist` automatically solves this
problem.

```bash
exe2dist myapp outs/*/*.kexe targetdir
```

This command will create three archives with friendly names. 

--------------------------------------------------------------------------------

`exe2dist` runs on Linux and macOS. It may process binaries that target other
platforms.

## Install manually

Compiled executables can be downloaded from
the [releases page](https://github.com/rtmigo/exe2dist_dart/releases).

## Install via command line

Download and unpack the Linux version to the current directory.

```bash
wget -c https://github.com/rtmigo/exe2dist/releases/download/0.3.3/exe2dist_linux_amd64.tgz -O - | tar -xz
```

Run immediately:

```bash
./exe2dist
```

Same for the newest version instead of the fixed one.

```bash
wget -c https://github.com/rtmigo/exe2dist/releases/latest/download/exe2dist_linux_amd64.tgz -O - | tar -xz
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

## Platforms

The safe systems are **Linux**, **macOS** (Darwin) and **Windows**.

The safe platforms are **x86-64** (AMD64) and **ARM64**. 

If you are building executables for *BSD or more rare *nix systems, this
utility should be used with caution. It will rely on guesswork, and may wrongly
assume, that the executable is for Linux.

## License

Copyright © 2022 [Artsiom iG](https://github.com/rtmigo).
Released under the [MIT License](LICENSE).
