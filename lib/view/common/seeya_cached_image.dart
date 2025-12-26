import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/cache/seeya_cache_managers.dart';

/// Seeya 앱 전용 캐시 이미지 위젯
///
/// 자동으로 최적화된 캐시 설정 적용:
/// - memCacheWidth/Height: 메모리 최적화
/// - 디스크 캐시: 원본 이미지 저장 (URL별 단일 캐시)
/// - placeholder: 로딩 애니메이션
/// - errorWidget: 에러 시 폴백
class SeeyaCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final double? width;
  final double? height;
  final double? memCacheMultiplier;

  const SeeyaCachedImage({
    required this.imageUrl,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.memCacheMultiplier = 2.0,
    super.key,
  });

  /// 메모리 캐시 크기 계산
  /// - width/height가 지정되면 그 크기의 2배
  /// - 없으면 기본값 (1200x1800)
  int? get _memCacheWidth {
    if (width != null) {
      return (width! * memCacheMultiplier!).toInt();
    }
    return 1200;
  }

  int? get _memCacheHeight {
    if (height != null) {
      return (height! * memCacheMultiplier!).toInt();
    }
    return 1800;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: SeeyaCacheManagers.instance,
      fit: fit ?? BoxFit.cover,
      memCacheWidth: _memCacheWidth,
      memCacheHeight: _memCacheHeight,
      // maxWidthDiskCache/maxHeightDiskCache 제거:
      // 디스크 캐시는 원본 이미지를 저장하여 모든 크기에서 재사용
      placeholder: placeholder ??
          (context, url) => Image.asset("assets/image/loading02.gif"),
      errorWidget: errorWidget ??
          (context, url, error) {
            // 에러 로깅
            print('❌ SeeyaCachedImage ERROR: $error');
            print('   URL: $url');

            // 에러 표시 (로딩 gif 대신 빨간 에러 아이콘)
            return const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            );
          },
    );
  }
}
