import 'dart:io';

import 'package:test/test.dart';

import '../bin/source/architecture.dart';

void main() {
  test("detecting architecture", () {
    expect(detectArchitecture(File("test/executables/ghcp_linux_amd64")).combined,
        'linux_amd64');
    expect(detectArchitecture(File("test/executables/ghcp_osx_amd64")).combined,
        'macos_amd64');
    expect(detectArchitecture(File("test/executables/ghcp_windows_amd64")).combined,
        'windows_amd64');
    expect(()=>detectArchitecture(File("test/executables/labuda.txt")),
        throwsA(isA<UnknownArchitectureException>()));
  });
}