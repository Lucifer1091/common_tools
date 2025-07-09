import 'package:back_office/exports/index.dart';

class UploadNewImage extends StatefulWidget {
  final XFile image;

  const UploadNewImage({super.key, required this.image});

  @override
  State<UploadNewImage> createState() => _UploadNewImageState();
}

class _UploadNewImageState extends State<UploadNewImage> {
  late XFile image;
  late GlobalKey<FormState>? formKey;
  late TextEditingController ctrl;

  @override
  void initState() {
    image = widget.image;
    formKey = GlobalKey<FormState>();
    ctrl = TextEditingController(text: image.name);
    super.initState();
  }

  void saveImage() async {
    if (formKey.isValid()) {
      await LoadingOverlay.show(
        future: () async {
          await DioClient.request(
            AppUrls.UPLOAD_IMAGE,
            RequestType.post,
            data: await DioClient.formData(
              filesAsMap: {'imageFile': image},
              data: {'itemName': ctrl.text.trim()},
            ),
            onSuccess: (response) async {
              ImageModel result = ImageModel.fromJson(response.success());
              SnackBars.success(message: 'Image uploaded successfully!');

              Get.back(result: result, closeOverlays: true);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDialogAppBar(
          title: 'Upload Image',
          height: 50,
          actions: TextButton(
            onPressed: saveImage,
            child: const Text('Upload'),
          ),
        ),
        const SpaceH20(),
        CustomImage.square(
          imageFile: image,
          height: Sizes.HEIGHT_160,
          width: Sizes.WIDTH_160,
          showBorder: true,
        ),
        const SpaceH20(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_12),
          child: Form(
            key: formKey,
            child: CustomTextFormField(
              isRequired: true,
              maxLength: 40,
              controller: ctrl,
              labelText: 'Image Name',
              prefixIcon: EneftyIcons.image_outline,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: Validators.max(title: 'Image Name', max: 40).call,
              onFieldSubmit: (s) => saveImage(),
            ),
          ),
        ),
      ],
    );
  }
}
