import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';   
import 'screens/cart_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/checkout_screen.dart';
import 'dart:developer' as developer;
import 'package:provider/provider.dart';
import 'services/cart_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCpP0TTGYb_n2zuVZKGh2WgNK0cqJVBfb0", // انسخ من firebase
        authDomain: "taste-of-sham-cccd0.firebaseapp.com",
        projectId: "taste-of-sham-cccd0",
        storageBucket: "taste-of-sham-cccd0.appspot.com",
        messagingSenderId: "885507234556",
        appId: "1:885507234556:web:a18a286a11952f23189579",
      ),
    );
    runApp(
      ChangeNotifierProvider(
        create: (context) => CartService(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    developer.log("Failed to initialize Firebase: $e", name: "main");
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'طعم الشام',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: const Color(0xFF8D6E63),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF8D6E63),
          secondary: const Color(0xFFFF8A65),
          surface: const Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E342E),
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E342E),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8D6E63),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBCAAA4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8D6E63), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF8D6E63)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFF4E342E)),
          titleTextStyle: TextStyle(
            color: Color(0xFF4E342E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic, no country code
      ],
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(),
        '/product': (_) => ProductDetailsScreen(),
        '/cart': (_) => CartScreen(),
        '/checkout': (_) => const CheckoutScreen(),
        '/offers': (_) => OffersScreen(),
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "حدث خطأ فادح: $error",
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
