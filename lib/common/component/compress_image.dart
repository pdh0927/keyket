import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage({required File? imageFile}) async {
  if (imageFile == null) return null;

  final tempDir = await getTemporaryDirectory();
  final filePathParts = imageFile.path.split(Platform.pathSeparator);
  final fileNameWithoutExtension = filePathParts.last.split('.').first;
  final fileExtension = filePathParts.last.split('.').last;

  final targetExtension =
      (fileExtension.toLowerCase() == 'png') ? 'png' : 'jpg';

  // 임시 파일 이름에 타임스탬프를 추가하여 고유한 이름을 생성합니다.
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final targetPath =
      '${tempDir.path}${Platform.pathSeparator}$fileNameWithoutExtension-$timestamp.$targetExtension';

  var format = (fileExtension.toLowerCase() == 'png')
      ? CompressFormat.png
      : CompressFormat.jpeg;

  var result = await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    targetPath,
    quality: 50,
    format: format,
  );

  if (result != null) {
    return File(result.path);
  } else {
    return null;
  }
}
