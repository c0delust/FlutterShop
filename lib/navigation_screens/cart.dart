import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttershop/screens/product_screen.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:fluttershop/services/firebase_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerWidget {
  CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartStream = ref.watch(userCartStream);
    final productsStream = ref.read(allProductsStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            fontSize: 25,
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: cartStream.when(
          data: (snapshot) {
            if (snapshot != null) {
              Map<String, dynamic>? myCart = snapshot['myCart']['items'];

              if (myCart!.length == 0) {
                snapshot['myCart']['total'] = 0;
                updateCart(snapshot['myCart']);
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/cart.png'),
                      Text(
                        'Your cart is Empty !',
                        style: TextStyle(
                          color: Color.fromARGB(255, 93, 139, 209),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  ListView.builder(
                    itemCount: myCart.length,
                    itemBuilder: (context, index) {
                      String key = myCart.keys.elementAt(index);

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: primaryColor.withOpacity(0.3)),
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        child: CartItemView(
                            myCart, key, snapshot, productsStream, index),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 0, right: 5, left: 5),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor.withOpacity(0.2),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                            locale: 'en_US', symbol: '₹ ')
                                        .format(
                                      snapshot['myCart']['total'],
                                    ),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 5, right: 5, left: 5),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () =>
                                placeOrder(snapshot['myCart'], context),
                            child: Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Text('');
          },
          error: (error, stackTrace) {
            print(stackTrace);
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
    );
  }

  ListTile CartItemView(
      Map<String, dynamic> myCart,
      String key,
      Map<String, dynamic> snapshot,
      AsyncValue<QuerySnapshot<Object?>> productsStream,
      int index) {
    return ListTile(
      onTap: () {
        productsStream.when(
          data: (snapshot) {
            for (final doc in snapshot.docs) {
              if (doc.id == key) {
                Get.to(
                  () => ProductScreen(product: doc),
                );
              }
            }
          },
          error: (error, stackTrace) => null,
          loading: () => null,
        );
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      leading: FittedBox(
        child: FancyShimmerImage(
          imageUrl: myCart[key]['imageUrl'],
          imageBuilder: (context, imageProvider) {
            return Image(
              width: 60,
              image: imageProvider,
              fit: BoxFit.cover,
            );
          },
          errorWidget: Image.asset(
            "assets/images/picture_failed.png",
          ),
        ),
      ),
      // tileColor: primaryColor.withOpacity(0.1),

      title: Text(
        myCart[key]['name'],
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat.currency(locale: 'en_US', symbol: '₹ ').format(
              myCart[key]['price'] * myCart[key]['quantity'],
            ),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          FittedBox(
            child: Row(children: [
              IconButton(
                onPressed: () {
                  // ProviderContainer()
                  //     .read(userCartStream)
                  //     .refresh();
                  myCart[key]['quantity'] = myCart[key]['quantity'] - 1;

                  if (myCart[key]['quantity'] == 0) {
                    myCart.remove(key);
                  }
                  updateCart(snapshot['myCart']);
                },
                icon: Icon(Icons.remove),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  myCart[key]['quantity'].toString(),
                ),
              ),
              IconButton(
                onPressed: () {
                  myCart[key]['quantity'] = myCart[key]['quantity'] + 1;

                  updateCart(snapshot['myCart']);
                },
                icon: Icon(Icons.add),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  placeOrder(myCart, context) async {
    User? currentUser = firebaseAuth.currentUser;

    String date_time = DateFormat('dd-MMM-yyy H-m').format(DateTime.now());

    if (currentUser != null) {
      DocumentReference firestoreDatabase =
          firestore.collection(ordersCollection).doc(currentUser.uid);
      final orderDocument = await firestoreDatabase.get();

      if (orderDocument.exists) {
        firestoreDatabase.update(
          {
            date_time: {
              'items': myCart['items'],
              'status': 'INPROCESS',
              'total': myCart['total']
            }
          },
        );
      } else {
        firestoreDatabase.set(
          {
            date_time: {
              'items': myCart['items'],
              'status': 'INPROCESS',
              'total': myCart['total']
            }
          },
        );
      }

      firestoreDatabase =
          firestore.collection(usersCollection).doc(currentUser.uid);

      firestoreDatabase.update({
        'myCart': {'items': {}, 'total': 0}
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order Placed Successfully'),
      ));
    }
  }

  updateCart(myCart) async {
    num total = 0;

    for (final entries in myCart['items'].entries) {
      total += entries.value['price'] * entries.value['quantity'];
    }

    myCart['total'] = total;

    DocumentReference firestoreDatabase;

    if (currentUser != null) {
      firestoreDatabase =
          firestore.collection(usersCollection).doc(currentUser!.uid);

      firestoreDatabase.update({'myCart': myCart});
    }
  }

  // addData() async {
  //   DocumentReference firestoreDatabase =
  //       firestore.collection(productsCollection).doc();

  //   await firestoreDatabase.set({
  //     "category": "Televisions",
  //     "name":
  //         'MI 138 cm (55 inches) X Series 4K Ultra HD Smart Android LED TV L55M7-A2IN (Black) ',
  //     "description":
  //         "Resolution: 4K Ultra HD (3840 x 2160) | Refresh Rate: 60 hertz | 178° wide viewing angle\nConnectivity: Dual Band Wi-Fi (2.4 GHz/ 5 GHz) | 3 HDMI ports to connect latest gaming consoles, set top box, Blu-ray Players | 2 USB ports to connect hard drives and other USB devices | ALLM | eARC | Bluetooth 5.0 | Optical | Ethernet | 3.5mm earphone Jack ",
  //     "images": [
  //       'https://m.media-amazon.com/images/I/71aFZ3znDJL._SL1500_.jpg',
  //       'https://m.media-amazon.com/images/I/71GBPfV0BBL._SL1500_.jpg'
  //     ],
  //     "price": 36999,
  //     "quantity": 10,
  //     "rating": 4.2,
  //     "timestamp": DateTime.now().millisecondsSinceEpoch + 2304
  //   });
  // }
}
