import 'package:flutter/material.dart';
import 'package:receipt_reader/helper/context_extension.dart';

// ignore: must_be_immutable
abstract class BaseView<T extends ChangeNotifier> extends StatelessWidget {
  late T _baseProvider;

  _setProviderOfPage(BuildContext context) {
    _baseProvider = context.providerLF<T>();
  }

  T get provider => _baseProvider;

  @override
  Widget build(BuildContext context) {
    _setProviderOfPage(context);
    return WillPopScope(
      onWillPop: () => backFunction(context) ?? Future.value(true),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        // backgroundColor: ColorConstant.baseGray,
        body: SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: customBuild(context))),
        appBar: customAppbar(context),
        // bottomSheet: customBottomSheet(context),
        // bottomNavigationBar: customBottomNavigationBar(context),
        // floatingActionButton: floatingActionButton(context),
      ),
    );
  }

  Widget customBuild(BuildContext context);

  PreferredSizeWidget? customAppbar(BuildContext context);

  Future<bool>? backFunction(BuildContext context) {
    return Future.value(true);
  }

  // Widget? customBottomSheet(BuildContext context);

  // Widget? customBottomNavigationBar(BuildContext context);

  // Widget? floatingActionButton(BuildContext context) {
  //   return null;
  // }
}
