import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

abstract class DeviceInfoUtils {
  DeviceInfoUtils._();

  static Future<String> getAOSDeviceType() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    Logger().d("device model ::: ${androidInfo.model}");
    return androidInfo.model;
  }

  static Future<String> getIOSDeviceType() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    Logger().d("device model ::: ${iosInfo.model}");
    return iosInfo.model;
  }

  static Future<String> getAndroidInfo() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    Logger().d("${androidInfo.version}"
        "${androidInfo.board}"
        "${androidInfo.device}");
    return androidInfo.version.sdkInt.toString();
  }

  static Future<String> getIosInfo() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    Logger().d("${iosInfo.name}"
        "${iosInfo.systemName}"
        "${iosInfo.systemVersion}"
        "${iosInfo.model}"
        "${iosInfo.localizedModel}");
    return iosInfo.model;
  }


}