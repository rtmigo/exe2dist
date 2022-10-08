
// SPDX-FileCopyrightText: (c) 2022 Artsiom iG <github.com/rtmigo>
// SPDX-License-Identifier: MIT


import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:yaml/yaml.dart';

final ver = loadYaml(File("pubspec.yaml").readAsStringSync())["version"];
final app = "exe2dist";

String outerName() => "${app}_${Platform.operatingSystem}";

String innerName() => "$app${Platform.isWindows ? '.exe' : ''}";

/// из файла build/ghcp.exe создаём архив build/*.zip, точное имя которого
/// зависит от версии и платформы
void main() {
  final zip = ZipFileEncoder();
  zip.create('build/${outerName()}.zip');
  zip.addFile(File('build/$app.exe'), innerName());
  zip.close();
}