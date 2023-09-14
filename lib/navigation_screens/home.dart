import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:fluttershop/screens/product_screen.dart';
import 'package:fluttershop/screens/search_screen.dart';
import 'package:fluttershop/views/product_search_bar.dart';
import 'package:fluttershop/views/product_thumbnail.dart';
import 'package:get/get.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsStream = ref.watch(allProductsStream);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'FlutterShop',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => SearchScreen(),
                    transition: Transition.downToUp,
                  );
                },
                child: ProductSearchBar(
                  isEnabled: false,
                  onChanged: (value) {},
                ),
              ),
            ),
            // Divider(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                'Recently Added',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: productsStream.when(
                  data: (snapshot) {
                    var documents = snapshot.docs;

                    return GridView.builder(
                      itemCount: documents.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 200,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return ProductThumbnail(
                          product: documents[index],
                          onTap: () {
                            Get.to(
                              () => ProductScreen(product: documents[index]),
                            );
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  },
                  loading: () {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Color.fromARGB(255, 93, 139, 209),
                        size: 50.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: StreamBuilder(
            //     stream: FirestoreServices.getRecentProducts(),
            //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (!snapshot.hasData) {
            //         return Center(
            //           child: Icon(Icons.hourglass_empty),
            //         );
            //       } else if (snapshot.data!.docs.isEmpty) {
            //         return Center(child: Text('No Data Found'));
            //       } else {
            //         var data = snapshot.data!.docs;

            //         return GridView.builder(
            //           itemCount: data.length,
            //           physics: BouncingScrollPhysics(),
            //           shrinkWrap: true,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 2,
            //             mainAxisExtent: 200,
            //             mainAxisSpacing: 8,
            //             crossAxisSpacing: 8,
            //           ),
            //           itemBuilder: (context, index) {
            //             return ProductThumbnail(
            //               product: data[index],
            //               onTap: () {
            //                 Get.to(
            //                   () => ProductScreen(product: data[index]),
            //                   transition: Transition.circularReveal,
            //                 );
            //               },
            //             );
            //           },
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
