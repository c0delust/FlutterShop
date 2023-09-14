import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/screens/category_screen.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final categories = {
    "Laptops & Desktops":
        "https://legendon.com/legendon/images/laptop-computer.png",
    "Headphones":
        "https://i.pinimg.com/originals/d7/a5/3a/d7a53a450f76f01840facc033bb0627f.png",
    "Smart Wearables":
        "https://www.pngmart.com/files/13/Smartwatch-PNG-Image.png",
    "Smartphones":
        "https://www.pngplay.com/wp-content/uploads/12/Smartphone-PNG-Free-File-Download.png",
    "Televisions":
        "https://www.pngall.com/wp-content/uploads/5/Samsung-TV-PNG.png",
    "Speakers":
        "https://shreepng.com/img/Inside/Electronic/Speaker/boAt%20Stone%201400%2030W%20Bluetooth%20Speaker.png"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: TextStyle(
            fontSize: 25,
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          primary: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: categories.entries
              .map((entry) => CategoryGridChild(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }

  Widget CategoryGridChild(String title, String url) {
    return GestureDetector(
      onTap: () {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        print(timestamp);
        Get.to(
          () => CategoryScreen(category: title),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: FancyShimmerImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  errorWidget: Image.asset(
                    "assets/images/picture_failed.png",
                  ),
                ),
                // child: CachedNetworkImage(
                //   imageUrl: url,
                // imageBuilder: (context, imageProvider) {
                //   return Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Image(
                //       image: imageProvider,
                //       fit: BoxFit.cover,
                //     ),
                //   );
                // },
                //   placeholder: (context, url) => Container(
                //     alignment: Alignment.center,
                //     child: Icon(
                //       Icons.image,
                //     ),
                //   ),
                //   errorWidget: (context, url, error) => Container(
                //     child: Icon(
                //       Icons.error,
                //     ),
                //   ),
                // ),
              ),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
