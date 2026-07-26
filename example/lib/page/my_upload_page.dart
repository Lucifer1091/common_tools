import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../base/example_widget.dart';

class MyUploadPage extends StatefulWidget {
  const MyUploadPage({super.key});

  @override
  State<StatefulWidget> createState() => MyUploadState();
}

class MyUploadState extends State<MyUploadPage> {
  final List<MyUploadFile> files1 = [];
  final List<MyUploadFile> files2 = [
    MyUploadFile(
      id: 1,
      source: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
    MyUploadFile(
      id: 2,
      source: 'https://tdesign.gtimg.com/demo/images/example2.png',
    ),
    MyUploadFile(
      id: 3,
      source: 'https://tdesign.gtimg.com/demo/images/example3.png',
    ),
  ];
  final List<MyUploadFile> files3 = [
    MyUploadFile(
      id: 1,
      status: MyUploadFileStatus.loading,
      loadingText: 'Uploading',
      source: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
    MyUploadFile(
      id: 2,
      status: MyUploadFileStatus.loading,
      progress: 68,
      source: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
  ];
  final List<MyUploadFile> files4 = [
    MyUploadFile(
      id: 1,
      status: MyUploadFileStatus.retry,
      retryText: 'Retry',
      source: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
  ];
  final List<MyUploadFile> files5 = [
    MyUploadFile(
      id: 1,
      status: MyUploadFileStatus.error,
      errorText: 'Failed',
      source: 'https://tdesign.gtimg.com/demo/images/example4.png',
    ),
  ];

  final List<MyUploadFile> files6 = [];

  void onValueChanged(
    List<MyUploadFile> fileList,
    List<MyUploadFile> value,
    MyUploadType event,
  ) {
    switch (event) {
      case MyUploadType.add:
        setState(() {
          fileList.addAll(value);
        });
        break;
      case MyUploadType.remove:
        setState(() {
          fileList.removeWhere((element) => element.id == value[0].id);
        });
        break;
      case MyUploadType.replace:
        setState(() {
          final firstReplaceFile = value.first;
          final index = fileList.indexWhere(
            (file) => file.id == firstReplaceFile.id,
          );
          if (index != -1) {
            fileList[index] = firstReplaceFile;
          }
        });
        break;
    }
  }

  void onClick(int key) {}

  void onCancel() {}

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'upload',
      desc:
          'This is used for uploading images from the photo gallery or uploading images taken by a camera.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Single Upload - one time only',
              builder: _uploadSingle,
            ),
            ExampleItem(
              desc: 'Single Upload - replace mutiple times',
              builder: _uploadSingleWithReplace,
            ),
            ExampleItem(desc: 'Multiple Upload', builder: _uploadMultiple),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Loading status', builder: _uploadLoading),
            ExampleItem(desc: 'Retry', builder: _uploadRetry),
            ExampleItem(desc: 'Upload failed', builder: _uploadError),
            ExampleItem(
              desc: 'Upload file size limit, 10KB',
              builder: _uploadSizeLimit,
            ),
          ],
        ),
      ],
    );
  }

  Widget _uploadSingle(BuildContext context) {
    return MyUpload(
      files: files1,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files1, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadSingleWithReplace(BuildContext context) {
    return MyUpload(
      files: files6,
      width: 60,
      height: 60,
      type: MyUploadBoxType.circle,
      enabledReplaceType: true,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files6, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadMultiple(BuildContext context) {
    return MyUpload(
      files: files2,
      multiple: true,
      max: 9,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files2, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadLoading(BuildContext context) {
    return MyUpload(
      files: files3,
      multiple: true,
      max: 9,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files3, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadRetry(BuildContext context) {
    return MyUpload(
      files: files4,
      multiple: true,
      max: 9,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files4, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadError(BuildContext context) {
    return MyUpload(
      files: files5,
      multiple: true,
      max: 9,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      onChange: ((files, type) => onValueChanged(files5, files, type)),
    ).padding(left: 16);
  }

  Widget _uploadSizeLimit(BuildContext context) {
    return MyUpload(
      files: files1,
      onClick: onClick,
      onCancel: onCancel,
      onError: print,
      onValidate: print,
      sizeLimit: 10,
      onChange: ((files, type) => onValueChanged(files1, files, type)),
    ).padding(left: 16);
  }
}
