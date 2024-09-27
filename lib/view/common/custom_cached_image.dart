import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCachedImage extends StatefulWidget {
  final String imageUrl;

  CustomCachedImage({required this.imageUrl});

  @override
  _CustomCachedImageState createState() => _CustomCachedImageState();
}

class _CustomCachedImageState extends State<CustomCachedImage> {
  late Future<File?> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = _findFileFromUrl(widget.imageUrl);
  }

  Future<File> _findFileFromUrl(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // 캐시에 파일이 있으면 해당 파일을 로드
          return Image.file(snapshot.data!);
        } else {
          // 캐시에 파일이 없으면 CachedNetworkImage로 로드
          return CachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        }
      },
    );
  }
}