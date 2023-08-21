import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage({required File? imageFile}) async {
  if (imageFile == null) return null;

  final tempDir = await getTemporaryDirectory();
  final filePathParts = imageFile.path.split(Platform.pathSeparator);
  final fileNameWithoutExtension = filePathParts.last.split('.').first;
  final fileExtension = filePathParts.last.split('.').last;

  // 확장자가 png인 경우 출력 파일도 png로 유지
  final targetExtension =
      (fileExtension.toLowerCase() == 'png') ? 'png' : 'jpg';
  final targetPath =
      '${tempDir.path}${Platform.pathSeparator}$fileNameWithoutExtension.$targetExtension';

  var format = (fileExtension.toLowerCase() == 'png')
      ? CompressFormat.png
      : CompressFormat.jpeg;

  var result = await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    targetPath,
    quality: 10,
    format: format,
  );

  return File(result!.path);
}
