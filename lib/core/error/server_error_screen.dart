import 'package:flutter/material.dart';

class ServerErrorScreen extends StatelessWidget {

  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.error_outline,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "Internal Server Error",
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: (){
                Navigator.pop(context);
              },

              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}