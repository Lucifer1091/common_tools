import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

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
      key: 1,
      remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
    MyUploadFile(
      key: 2,
      remotePath: 'https://tdesign.gtimg.com/demo/images/example2.png',
    ),
    MyUploadFile(
      key: 3,
      remotePath: 'https://tdesign.gtimg.com/demo/images/example3.png',
    ),
  ];
  final List<MyUploadFile> files3 = [
    MyUploadFile(
      key: 1,
      status: MyUploadFileStatus.loading,
      loadingText: 'Uploading...',
      remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
    MyUploadFile(
      key: 2,
      status: MyUploadFileStatus.loading,
      progress: 68,
      remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
  ];
  final List<MyUploadFile> files4 = [
    MyUploadFile(
      key: 1,
      status: MyUploadFileStatus.retry,
      retryText: 'Reupload',
      remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png',
    ),
  ];
  final List<MyUploadFile> files5 = [
    MyUploadFile(
      key: 1,
      status: MyUploadFileStatus.error,
      errorText: 'Upload failed',
      remotePath: 'https://tdesign.gtimg.com/demo/images/example4.png',
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
          fileList.removeWhere((element) => element.key == value[0].key);
        });
        break;
      case MyUploadType.replace:
        setState(() {
          final firstReplaceFile = value.first;
          final index = fileList.indexWhere(
            (file) => file.key == firstReplaceFile.key,
          );
          if (index != -1) {
            fileList[index] = firstReplaceFile;
          }
        });
        break;
    }
  }

  void onClick(int key) {
    print('Clicked $key');
  }

  void onCancel() {
    print('Cancel');
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'upload',
      desc:
          'This is used for reading images from the photo album or uploading images taken by taking a photo. `${MyPlatform.isWeb ? "The web version does not support reading local images; please try it on the mobile version." : ""}',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Single Upload', builder: _uploadSingle),
            ExampleItem(
              desc: 'Single Upload (Replace)',
              builder: _uploadSingleWithReplace,
            ),
            ExampleItem(desc: 'Multiple Upload', builder: _uploadMultiple),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Loading status', builder: _uploadLoading),
            ExampleItem(desc: 'Re-upload', builder: _uploadRetry),
            ExampleItem(desc: 'Upload failed', builder: _uploadError),
          ],
        ),
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: 'Single-select quick replace, size and graphics test',
          builder: _uploadSingleWithReplace,
        ),
        ExampleItem(
          ignoreCode: true,
          desc: 'Upload file size limit, 10KB',
          builder: _uploadSizeLimit,
        ),
      ],
    );
  }

  Widget wrapDemoContainer(String title, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _uploadSingle(BuildContext context) {
    return wrapDemoContainer(
      'Single selection upload',
      child: MyUpload(
        files: files1,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        onChange: ((files, type) => onValueChanged(files1, files, type)),
      ),
    );
  }

  Widget _uploadSingleWithReplace(BuildContext context) {
    return wrapDemoContainer(
      'Single selection upload (replace)',
      child: MyUpload(
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
      ),
    );
  }

  Widget _uploadMultiple(BuildContext context) {
    return wrapDemoContainer(
      'Multiple selection upload',
      child: MyUpload(
        files: files2,
        multiple: true,
        max: 9,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        onChange: ((files, type) => onValueChanged(files2, files, type)),
      ),
    );
  }

  Widget _uploadLoading(BuildContext context) {
    return wrapDemoContainer(
      'Upload pictures',
      child: MyUpload(
        files: files3,
        multiple: true,
        max: 9,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        onChange: ((files, type) => onValueChanged(files3, files, type)),
      ),
    );
  }

  Widget _uploadRetry(BuildContext context) {
    return wrapDemoContainer(
      'Upload pictures',
      child: MyUpload(
        files: files4,
        multiple: true,
        max: 9,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        onChange: ((files, type) => onValueChanged(files4, files, type)),
      ),
    );
  }

  Widget _uploadError(BuildContext context) {
    return wrapDemoContainer(
      'Upload pictures',
      child: MyUpload(
        files: files5,
        multiple: true,
        max: 9,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        onChange: ((files, type) => onValueChanged(files5, files, type)),
      ),
    );
  }

  Widget _uploadSizeLimit(BuildContext context) {
    return wrapDemoContainer(
      'Limit 10KB',
      child: MyUpload(
        files: files1,
        onClick: onClick,
        onCancel: onCancel,
        onError: print,
        onValidate: print,
        sizeLimit: 10,
        onChange: ((files, type) => onValueChanged(files1, files, type)),
      ),
    );
  }
}
