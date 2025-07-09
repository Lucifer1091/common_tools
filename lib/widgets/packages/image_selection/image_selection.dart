import '../../../exports/index.dart';

typedef OnImageSelect = void Function(ImageModel image);

class ImageSelection {
  ImageSelection._();

  static Future<ImageModel?> fromLibrary({OnImageSelect? onSelection}) async {
    return Responsive.isMobile()
        ? await SnackBars.bottomSheet<ImageModel?>(
            isScrollControlled: true,
            color: Colors.transparent,
            duration: Durations.short1,
            showDivider: false,
            bottomSheet: ImageLibrary(onSelection: onSelection),
            maxHeight: Get.size.height * 0.95,
            maxWidth: 600.0,
          )
        : await Dialogs.custom<ImageModel?>(
            isDialogScrollable: true,
            width: 400.0,
            height: 622.0,
            content: Padding(
              padding: const EdgeInsets.only(top: Sizes.PADDING_12),
              child: ImageLibrary(onSelection: onSelection),
            ),
            saveButtonText: AppStrings.APPLY,
          );
  }

  static Future<ImageModel?> fromGallery({OnImageSelect? onSelection}) async {
    return _picker(
      onSelection: onSelection,
      imageSource: ImageSource.gallery,
    );
  }

  static Future<ImageModel?> fromCamera({OnImageSelect? onSelection}) async {
    return _picker(
      onSelection: onSelection,
      imageSource: ImageSource.camera,
    );
  }

  static Future<ImageModel?> _picker({
    OnImageSelect? onSelection,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    XFile? image = await FileService.showFilePickerPopup(
      imageSource: imageSource,
    );

    if (image != null) {
      Dialogs.custom(
        isDialogScrollable: true,
        width: 400.0,
        height: 360.0,
        content: UploadNewImage(image: image),
      ).then((value) {
        if (value != null) {
          if (onSelection != null) onSelection.call(value);

          return value;
        }
      });
    }

    return null;
  }
}
