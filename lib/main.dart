import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttershop/navigation_screens/cart.dart';
import 'package:fluttershop/navigation_screens/categories.dart';
import 'package:fluttershop/navigation_screens/home.dart';
import 'package:fluttershop/navigation_screens/profile.dart';
import 'package:fluttershop/screens/login_screen.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:fluttershop/services/providers.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterShop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        useMaterial3: true,
      ),
      // home: currentUser == null ? LoginScreen() : MyHomePage(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData) {
              print('Login In');
              return MyHomePage();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: screens[ref.watch(screenIndexProvider)],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(screenIndexProvider),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.4),
        onTap: (index) {
          ref.read(screenIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
