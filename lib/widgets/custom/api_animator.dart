// import 'package:flutter/material.dart';
//
// enum ApiCallStatus {
//   loading,
//   success,
//   error,
//   empty,
//   holding,
//   cache,
//   refresh,
//   restrictedAccess,
// }
//
// // switch between different widgets with animation
// // depending on api call status
// class CustomApiAnimator extends StatelessWidget {
//   final ApiCallStatus apiCallStatus;
//   final Widget Function() successWidget;
//   final Widget Function()? loadingWidget;
//   final Widget Function()? errorWidget;
//   final Widget Function()? emptyWidget;
//   final Widget Function()? holdingWidget;
//   final Widget Function()? refreshWidget;
//   final Widget Function()? restrictedAccessWidget;
//   final Duration? animationDuration;
//   final Widget Function(Widget, Animation)? transitionBuilder;
//
//   // this will be used to not hide the success widget when refresh
//   // if its true success widget will still be shown
//   // if false refresh widget will be shown or empty box if passed (refreshWidget) is null
//   final bool hideSuccessWidgetWhileRefreshing;
//
//   const CustomApiAnimator({
//     super.key,
//     required this.apiCallStatus,
//     required this.successWidget,
//     this.loadingWidget,
//     this.errorWidget,
//     this.restrictedAccessWidget,
//     this.holdingWidget,
//     this.emptyWidget,
//     this.refreshWidget,
//     this.animationDuration,
//     this.transitionBuilder,
//     this.hideSuccessWidgetWhileRefreshing = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: animationDuration ?? Durations.short1,
//       child: _getChild()(),
//       transitionBuilder: transitionBuilder ??
//           (child, animation) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//     );
//   }
//
//   _getChild() {
//     if (apiCallStatus == ApiCallStatus.success) {
//       return successWidget;
//     } else if (apiCallStatus == ApiCallStatus.error) {
//       return errorWidget ?? () => const Center(child: GenericErrorIndicator());
//     } else if (apiCallStatus == ApiCallStatus.holding) {
//       return holdingWidget ??
//           () {
//             return const SizedBox();
//           };
//     } else if (apiCallStatus == ApiCallStatus.loading) {
//       return loadingWidget ?? () => const Center(child: CustomLoader());
//     } else if (apiCallStatus == ApiCallStatus.empty) {
//       return emptyWidget ?? () => const Center(child: EmptyListIndicator());
//     } else if (apiCallStatus == ApiCallStatus.refresh) {
//       return refreshWidget ??
//           (hideSuccessWidgetWhileRefreshing
//               ? successWidget
//               : () => const SizedBox.shrink());
//     } else if (apiCallStatus == ApiCallStatus.restrictedAccess) {
//       return restrictedAccessWidget ??
//           () => const Center(child: RestrictedAccessIndicator());
//     } else {
//       return successWidget;
//     }
//   }
// }
//
// // // hold data coming from api
// // List<ProductModel>? data;
// // // api call status
// // ApiCallStatus apiCallStatus = ApiCallStatus.holding;
// //
// // // getting data from api
// // getData() async {
// //   // *) perform api call
// //   await BaseClient.safeApiCall(
// //     ApiConstants.GET_PRODUCT_LIST, // url
// //     RequestType.get, // request type (get,post,delete,put)
// //     headers: await BaseClient.generateHeaders(),
// //     onLoading: () {
// //       // *) indicate loading state
// //       apiCallStatus = ApiCallStatus.loading;
// //       update();
// //     },
// //     onSuccess: (response) {
// //       // api done successfully
// //       data = ProductResponseModel.fromJson(response.data).products;
// //       // *) indicate success state
// //       apiCallStatus = ApiCallStatus.success;
// //       update();
// //     },
// //     // if you don't pass this method base client
// //     // will automatically handle error and show message to user
// //     onError: (error) {
// //       // show error message to user
// //       BaseClient.handleApiError(error);
// //       // *) indicate error status
// //       apiCallStatus = ApiCallStatus.error;
// //       update();
// //     },
// //   );
// // }
