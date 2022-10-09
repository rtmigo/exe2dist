import 'dart:io';

import 'package:test/test.dart';

import '../bin/exe2dist.dart';

void main() {
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

  test('glob in quotes', () async {
    // glob pattern was in single quotes, so it was not expanded
    expect(tempDir!.listSync().length, 0);
    await mainRun(["abc", "test/samples/*netbsd*", tempDir!.path]);
    expect(tempDir!.listSync().length, 3);
  });

  test('glob expanded (or multiple files)', () async {
    expect(tempDir!.listSync().length, 0);
    await mainRun(["abc",
      "test/samples/go_linux_386",
      "test/samples/go_linux_arm",
      tempDir!.path]);
    expect(tempDir!.listSync().length, 2);
  });

  test('single file', () async {
    expect(tempDir!.listSync().length, 0);
    await mainRun(["abc", "test/samples/go_linux_386", tempDir!.path]);
    expect(tempDir!.listSync().length, 1);
  });

}