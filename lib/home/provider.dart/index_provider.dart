import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexProvider = StateProvider<int>((ref) {
  return Random().nextInt(10);
});
