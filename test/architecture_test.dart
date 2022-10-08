import 'dart:io';

import 'package:test/test.dart';

import '../bin/source/architecture.dart';

void main() {
  test("detecting architecture", () {
    expect(detectArchitecture(File("test/executables/ghcp_linux_amd64")).string,
        'linux_x86-64');
    expect(detectArchitecture(File("test/executables/ghcp_osx_amd64")).string,
        'macos_x86-64');
    expect(detectArchitecture(File("test/executables/ghcp_windows_amd64")).string,
        'windows_x86-64');
    expect(()=>detectArchitecture(File("test/executables/labuda.txt")),
        throwsA(isA<UnknownArchitectureException>()));
  });
}