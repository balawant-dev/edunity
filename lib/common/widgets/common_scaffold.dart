import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {

  final Widget body;
  final Color? backgroundColor;

  const CommonScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: (){
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }
}