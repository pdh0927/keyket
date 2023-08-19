import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage({required File? imageFile}) async {
  if (imageFile == null) return null;

  final tempDir = await getTemporaryDirectory();
  final filePathParts =
      imageFile.path.split(Platform.pathSeparator); // 경로 구분자를 기준으로 분할
  final fileName = filePathParts.last; // 마지막 요소가 파일 이름
  final targetPath =
      '${tempDir.path}${Platform.pathSeparator}$fileName'; // 원래 파일 이름을 포함하는 경로 생성

  var result = await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    targetPath,
    quality: 50, // 압축 품질 (0 ~ 100)
  );

  return File(result!.path);
}
