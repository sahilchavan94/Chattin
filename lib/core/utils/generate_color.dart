import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:palette_generator/palette_generator.dart';

Future<List<Color>> generateColors(String imageUrl) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(
    CachedNetworkImageProvider(imageUrl),
  );
  return paletteGenerator.colors.toList();
}
