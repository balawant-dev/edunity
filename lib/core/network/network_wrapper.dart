import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../error/no_internet_screen.dart';

import 'internet_provider.dart';

class NetworkWrapper extends StatelessWidget {

  final Widget child;

  const NetworkWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<InternetProvider>();

    if(!provider.isConnected){

      return const NoInternetScreen();
    }

    return child;
  }
}