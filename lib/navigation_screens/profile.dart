import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/screens/orders_screen.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/screens/login_screen.dart';
import 'package:fluttershop/services/firebase_constant.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  User? currentUser = firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: FancyShimmerImage(
                    imageUrl: currentUser!.photoURL!,
                    errorWidget: Image.asset(
                      "assets/images/picture_failed.png",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                currentUser!.displayName.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                currentUser!.email.toString(),
                style: TextStyle(color: primaryColor.withOpacity(0.85)),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                  },
                  label: Text(
                    'Sign Out',
                  ),
                  icon: Icon(
                    Icons.logout_outlined,
                  ),
                ),
              ),
              Container(
                width: 200,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 204, 88, 90),
                  ),
                  onPressed: () async {
                    deleteAccount(context);
                  },
                  label: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 250,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                  ),
                  onPressed: () async {
                    Get.to(() => OrdersScreen());
                  },
                  label: Text(
                    'My Orders',
                  ),
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteAccount(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('You are about to delete your Account! Are you sure?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 204, 88, 90),
            ),
            onPressed: () async {
              try {
                Get.back();

                await FirebaseAuth.instance.currentUser!.delete();
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();

                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Get.offAll(() => LoginScreen());
              } on FirebaseAuthException catch (e) {
                print("FirebaseAuthException: " + e.toString());

                try {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Log in again before deleting the account.'),
                  ));
                } catch (e) {}
              } catch (e) {}
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
