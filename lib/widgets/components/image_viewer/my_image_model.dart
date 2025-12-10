class MyImageModel {
  MyImageModel({required this.id, required this.source, required this.index});

  // index in list of image
  final int index;

  // id image (image url) to use in hero animation
  final String id;

  // image url
  final Object? source;
}
