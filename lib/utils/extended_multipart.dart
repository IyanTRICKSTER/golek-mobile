import 'dart:io';
import 'package:dio/src/multipart_file.dart';
import 'package:dio/dio.dart';

class MultipartFileExtended extends MultipartFile {
  final String filePath; //this one!

  MultipartFileExtended(
    Stream<List<int>> stream,
    length, {
    filename,
    required this.filePath,
    contentType,
  }) : super(stream, length, filename: filename, contentType: contentType);

  static MultipartFileExtended fromFileSync(
    String filePath, {
    String? filename,
    dynamic contentType,
  }) =>
      multipartFileFromPathSync(filePath, filename: filename, contentType: contentType);
}

MultipartFileExtended multipartFileFromPathSync(
  String filePath, {
  String? filename,
  dynamic contentType,
}) {
  var file = File(filePath);
  var length = file.lengthSync();
  var stream = file.openRead();
  return MultipartFileExtended(
    stream,
    length,
    filename: filename,
    contentType: contentType,
    filePath: filePath,
  );
}
