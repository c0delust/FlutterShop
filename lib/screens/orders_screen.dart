import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderStream = ref.watch(userOrderStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 25,
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: orderStream.when(
          data: (data) {
            if (data != null) {
              if (data.entries.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/noorder.png'),
                      Text(
                        'No orders found !',
                        style: TextStyle(
                          color: Color.fromARGB(255, 93, 139, 209),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final List<Widget> listTiles = data.entries.map((entry) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: primaryColor.withOpacity(1)),
                    ),
                  ),
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      NumberFormat.currency(locale: 'en_US', symbol: '₹ ')
                          .format(
                        entry.value['total'],
                      ),
                    ),
                    // subtitle: ,
                  ),
                );
              }).toList();

              return ListView(
                children: listTiles,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/noorder.png',
                      width: 200,
                      color: Color.fromARGB(255, 109, 140, 187),
                    ),
                    Text(
                      'No orders found !',
                      style: TextStyle(
                        color: Color.fromARGB(255, 93, 139, 209),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          error: (error, stackTrace) {
            print(stackTrace.toString());
            return null;
          },
          loading: () => null,
        ),
      ),
    );
  }
}
