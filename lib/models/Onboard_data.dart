import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class UnbordingContent {
  String image;
  String title;
  String discription;
  Color backgroundColor;
  UnbordingContent({
    required this.image,
    required this.title,
    required this.discription,
    required this.backgroundColor,
  });
}

// Created By Flutter Baba
List<UnbordingContent> contentsList = [
  UnbordingContent(
    backgroundColor: color,
    title: "Chat anytime, anywere",
    image: 'images/im2.svg',
    discription:
        "Passing of any information on any screen, any device instantly is made simple at its sublime.",
  ),
  UnbordingContent(
    backgroundColor: color,
    title: 'Work Seamlessly',
    image: 'images/im4.svg',
    discription: "Get your work done seamlessly without interruption",
  ),
  UnbordingContent(
    backgroundColor: color,
    title: 'Your space in your dream',
    image: 'images/im1.svg',
    discription:
        "A lag-free video chat connection between your users is easy and much everywhere on any device.",
  ),
  UnbordingContent(
    backgroundColor: color,
    title: 'Perfect chat solution',
    image: 'images/im3.svg',
    discription: "Your space in your dream ",
  ),
];
