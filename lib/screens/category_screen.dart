import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:fluttershop/screens/product_screen.dart';
import 'package:fluttershop/views/product_thumbnail.dart';
import 'package:get/get.dart';

class CategoryScreen extends ConsumerWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryStream = ref.watch(categoryProductsStream(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: categoryStream.when(
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
      // drawer: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: StreamBuilder(
      //     stream: FirestoreServices.getProducts(category),
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
    );
  }
}
