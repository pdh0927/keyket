import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/provider/my_provider.dart';
import 'divide_line.dart';

class MyImage extends ConsumerStatefulWidget {
  const MyImage({super.key});

  @override
  ConsumerState<MyImage> createState() => _MyImageState();
}

class _MyImageState extends ConsumerState<MyImage> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future<String?> pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(() {
          _image = XFile(pickedFile.path);
        });
        return pickedFile.path;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ImageCircle();
  }

  // 이미지 가져오는 부분
  takeImage(mContext) {
    return ref.watch(myInformationProvider)!.image == ''
        ? showDialog(
            barrierColor: const Color(0xff616161).withOpacity(0.2),
            context: mContext,
            builder: (context) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color(0xff616161),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SimpleDialogOption(
                        child: Text(
                          '프로필 사진 설정',
                          style: TextStyle(
                            fontFamily: 'SCDream',
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const DividePopUp(),
                      SimpleDialogOption(
                        child: const Text(
                          '앨범에서 사진 선택하기',
                          style: TextStyle(
                            fontFamily: 'SCDream',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          String? imagePath =
                              await pickImage(ImageSource.gallery);
                          if (imagePath == null) {
                            ref
                                .read(myInformationProvider.notifier)
                                .changeImage('');
                          } else {
                            ref
                                .read(myInformationProvider.notifier)
                                .changeImage(imagePath);
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              );
            })
        : showDialog(
            barrierColor: const Color(0xff616161).withOpacity(0.2),
            context: mContext,
            builder: (context) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color(0xff616161),
                title: const Text(
                  '프로필 사진 설정',
                  style: TextStyle(
                    fontFamily: 'SCDream',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const DividePopUp(),
                      SimpleDialogOption(
                        child: const Text(
                          '앨범에서 사진 선택하기',
                          style: TextStyle(
                            fontFamily: 'SCDream',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          String? imagePath =
                              await pickImage(ImageSource.gallery);
                          if (imagePath == null) {
                            ref
                                .read(myInformationProvider.notifier)
                                .changeImage('');
                          } else {
                            ref
                                .read(myInformationProvider.notifier)
                                .changeImage(imagePath);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      const DividePopUp(),
                      SimpleDialogOption(
                        child: const Text(
                          '기본 이미지로 선택하기',
                          style: TextStyle(
                            fontFamily: 'SCDream',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          await ref
                              .read(myInformationProvider.notifier)
                              .changeImage('');

                          setState(() {
                            _image = null;
                            // File(_image!.path).delete(); ////////// 이 부분 덜함
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
  }

  // 사진 띄우는 부분
  ImageCircle() {
    if (_image == null && ref.watch(myInformationProvider)!.image == '') {
      return SizedBox(
        width: 100,
        height: 100,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0XFF616161).withOpacity(0.2),
          ),
          child: GestureDetector(
            onTap: () {
              takeImage(context);
            },
            child: Icon(
              Remix.user_fill,
              size: 60,
              color: const Color(0XFF3498DB).withOpacity(0.8),
            ),
          ),
        ),
      );
    } else if (_image == null &&
        ref.watch(myInformationProvider)!.image != '') {
      return GestureDetector(
        onTap: () {
          takeImage(context);
        },
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: ref.watch(myInformationProvider)!.image,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundImage: Image.file(File(_image!.path)).image,
        child: GestureDetector(
          onTap: () {
            takeImage(context);
          },
        ),
      );
    }
  }
}
