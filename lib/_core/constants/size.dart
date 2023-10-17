import 'package:flutter/material.dart';

// 높이는 그닥 중요하진 않지만 너비는 중요하다!!!
const double smallGap = 5.0;
const double mediumGap = 10.0;
const double largeGap = 20.0;
const double xlargeGap = 100.0;

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// 비율로 크기를 조정해주는 메서드
double getDrawerWidth(BuildContext context) {
  return getScreenWidth(context) * 0.6;
}
