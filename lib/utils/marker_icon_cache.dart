import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:seeya/utils/file_utils.dart';

/// Cache for converting S3 images to Google Maps BitmapDescriptor
/// Supports multiple sizes (50x50 normal, 80x80 selected)
class MarkerIconCache {
  static final Map<String, BitmapDescriptor> _cache = {};

  /// Loads and converts image from S3 URL to BitmapDescriptor
  /// Caches by key: "${url}_${width}_${height}"
  static Future<BitmapDescriptor> getMarkerIcon(
    String imageUrl, {
    int width = 50,
    int height = 50,
  }) async {
    final cacheKey = "${imageUrl}_${width}_${height}";

    // Return cached icon if available
    if (_cache.containsKey(cacheKey)) {
      Logger().d('[MarkerIconCache] Cache hit: $cacheKey');
      return _cache[cacheKey]!;
    }

    try {
      Logger().d('[MarkerIconCache] Loading: $imageUrl (${width}x${height})');

      // Use existing FileUtils to get cached image file
      final file = await FileUtils.findFileFromUrl(imageUrl);
      final bytes = await file.readAsBytes();

      // Decode and resize image
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: width,
        targetHeight: height,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

      if (data == null) {
        throw Exception('Failed to convert image to bytes');
      }

      final resizedBytes = data.buffer.asUint8List();

      // Create BitmapDescriptor
      final bitmapDescriptor = BitmapDescriptor.fromBytes(resizedBytes);

      // Cache it
      _cache[cacheKey] = bitmapDescriptor;

      Logger().i('[MarkerIconCache] Cached: $cacheKey (${resizedBytes.length} bytes)');
      return bitmapDescriptor;

    } catch (e, stackTrace) {
      Logger().e('[MarkerIconCache] Error loading $imageUrl: $e');
      Logger().e(stackTrace);

      // Return default marker on error
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// Preload marker icons for better performance
  static Future<void> preloadIcons(List<String> imageUrls) async {
    Logger().d('[MarkerIconCache] Preloading ${imageUrls.length} icons');

    final futures = <Future<void>>[];

    for (final url in imageUrls) {
      // Preload both sizes
      futures.add(getMarkerIcon(url, width: 50, height: 50).then((_) {}));
      futures.add(getMarkerIcon(url, width: 80, height: 80).then((_) {}));
    }

    await Future.wait(futures);
    Logger().i('[MarkerIconCache] Preloaded ${_cache.length} icons');
  }

  /// Clear all cached icons
  static void clearCache() {
    final count = _cache.length;
    _cache.clear();
    Logger().d('[MarkerIconCache] Cache cleared ($count icons removed)');
  }

  /// Get current cache size
  static int get cacheSize => _cache.length;
}
