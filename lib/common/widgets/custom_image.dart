import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {

  final String image;

  final double? height;

  final double? width;

  final BoxFit fit;

  final BorderRadius? borderRadius;

  final bool isNetwork;

  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {

    Widget child;

    /// NETWORK IMAGE
    if(isNetwork){

      child = Image.network(

        image,

        height: height,

        width: width,

        fit: fit,

        errorBuilder:
            (context, error, stackTrace){

          return Container(

            height: height,

            width: width,

            color: Colors.grey.shade200,

            alignment: Alignment.center,

            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
            ),
          );
        },

        loadingBuilder:
            (context, child, loadingProgress){

          if(loadingProgress == null){
            return child;
          }

          return SizedBox(

            height: height,

            width: width,

            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

    }else{

      /// ASSET IMAGE
      child = Image.asset(

        image,

        height: height,

        width: width,

        fit: fit,
      );
    }

    return ClipRRect(

      borderRadius:
      borderRadius ??
          BorderRadius.zero,

      child: child,
    );
  }
}


//
// CustomImage(
//
// image:
// "lib/assets/images/logo.png",
//
// height: 40,
//
// width: 40,
// )


// CustomImage(
//
// image: profile.photo,
//
// isNetwork: true,
//
// height: 100,
//
// width: 100,
//
// borderRadius:
// BorderRadius.circular(100),
// )