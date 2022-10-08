import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;

import 'architecture.dart';

Future<void> fileToGzip(File source, File targetGzip) async {
  final input = InputFileStream(source.path);
  try {
    final output = OutputFileStream(targetGzip.path);
    try {
      GZipEncoder().encode(input, output: output, level: 9);
    } finally {
      await output.close();
    }
  } finally {
    await input.close();
  }
}

void fileToTar(File source, String entryName, File targetTar) {
  final tar = TarFileEncoder();
  tar.create(targetTar.path);
  tar.addFile(source, entryName);
  tar.close();
}

Future<void> fileToTarGz(File source, String entryName, File targetTgz) async {
  final tempDir =
      Directory(path.dirname(targetTgz.absolute.path)).createTempSync();
  assert(tempDir.existsSync());
  try {
    final tempTar = File(path.join(tempDir.path, "temp.tar"));
    fileToTar(source, entryName, tempTar);
    await fileToGzip(tempTar, targetTgz);
  } finally {
    assert(tempDir.existsSync());
    tempDir.deleteSync(recursive: true);
  }
}

Future<void> toZip(File sourceFile, String entryName, File zipFile) async {
  if (!zipFile.path.endsWith(".zip")) {
    throw ArgumentError(zipFile);
  }
  if (zipFile.existsSync()) {
    throw ArgumentError("File $zipFile already exists.");
  }

  final zip = ZipFileEncoder();
  zip.create(zipFile.path);
  zip.addFile(sourceFile, entryName);
  zip.close();
}

class TempExeWithPermissions {
  final File _sourceExe;

  late Directory _tempDir;
  late File _readyExe;
  File get readyExe => _readyExe;

  TempExeWithPermissions(this._sourceExe) {
    _tempDir =
        Directory(path.dirname(_sourceExe.absolute.path)).createTempSync();
    _readyExe = File(path.join(_tempDir.path, "executable"));
    _sourceExe.copySync(_readyExe.path);
    Process.runSync("chmod", ["755", _readyExe.path]);
  }

  void close() {
    _tempDir.deleteSync(recursive: true);
  }
}

class TargetFileAlreadyExistsException extends Error {
  final File file;
  TargetFileAlreadyExistsException(this.file);
}

Future<void> binaryToDist(
    {required File sourceExe,
    required String programName,
    required Directory targetDir}) async {
  print("* Source: ${sourceExe.path}");

  final arch = detectArchitecture(sourceExe);

  late final String entryName;
  late final String arcSuffix;
  late final Function(File, String, File) arcFunc;

  final exeWithPermissions = TempExeWithPermissions(sourceExe);
  try {
    if (arch.isWindows) {
      entryName = "$programName.exe";
      arcSuffix = ".zip";
      arcFunc = toZip;
    } else {
      entryName = programName;
      arcSuffix = ".tgz";
      arcFunc = fileToTarGz;
    }
    final targetFile = File(
        path.join(targetDir.path, "${programName}_${arch.string}$arcSuffix"));
    if (targetFile.existsSync()) {
      throw TargetFileAlreadyExistsException(targetFile);
    }
    print("  Target: ${targetFile.path}");
    await arcFunc(exeWithPermissions.readyExe, entryName, targetFile);
    print("  Created successfully");
  } finally {
    exeWithPermissions.close();
  }
}
