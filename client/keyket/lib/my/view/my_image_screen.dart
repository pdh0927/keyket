// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'my_screen.dart';

// class PickImage extends StatefulWidget {
//   const PickImage({super.key});

//   @override
//   State<PickImage> createState() => _PickImageState();
// }

// class _PickImageState extends State<PickImage> {
//   XFile? _image;
//   final ImagePicker picker = ImagePicker();

//   Future pickImage(ImageSource imageSource) async {
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource);
//     if (pickedFile != null) {
//       setState(() {
//         _image = XFile(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExamplePage();
//   }

//   Widget _buildPhotoArea() {
//     return _image != null
//         ? Container(
//             width: 100,
//             height: 100,
//             child: Image.file(File(_image!.path)),
//           )
//         : Container(
//             width: 100,
//             height: 100,
//             color: Colors.grey,
//           );
//   }

//   // Widget _buildButton() {
//   //   return Scaffold(
//   //     body: SafeArea(
//   //       child: Column(
//   //         children: <Widget>[
//   //           FloatingActionButton(
//   //             onPressed: () {
//   //               pickImage(ImageSource.gallery);
//   //             },
//   //             child: Text('앨범에서 사진 선택하기'),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
