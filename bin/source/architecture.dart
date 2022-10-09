import 'dart:io';

class Architecture {
  final String os;
  final String platform;

  String get combined => "${os}_$platform";

  Architecture(this.os, this.platform);

  bool get isWindows => os == "windows";
}

class UnknownArchitectureException extends Error {
  UnknownArchitectureException({required this.processResult});

  final ProcessResult processResult;

  @override
  String toString() {
    return "$runtimeType ${processResult.stdout}";
  }
}

/*
  Вопрос, как называть архитектуры:

  RedHat, Fedora, Suse за x86_64:
    Fedora-Workstation-Live-x86_64-36-1.5.iso
    Fedora-Workstation-Live-aarch64-36-1.5.iso
    archlinux-2022.10.01-x86_64.iso
    SLE-15-SP4-Full-x86_64-GM-Media1.iso
    SLE-15-SP4-Full-aarch64-GM-Media1.iso

  Википедия пишет:
    x86-64 (also known as x64, x86_64, AMD64, and Intel 64)

  Debian и производные, FreeBSD за amd64:
    debian-11.5.0-amd64-netinst.iso
    debian-11.5.0-arm64-netinst.iso
    ubuntu-20.04.5-live-server-amd64.iso
    ubuntu-22.04.1-live-server-arm64.iso
    FreeBSD-13.1-RELEASE-amd64-disc1.iso
    FreeBSD-13.1-RELEASE-arm64-aarch64-dvd1.iso

  MX целится только в x86, причём называется своеобразно:
    MX-21.2.1_x64.iso
    MX-21.2.1_386.iso

  Я предпочитаю именования Debian, поскольку они не содержат знаков препинания.
*/

class IfThen {
  IfThen(this.markers, this.os, this.cpu);
  final String markers;
  final String os;
  final String cpu;
}

final List<IfThen> rules = [
  IfThen("Mach-O x86_64 executable", "darwin", "amd64"),
  IfThen("Mach-O arm64 executable", "darwin", "arm64"),

  // We have entered the slippery slope of heuristics. The operating system name
  // is not always in the `file` output. In these cases, we will assume that the
  // unknown *nix system is Linux

  IfThen("ELF OpenBSD x86-64", "openbsd", "amd64"),
  IfThen("ELF NetBSD x86-64", "netbsd", "amd64"),
  IfThen("ELF FreeBSD x86-64", "freebsd", "amd64"),
  IfThen("ELF GNU/Linux x86-64", "linux", "amd64"),
  IfThen("ELF 64-bit LSB x86-64", "linux", "amd64"),

  IfThen("ELF OpenBSD LSB executable Intel 80386", "openbsd", "i386"),
  IfThen("ELF NetBSD LSB executable Intel 80386", "netbsd", "i386"),
  IfThen("ELF FreeBSD LSB executable Intel 80386", "freebsd", "i386"),
  IfThen("ELF LSB executable Intel 80386", "linux", "i386"),

  IfThen("ELF NetBSD 32-bit ARM EABI5", "netbsd", "arm32"),
  IfThen("ELF FreeBSD 32-bit ARM EABI5", "freebsd", "arm32"),
  IfThen("ELF OpenBSD 32-bit ARM EABI5", "openbsd", "arm32"),
  IfThen("ELF 32-bit ARM EABI5", "linux", "arm32"),

  IfThen("PE32 executable Intel 80386", "windows", "i386"),
  IfThen("MS Windows PE32+ x86-64", "windows", "amd64"),
];

Architecture detectArchitecture(File file) {
  final pr = Process.runSync("file", [file.path]);
  final stdout = pr.stdout.toString();
  bool containsAll(List<String> l) => l.every((s) => stdout.contains(s));

  for (final it in rules) {
    if (containsAll(it.markers.split(" "))) {
      return Architecture(it.os, it.cpu);
    }
  }
  throw UnknownArchitectureException(processResult: pr);
}