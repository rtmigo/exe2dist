// SPDX-FileCopyrightText: (c) 2022 Artsiom iG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

class ExpectedException extends Error {}

class TargetFileAlreadyExistsException extends ExpectedException {
  final File file;

  TargetFileAlreadyExistsException(this.file);

  @override
  String toString() {
    return "$runtimeType: ${file.path}";
  }
}

class ParentDirectoryNotExistsException extends ExpectedException {
  final Directory dir;

  ParentDirectoryNotExistsException(this.dir);

  @override
  String toString() {
    return "$runtimeType: ${dir.path}";
  }
}
