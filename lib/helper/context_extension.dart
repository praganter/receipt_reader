import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  ///General usage => call methods.
  T providerLF<T extends ChangeNotifier>() => Provider.of<T>(this, listen: false);

  ///General usage => watch properties.
  T providerLT<T extends ChangeNotifier>() => Provider.of<T>(this, listen: true);
}
