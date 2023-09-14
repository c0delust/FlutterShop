import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:fluttershop/screens/product_screen.dart';
import 'package:fluttershop/views/product_search_bar.dart';
import 'package:fluttershop/views/product_thumbnail.dart';
import 'package:get/get.dart';

class SearchScreen extends ConsumerWidget {
  SearchScreen({super.key});

  final TextController textController = Get.put(TextController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsStream = ref.watch(allProductsStream);

    return Scaffold(
      appBar: AppBar(
        title: ProductSearchBar(
          isEnabled: true,
          onChanged: textController.updateText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return productsStream.when(
            data: (snapshot) {
              String query = textController.text.value.toLowerCase();
              var documents = snapshot.docs;

              List<DocumentSnapshot> _searchResults = [];

              if (query.isNotEmpty)
                documents.forEach((document) {
                  final fieldValue1 = document['name'].toString().toLowerCase();
                  final fieldValue2 =
                      document['description'].toString().toLowerCase();
                  if (fieldValue1.contains(query) ||
                      fieldValue2.contains(query)) {
                    _searchResults.add(document);
                  }
                });

              return GridView.builder(
                itemCount: _searchResults.length,
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
                    product: _searchResults[index],
                    onTap: () {
                      Get.to(
                        () => ProductScreen(product: _searchResults[index]),
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
          );
        }),
      ),
    );
  }
}
