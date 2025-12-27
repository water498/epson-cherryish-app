import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageInfoUtils {
  PackageInfoUtils._();

  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}(${packageInfo.buildNumber})";
  }

}