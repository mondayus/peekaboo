import 'package:flutter/material.dart';
import '../common.dart';
import 'package:peekaboo/common/dart/extension/context_extension.dart';


class VerticalLine extends StatelessWidget {
  const VerticalLine({
    Key? key,
    this.color,
    this.width = 1,
    this.margin,
  }) : super(key: key);

  final Color? color;
  final EdgeInsets? margin;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      color: color ?? context.appColors.divider,
      width: width,
    );
  }
}
