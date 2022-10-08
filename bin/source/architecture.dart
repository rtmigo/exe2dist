import 'dart:io';

class Architecture {
  final String string;

  Architecture(this.string);

  bool get isWindows => string.startsWith("windows");
}

class UnknownArchitectureException extends Error {
  UnknownArchitectureException({
    required this.processResult
  });
  final ProcessResult processResult;

  @override
  String toString() {
    return "$runtimeType ${processResult.stdout}";
  }
}

Architecture detectArchitecture(File file) {
  final pr = Process.runSync("file", [file.path]);
  final stdout = pr.stdout.toString();
  bool containsAll(List<String> l) => l.every((s) => stdout.contains(s));

  if (containsAll(["Mach-O", "x86_64", "executable"])) {
    return Architecture("macos_x86-64");
  } if (containsAll(["Mach-O", "arm64", "executable"])) {
    return Architecture("macos_arm64");
  } else if (containsAll(["for GNU/Linux", "x86-64"])) {
    return Architecture("linux_x86-64");
  } else if (containsAll(["for MS Windows", "PE32+", "x86-64"])) {
    return Architecture("windows_x86-64");
  }
  throw UnknownArchitectureException(
    processResult: pr
  );
}