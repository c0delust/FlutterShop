import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttershop/main.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:fluttershop/screens/search_screen.dart';
import 'package:fluttershop/services/firebase_constant.dart';
import 'package:fluttershop/views/product_search_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductScreen extends ConsumerWidget {
  final product;
  ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map<String, dynamic> data = product.data() as Map<String, dynamic>;
    // print(data);

    final cartStream = ref.watch(userCartStream);
    bool isAddedInCart = false;

    try {
      if (cartStream.value!['myCart']['items'].containsKey(product.id)) {
        isAddedInCart = true;
      }
    } catch (e) {}

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                VxSwiper.builder(
                  realPage: 0,
                  initialPage: 0,
                  pauseAutoPlayOnTouch: Duration(seconds: 1),
                  autoPlay: true,
                  height: 250,
                  itemCount: product['images'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: FancyShimmerImage(
                        imageUrl: product['images'][index],
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          );
                        },
                        errorWidget: Image.asset(
                          "assets/images/picture_failed.png",
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 244, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product['name'],
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: VxRating(
                            selectionColor:
                                const Color.fromARGB(255, 255, 164, 28),
                            normalColor:
                                const Color.fromARGB(255, 213, 213, 213),
                            count: 5,
                            stepInt: false,
                            isSelectable: false,
                            value: (product['rating'] / 5) * 10,
                            onRatingUpdate: (value) {},
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          NumberFormat.currency(locale: 'en_US', symbol: '₹ ')
                              .format(product['price']),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Product Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product['description'],
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
              onPressed: () {
                if (isAddedInCart) {
                  Get.offAll(() => MyHomePage());
                  ref.read(screenIndexProvider.notifier).state = 2;
                } else {
                  isAddedInCart = true;
                  addProductToCart(product);
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                child: Text(
                  isAddedInCart ? 'Check Out' : 'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  addProductToCart(product) async {
    DocumentReference firestoreDatabase;

    if (currentUser != null) {
      firestoreDatabase =
          firestore.collection(usersCollection).doc(currentUser!.uid);

      final userDocument = await firestoreDatabase.get();

      if (userDocument.exists) {
        final Map<String, dynamic> myCart =
            (userDocument.data() as Map<String, dynamic>)['myCart'];

        myCart['total'] = myCart['total'] + product['price'];

        Map<String, dynamic> productData = {
          'name': product['name'],
          'price': product['price'],
          'imageUrl': product['images'][0],
          'quantity': 1,
        };

        myCart['items'][product.id] = productData;

        firestoreDatabase.update({'myCart': myCart});
      } else {
        firestoreDatabase.set({
          'myCart': {
            'total': product['price'],
            'items': {
              product.id: {
                'name': product['name'],
                'price': product['price'],
                'imageUrl': product['images'][0],
                'quantity': 1
              }
            }
          },
        });
      }
    }
  }
}
