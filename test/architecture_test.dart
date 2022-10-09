import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../bin/source/architecture.dart';

void main() {
  test("detecting architecture 1", () {
    expect(detectArchitecture(File("test/executables/ghcp_linux_amd64")).combined,
        'linux_amd64');
    expect(detectArchitecture(File("test/executables/ghcp_osx_amd64")).combined,
        'darwin_amd64');
    expect(detectArchitecture(File("test/executables/ghcp_windows_amd64")).combined,
        'windows_amd64');
    expect(()=>detectArchitecture(File("test/executables/labuda.txt")),
        throwsA(isA<UnknownArchitectureException>()));
  });

  test("detecting architecture 2", () {
    for (final file in  Directory("test/samples").listSync()) {
      if (file.statSync().type!=FileSystemEntityType.file) {
        continue;
      }
      final archFromGox =
        path.basenameWithoutExtension(file.path).split("_").sublist(1).join("_");
      final goOs = archFromGox.split("_")[0];
      final String goCpu;
      switch (archFromGox.split("_")[1]) {
        case "arm":
          goCpu = "arm32";
          break;
        case "386":
          goCpu = "i386";
          break;

        default:
          goCpu = archFromGox.split("_")[1];
      }

      final arch = detectArchitecture(File(file.path));

      print("$file $archFromGox ${arch.combined}");
      expect(arch.os, goOs);
      expect(arch.platform, goCpu);
    }
  });
}