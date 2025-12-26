import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Seeya 앱 전용 이미지 캐시 매니저
///
/// - 14일 보존
/// - 최대 500개 이미지 캐싱
/// - 모든 이미지 타입에 동일한 정책 적용
/// - ImageCacheManager 믹스인으로 이미지 리사이징 지원
class SeeyaCacheManagers extends CacheManager with ImageCacheManager {
  // Singleton factory
  factory SeeyaCacheManagers() {
    return _instance;
  }

  // Private constructor
  SeeyaCacheManagers._() : super(
    Config(
      'seeya_image_cache',
      stalePeriod: const Duration(days: 14),  // 14일 후 자동 삭제
      maxNrOfCacheObjects: 500,              // 최대 500개 캐싱
    ),
  );

  static final SeeyaCacheManagers _instance = SeeyaCacheManagers._();

  // Static getter for backward compatibility
  static SeeyaCacheManagers get instance => _instance;

  // 모든 캐시 삭제 (설정 메뉴에서 사용 가능)
  static Future<void> clearCache() async {
    await _instance.emptyCache();
  }
}
