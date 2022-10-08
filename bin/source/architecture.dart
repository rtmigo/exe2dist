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

Architecture detectArchitecture(File file) {
  final pr = Process.runSync("file", [file.path]);
  final stdout = pr.stdout.toString();
  bool containsAll(List<String> l) => l.every((s) => stdout.contains(s));

  if (containsAll(["Mach-O", "x86_64", "executable"])) {
    return Architecture("macos", "amd64");
  } else if (containsAll(["Mach-O", "arm64", "executable"])) {
    return Architecture("macos", "arm64");
  } else if (containsAll(["for GNU/Linux", "x86-64"])) {
    return Architecture("linux", "amd64");
  } else if (containsAll(["for MS Windows", "PE32+", "x86-64"])) {
    return Architecture("windows", "amd64");
  }
  throw UnknownArchitectureException(processResult: pr);
}
