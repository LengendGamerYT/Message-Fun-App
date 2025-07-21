import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/call/video_call_screen.dart';
import 'screens/call/voice_call_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/call_provider.dart';
import 'providers/contact_provider.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD2mxHItFhSaDEFiA3AkruLPbYilWAZ0OU",
      authDomain: "fun-message-app.firebaseapp.com",
      databaseURL: "https://fun-message-app-default-rtdb.firebaseio.com",
      projectId: "fun-message-app",
      storageBucket: "fun-message-app.firebasestorage.app",
      messagingSenderId: "657261566432",
      appId: "1:657261566432:web:49bad277dc6bd1f2c1b385",
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: GetMaterialApp(
        title: 'JP Chat Talk,Fun,Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primaryColor,
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/register', page: () => const RegisterScreen()),
          GetPage(name: '/home', page: () => const HomeScreen()),
          GetPage(name: '/chat', page: () => const ChatScreen()),
          GetPage(name: '/video-call', page: () => const VideoCallScreen()),
          GetPage(name: '/voice-call', page: () => const VoiceCallScreen()),
        ],
      ),
    );
  }
}