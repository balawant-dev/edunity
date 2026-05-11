import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {

  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.wifi_off,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Internet Connection",
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: (){
                Navigator.pop(context);
              },

              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}