import 'dart:io';

import 'package:test/test.dart';

import '../bin/source/architecture.dart';
import '../bin/source/archive.dart';

import 'package:path/path.dart' as path;

void main() {
  // TODO test that packed *nix executables have read permission

  Directory? tempDir;
  setUp(() {
    assert(tempDir==null);
    tempDir = Directory.systemTemp.createTempSync();
  });

  tearDown(() {
    try {
      tempDir!.deleteSync(recursive: true);
      tempDir=null;
    } on OSError catch(_) {
      // windows
    }
  });

  test("linux", () async {
    await binaryToDist(
      sourceExe: File("test/executables/ghcp_linux_amd64"),
      programName: "abc",
      targetDir: tempDir!
    );

    expect(tempDir!.listSync().map((e) => path.basename(e.path)).toList(),
        ['abc_linux_amd64.tgz']);
  });

  test("macos", () async {
    await binaryToDist(
        sourceExe: File("test/executables/ghcp_osx_amd64"),
        programName: "abc",
        targetDir: tempDir!
    );

    expect(tempDir!.listSync().map((e) => path.basename(e.path)).toList(),
        ['abc_darwin_amd64.tgz']);
  });

  test("windows", () async {
    await binaryToDist(
        sourceExe: File("test/executables/ghcp_windows_amd64"),
        programName: "abc",
        targetDir: tempDir!
    );

    expect(tempDir!.listSync().map((e) => path.basename(e.path)).toList(),
        ['abc_windows_amd64.zip']);
  });
}