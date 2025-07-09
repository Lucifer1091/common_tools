import '../../../exports/index.dart';

class ImageUploadWidget extends StatelessWidget {
  final double size;
  final double? height;
  final double? width;
  final double radius;
  final String? url;
  final XFile? file;
  final int? accessId;
  final OnImageSelect? onSelection;
  final VoidCallback? onDelete;

  const ImageUploadWidget({
    super.key,
    this.url,
    this.file,
    this.size = 160,
    this.radius = 14,
    this.accessId,
    this.onSelection,
    this.onDelete,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImage.square(
      image: url,
      imageFile: file,
      height: height ?? size,
      width: width ?? size,
      radius: radius,
      showBorder: true,
      topLeft: CornerIcon(
        tooltip: 'Delete',
        icon: EneftyIcons.trash_bold,
        backgroundColor: const Color(0xFFEF5256),
        onTap:
            () => accessId.checkAccess(
              check: accessId != null,
              onSuccess: () async => onDelete?.call(),
            ),
      ),
      topRight: CornerIcon(
        tooltip: 'Gallery',
        icon: EneftyIcons.image_bold,
        backgroundColor: Colors.orange,
        onTap:
            () => accessId.checkAccess(
              check: accessId != null,
              onSuccess:
                  () => ImageSelection.fromGallery(onSelection: onSelection),
            ),
      ),
      bottomLeft:
          UniversalPlatform.isMobile
              ? CornerIcon(
                tooltip: 'Camera',
                icon: EneftyIcons.camera_bold,
                onTap:
                    () => accessId.checkAccess(
                      check: accessId != null,
                      onSuccess:
                          () => ImageSelection.fromCamera(
                            onSelection: onSelection,
                          ),
                    ),
              )
              : null,
      bottomRight: CornerIcon(
        tooltip: 'Library',
        icon: LucideIcons.library,
        backgroundColor: Colors.green,
        onTap:
            () => accessId.checkAccess(
              check: accessId != null,
              onSuccess:
                  () => ImageSelection.fromLibrary(onSelection: onSelection),
            ),
      ),
    );
  }
}
