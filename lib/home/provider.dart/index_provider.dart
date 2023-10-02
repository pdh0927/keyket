import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexProvider = Provider<int>((ref) {
  return Random().nextInt(10);
});
