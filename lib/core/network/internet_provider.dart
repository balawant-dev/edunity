import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {

  bool isConnected = true;

  StreamSubscription<List<ConnectivityResult>>?
  subscription;

  InternetProvider() {
    init();
  }

  Future<void> init() async {

    final result =
    await Connectivity().checkConnectivity();

    isConnected =
    !result.contains(
      ConnectivityResult.none,
    );

    notifyListeners();

    subscription =
        Connectivity()
            .onConnectivityChanged
            .listen((results) {

          isConnected =
          !results.contains(
            ConnectivityResult.none,
          );

          notifyListeners();
        });
  }

  @override
  void dispose() {

    subscription?.cancel();

    super.dispose();
  }
}