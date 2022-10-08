import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

import 'source/archive.dart';
import 'source/constants.g.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 3) {
    print("exe2dist: native binary compression tool");
    print("(c) Artsiom iG <github.com/rtmigo>");
    print("version $buildVersion ($buildDate)");

    print("");
    print("Usage:");
    print("  exe2dist <source-glob> <program-name> <target-dir>");
    print("");
    print("Examples:");
    print("  exe2dist theapp myfile.exe distros/");
    print("  exe2dist theapp binaries/* distros/");
    exit(64);
  }

  final programName = arguments[0];
  final sourceGlob = arguments[1];
  final targetDir = Directory(arguments[2]);

  for (final entity in Glob(sourceGlob).listSync()) {
    if (entity
        .statSync()
        .type == FileSystemEntityType.file) {
      await binaryToDist(
          sourceExe: File(entity.path),
          programName: programName,
          targetDir: targetDir
      );
    }
  }
}

