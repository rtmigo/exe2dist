import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

import 'source/archive.dart';
import 'source/constants.g.dart';
import 'source/expections.dart';

Future<void> main(List<String> arguments) async {
  await mainRun(arguments);
}

class NoFilesFoundException extends ExpectedException {}

Iterable<File> globFiles(List<String> patterns) sync* {
  for (final pattern in patterns) {
    for (final entity in Glob(pattern).listSync()) {
      if (entity
          .statSync()
          .type == FileSystemEntityType.file) {
        yield File(entity.path);
      }
    }
  }
}

Future<void> mainRun(List<String> arguments) async {
  if (arguments.length < 3) {
    print("exe2dist (c) Artsiom iG");
    print("version $buildVersion ($buildDate)");
    print("https://github.com/rtmigo/exe2dist#readme");

    print("");
    print("Usage:");
    print("  exe2dist <program-name> <source-glob> <target-dir>");
    print("");
    print("Examples:");
    print("  exe2dist theapp myfile.exe distros/");
    print("  exe2dist theapp binaries/* distros/");
    exit(64);
  }

  final programName = arguments[0];
  final sourceFilePatterns = arguments.sublist(1, arguments.length-1);
  assert (sourceFilePatterns.length==arguments.length-2);
  final targetDir = Directory(arguments.last);

  try {
    final files = globFiles(sourceFilePatterns).toList();
    if (files.isEmpty) {
      throw NoFilesFoundException();
    }
    for (final file in files) {
      await binaryToDist(
          sourceExe: file,
          programName: programName,
          targetDir: targetDir);
    }
  } on ExpectedException catch (e) {
    stderr.writeln("ERROR: $e");
    exit(1);
  }
}