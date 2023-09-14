import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/firebase_constant.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpeg'),
              fit: BoxFit.cover,
              opacity: 0.08,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'FlutterShop',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await googleSign(context);
                    // Get.back();
                  },
                  label: Text(
                    'Continue with Google',
                    // style: TextStyle(fontSize: 19),
                  ),
                  icon: Image.asset(
                    "assets/images/google.png",
                    width: 20,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  googleSign(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    final GoogleSignInAccount? gUser =
        await GoogleSignIn().signIn().whenComplete(() {
      Get.back();
    });

    try {
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credentials);
      final User? user = authResult.user;

      if (user != null) {
        createUserDatabase(context);
        // Get.back();
        return true;
      } else {}
    } catch (e) {}

    return false;
  }

  createUserDatabase(context) async {
    User? user = firebaseAuth.currentUser;

    DocumentReference firestoreDatabase =
        firestore.collection(usersCollection).doc(user!.uid);
    firestoreDatabase.set({
      'name': user.displayName,
      'email': user.email,
      'imageUrl': user.photoURL,
      'myCart': {'items': {}, 'total': 0}
    });

    Get.back();
  }
}
