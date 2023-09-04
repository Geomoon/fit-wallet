import 'package:flutter_riverpod/flutter_riverpod.dart';

final isEditModeProvider = StateProvider.autoDispose<bool>((ref) => false);
