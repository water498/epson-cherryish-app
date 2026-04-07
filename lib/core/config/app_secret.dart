import 'package:flutter/material.dart';

abstract class AppSecret {
  AppSecret._();

  static const s3url = "https://seeya-jp-bucket.s3.ap-northeast-1.amazonaws.com/";
  static const clientDomain = "https://www.seeya-printer.com";
  static const baseUrl = "https://api-v2.seeya-printer.com"; // EC2
  // static const baseUrl = "http://10.170.30.45:3105"; // fastfive desktop private wifi
  // static const baseUrl = "http://127.0.0.1:8000"; // local
  // static const baseUrl = "http://118.129.66.45:3105"; // desktop public
  static const apiKey = "fae5837c-41a2-4c5d-8da7-5217877c07df";
  static const kakaoNativeAppKey = "8c56e9cb2a0df45451f9db497d5f3350";

  static const googleMapApiKey = "AIzaSyBQ6PPTKT5UTIAywAhIXo6ED2_hFAWiK14";

}