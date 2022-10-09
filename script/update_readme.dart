// SPDX-FileCopyrightText: (c) 2022 Artsiom iG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:yaml/yaml.dart';

String nowDate() => DateTime.now().toUtc().toString().substring(0, 10);

String gitShortHead() =>
    Process.runSync("git", ["rev-parse", "--short", "HEAD"])
        .stdout
        .toString()
        .trim();

void main() {
  final doc = loadYaml(File("pubspec.yaml").readAsStringSync());
  final version = doc["version"];

  final readmeFile = File("README.md");
  final oldText = readmeFile.readAsStringSync();
  final newText = oldText.replaceAll(
      RegExp("download/[\\d\\.]+/exe2dist"), "download/$version/exe2dist");
  if (newText != oldText) {
    print("Readme changed");
    readmeFile.writeAsStringSync(newText);
  } else {
    print("Readme not changed");
  }
}
