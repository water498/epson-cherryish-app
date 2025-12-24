# Google Maps Migration Plan

## 📋 Current Status

- ✅ `google_maps_flutter: ^2.14.0` added to pubspec.yaml
- ✅ Android API key configured in AndroidManifest.xml
- ✅ iOS API key configured in AppDelegate.swift (GMSServices.provideAPIKey)
- ⏳ Migration in progress

## 🎯 Migration Overview

Replacing Naver Maps implementation with Google Maps Flutter while maintaining all existing features.

### Key Features to Migrate

1. **Custom Marker Images** - Load PNG from S3, convert to BitmapDescriptor
2. **Distance-based Clustering** - 15m radius clustering algorithm
3. **Marker Size Animation** - 50x50 (normal) ↔ 80x80 (selected)
4. **Location Tracking** - 5m update filter with camera following
5. **Camera Controls** - Zoom, position, animations
6. **Search & Sort** - Keyword search, date/review sorting
7. **Draggable Bottom Sheet** - 40%-100% height with marker list

## 📦 Current Implementation Analysis

### Files to Modify

1. **lib/controller/map_tab_controller.dart** (PRIMARY - 300+ lines)
   - NaverMapController → GoogleMapController
   - Custom marker loading and caching
   - Clustering logic (15m distance-based)
   - Location tracking with Geolocator
   - Marker tap handling

2. **lib/view/tab_map/map_tab_screen.dart** (SECONDARY - UI)
   - NaverMap widget → GoogleMap widget
   - OnMapCreated callback
   - CameraPosition setup
   - UI layer (search, buttons, bottom sheet)

### Dependencies (Keep These)

```yaml
dependencies:
  geolocator: ^13.0.2              # Location tracking
  cached_network_image: ^3.4.1    # Image caching
  get: ^4.6.6                      # State management
```

## ✅ Migration Checklist

### Phase 1: Utilities & Helpers (1-2 hours)

- [ ] **Create `lib/utils/marker_icon_cache.dart`**
  - Bitmap conversion helper
  - Size-based caching (50x50, 80x80)
  - S3 image loading integration

### Phase 2: Controller Migration (3-4 hours)

- [ ] **Update `lib/controller/map_tab_controller.dart`**
  - [ ] Replace NaverMapController with GoogleMapController (Completer pattern)
  - [ ] Update `updateMarker()` method
  - [ ] Migrate `updateCamera()` method
  - [ ] Fix `onMapTap()` handler
  - [ ] Update `onMarkerTab()` method
  - [ ] Replace all `NLatLng` with `LatLng`
  - [ ] Update location tracking logic
  - [ ] Test clustering algorithm

### Phase 3: View Migration (1-2 hours)

- [ ] **Update `lib/view/tab_map/map_tab_screen.dart`**
  - [ ] Replace NaverMap widget with GoogleMap
  - [ ] Update onMapCreated callback
  - [ ] Fix initialCameraPosition
  - [ ] Test UI controls (myLocationButton, zoomControls)
  - [ ] Verify bottom sheet integration

### Phase 4: Testing (1-2 hours)

- [ ] Test marker loading performance
- [ ] Verify clustering at various zoom levels
- [ ] Test marker tap animations (50x50 ↔ 80x80)
- [ ] Verify location tracking accuracy
- [ ] Test search and sort functionality
- [ ] Check camera animations
- [ ] Memory leak testing (marker disposal)

## 🔧 Implementation Guide

### 1. MarkerIconCache Utility

Create `lib/utils/marker_icon_cache.dart`:

```dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:seeya/utils/file_utils.dart';

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

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      // Use existing FileUtils to get cached image
      final file = await FileUtils.findFileFromUrl(imageUrl);
      final bytes = await file.readAsBytes();

      // Decode and resize
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: width,
        targetHeight: height,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      final resizedBytes = data!.buffer.asUint8List();

      final bitmapDescriptor = BitmapDescriptor.fromBytes(resizedBytes);
      _cache[cacheKey] = bitmapDescriptor;

      Logger().d('[MarkerIconCache] Cached: $cacheKey');
      return bitmapDescriptor;

    } catch (e, stackTrace) {
      Logger().e('[MarkerIconCache] Error loading $imageUrl: $e');
      Logger().e(stackTrace);

      // Return default marker on error
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// Clear all cached icons
  static void clearCache() {
    _cache.clear();
    Logger().d('[MarkerIconCache] Cache cleared');
  }
}
```

### 2. Controller Migration

Update `lib/controller/map_tab_controller.dart`:

```dart
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seeya/utils/marker_icon_cache.dart';

class MapTabController extends GetxController {
  // BEFORE: NaverMapController? mapController;
  // AFTER:
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? get mapController =>
      _mapController.isCompleted ? _mapController.future.value : null;

  // Markers set (observable)
  var markers = <Marker>{}.obs;

  // Selected marker ID
  var selectedMarkerId = Rxn<String>();

  // Camera position
  var currentPosition = const LatLng(37.5665, 126.9780).obs; // Seoul default

  @override
  void onInit() {
    super.onInit();
    // Initialize location tracking
    _startLocationTracking();
  }

  /// Called when map is created
  void onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
      Logger().d('[MapTabController] Map created');
    }
  }

  /// Update markers on map
  Future<void> updateMarker() async {
    try {
      final newMarkers = <Marker>{};

      // Apply clustering
      final clusteredItems = _applyDistanceClustering(
        placeList.value?.place ?? [],
        15.0, // 15m radius
      );

      for (var item in clusteredItems) {
        final isSelected = selectedMarkerId.value == item.id.toString();
        final iconSize = isSelected ? 80 : 50;

        // Load custom icon
        final icon = await MarkerIconCache.getMarkerIcon(
          "${AppSecret.s3url}${item.category?.marker_icon_filepath ?? ''}",
          width: iconSize,
          height: iconSize,
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId(item.id.toString()),
            position: LatLng(item.latitude!, item.longitude!),
            icon: icon,
            onTap: () => onMarkerTap(item),
          ),
        );
      }

      markers.value = newMarkers;
      Logger().d('[MapTabController] Updated ${newMarkers.length} markers');

    } catch (e, stackTrace) {
      Logger().e('[MapTabController] updateMarker error: $e');
      Logger().e(stackTrace);
    }
  }

  /// Handle marker tap
  void onMarkerTap(Place item) {
    selectedMarkerId.value = item.id.toString();
    updateMarker(); // Refresh to show size change

    // Move camera to marker
    updateCamera(
      lat: item.latitude!,
      lng: item.longitude!,
      zoom: 16.0,
    );

    // Update bottom sheet selection
    selectedPlace.value = item;
  }

  /// Update camera position
  Future<void> updateCamera({
    required double lat,
    required double lng,
    double? zoom,
  }) async {
    try {
      final controller = await _mapController.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: zoom ?? 14.0,
          ),
        ),
      );

      currentPosition.value = LatLng(lat, lng);

    } catch (e) {
      Logger().e('[MapTabController] updateCamera error: $e');
    }
  }

  /// Distance-based clustering (15m radius)
  List<Place> _applyDistanceClustering(List<Place> places, double radiusMeters) {
    if (places.isEmpty) return [];

    final clustered = <Place>[];
    final processed = <int>{};

    for (int i = 0; i < places.length; i++) {
      if (processed.contains(i)) continue;

      final place = places[i];
      processed.add(i);
      clustered.add(place);

      // Mark nearby places as processed
      for (int j = i + 1; j < places.length; j++) {
        if (processed.contains(j)) continue;

        final other = places[j];
        final distance = Geolocator.distanceBetween(
          place.latitude!,
          place.longitude!,
          other.latitude!,
          other.longitude!,
        );

        if (distance <= radiusMeters) {
          processed.add(j);
        }
      }
    }

    Logger().d('[Clustering] ${places.length} → ${clustered.length} (${radiusMeters}m radius)');
    return clustered;
  }

  /// Start location tracking
  void _startLocationTracking() {
    // Existing Geolocator logic - KEEP AS IS
    // Just update camera to use LatLng instead of NLatLng
  }

  @override
  void onClose() {
    MarkerIconCache.clearCache();
    super.onClose();
  }
}
```

### 3. View Migration

Update `lib/view/tab_map/map_tab_screen.dart`:

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTabScreen extends GetView<MapTabController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.currentPosition.value,
              zoom: 14.0,
            ),
            onMapCreated: controller.onMapCreated,
            markers: controller.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Custom button
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (LatLng position) {
              // Deselect marker
              controller.selectedMarkerId.value = null;
              controller.updateMarker();
            },
          )),

          // Search bar overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: _buildSearchBar(),
          ),

          // My location button
          Positioned(
            right: 16,
            bottom: 200,
            child: _buildMyLocationButton(),
          ),

          // Draggable bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }
}
```

## 🚨 API Mapping Reference

| Naver Maps | Google Maps | Notes |
|------------|-------------|-------|
| `NaverMapController` | `GoogleMapController` | Use Completer pattern |
| `NLatLng(lat, lng)` | `LatLng(lat, lng)` | Direct replacement |
| `NMarker(id: ...)` | `Marker(markerId: MarkerId(...))` | Different constructor |
| `marker.icon = NOverlayImage.fromFile(...)` | `icon: BitmapDescriptor.fromBytes(...)` | Needs conversion |
| `mapController.updateCamera(...)` | `controller.animateCamera(CameraUpdate.newCameraPosition(...))` | Async |
| `onMapTapped` | `onTap: (LatLng position)` | Callback parameter |
| `onMarkerTapped` | `marker.onTap: () { ... }` | Per-marker callback |

## 🧪 Testing Checklist

After migration, verify:

1. [ ] Markers load from S3 correctly
2. [ ] Clustering works at 15m radius
3. [ ] Marker tap changes size (50→80, 80→50)
4. [ ] Camera follows location updates (5m filter)
5. [ ] Search filters markers correctly
6. [ ] Sort changes marker display order
7. [ ] Bottom sheet shows correct place data
8. [ ] No memory leaks (check marker disposal)
9. [ ] Performance: marker load time < 500ms
10. [ ] iOS and Android both working

## 📝 Known Issues & Solutions

### Issue 1: Marker Icon Flickering
- **Cause**: Recreating BitmapDescriptor on every update
- **Solution**: Use MarkerIconCache with persistent cache

### Issue 2: Slow Marker Loading
- **Cause**: S3 network requests not cached
- **Solution**: FileUtils already caches files, reuse that

### Issue 3: Clustering Not Working
- **Cause**: Geolocator.distanceBetween precision
- **Solution**: Use 15.0m threshold, not 15 (integer)

## 🔗 References

- [google_maps_flutter Documentation](https://pub.dev/packages/google_maps_flutter)
- [Custom Marker Icons Guide](https://pub.dev/packages/google_maps_flutter#adding-custom-markers)
- [BitmapDescriptor API](https://pub.dev/documentation/google_maps_flutter_platform_interface/latest/google_maps_flutter_platform_interface/BitmapDescriptor-class.html)

## 📅 Estimated Timeline

- **Phase 1 (Utilities)**: 1-2 hours
- **Phase 2 (Controller)**: 3-4 hours
- **Phase 3 (View)**: 1-2 hours
- **Phase 4 (Testing)**: 1-2 hours
- **Total**: 6-10 hours

## 🎯 Success Criteria

Migration is complete when:

1. All Naver Maps code removed
2. All features working identically
3. No performance degradation
4. Both platforms (iOS/Android) tested
5. No console errors or warnings

---

**Last Updated**: 2025-12-24
**Status**: Planning Complete - Ready to Execute
