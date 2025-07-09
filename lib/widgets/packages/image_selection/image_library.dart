import '../../../exports/index.dart';

class ImageLibrary extends StatefulWidget {
  final OnImageSelect? onSelection;

  const ImageLibrary({super.key, this.onSelection});

  @override
  State<ImageLibrary> createState() => _ImageLibraryState();
}

class _ImageLibraryState extends State<ImageLibrary> {
  late TextEditingController searchCtrl;

  late final PagingController<int, ImageModel> _pagingController;
  late final Debouncer _debouncer;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _debouncer = Debouncer(milliseconds: 1000);

    searchCtrl = TextEditingController();
    searchCtrl.addListener(() {
      if (searchCtrl.text.trim().isNotEmpty) {
        _debouncer.run(() {
          _pagingController.refresh();
        });
      }
    });

    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getImages(pageKey);
      final isLastPage = newItems.length < AppUrls.ITEM_COUNT;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey.toInt());
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<ImageModel>> getImages(int pageIndex) async {
    List<ImageModel> images = [];

    await DioClient.request(
      AppUrls.GET_IMAGES,
      RequestType.post,
      data: {
        "recordsPerIndex": AppUrls.ITEM_COUNT,
        "pageIndex": pageIndex.toString(),
        "searchKeyword": searchCtrl.text.trim(),
      },
      onSuccess: (response) async {
        images = ImageModel.listFromJson(response.success());
      },
    );

    return images;
  }

  @override
  dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomDialogAppBar(
          title: 'Image Library',
          actions: SizedBox(width: 40),
          height: 50,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: Sizes.PADDING_16,
              right: Sizes.PADDING_16,
            ),
            child: Column(
              children: [
                CustomTextFormField(
                  maxLength: 40,
                  controller: searchCtrl,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: AppStrings.SEARCH_HINT_TEXT,
                  suffixIconColor: const Color(0xff8e8e93),
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  prefixIcon: EneftyIcons.search_normal_outline,
                  suffixIcon: EneftyIcons.close_circle_bold,
                  onSuffixTap: searchCtrl.clear,
                ),
                const SpaceH12(),
                Expanded(
                  child: PagedGridView(
                    shrinkWrap: true,
                    pagingController: _pagingController,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<ImageModel>(
                      itemBuilder: (__, image, _) => InkWell(
                        onTap: () {
                          if (widget.onSelection != null) {
                            widget.onSelection?.call(image);
                            Get.close(1);
                          } else {
                            Get.back(result: image);
                          }
                        },
                        child: ImageCard(image: image),
                      ),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CustomLoader()),
                      newPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CustomLoader()),
                      firstPageErrorIndicatorBuilder: (context) =>
                          ErrorIndicator(
                        error: _pagingController.error,
                        onTryAgain: () => _pagingController.refresh(),
                      ),
                      noItemsFoundIndicatorBuilder: (context) =>
                          const EmptyListIndicator(),
                      newPageErrorIndicatorBuilder: (context) => const Center(
                        child: CustomLoader(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final ImageModel image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: const Color.fromARGB(120, 0, 0, 0),
        title: Text(
          image.name ?? '',
          style: context.bodyMedium.copyWith(color: Colors.white),
          maxLines: 1,
        ),
      ).constrainedBox(maxHeight: 30).tooltip(
            msg: image.name,
            showRichText: true,
          ),
      child: CustomImage.square(
        image: image.imageUrl,
        radius: 0,
        height: double.maxFinite,
        width: double.maxFinite,
        backgroundColor: Colors.red,
        fit: BoxFit.contain,
      ),
    );
  }
}
