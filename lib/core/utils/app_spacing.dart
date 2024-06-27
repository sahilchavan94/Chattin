import 'package:flutter/material.dart';

verticalSpacing(double givenHeight) {
  return SizedBox(
    height: givenHeight,
    width: 0,
  );
}

horizontalSpacing(double givenWidth) {
  return SizedBox(
    width: givenWidth,
    height: 0,
  );
}
