import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTableHead extends ConsumerWidget {
  const CustomTableHead({this.header, super.key});

  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(height: 65, child: header);
  }
}
