import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  Gap({super.key, this.height, this.width});
  double? width;
  double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
    );
  }
}
