//lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/achievement.dart';
import 'screens/achievement_list.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization for local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inisialisasi Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AchievementAdapter());
  await Hive.openBox<Achievement>('achievements');

  runApp(AchievementApp());
}

class AchievementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievement App',
      theme: ThemeData(
        // Warna utama
        primarySwatch: MaterialColor(0xFFFFB6C1, <int, Color>{
          50: Color(0xFFFFEBEE),
          100: Color(0xFFFFCDD2),
          200: Color(0xFFEEAABB),
          300: Color(0xFFEEAABB),
          400: Color(0xFFEEAABB),
          500: Color(0xFFFFB6C1),
          600: Color(0xFFEEAABB),
          700: Color(0xFFEEAABB),
          800: Color(0xFFEEAABB),
          900: Color(0xFFEEAABB),
        }),
        // Warna utama juga digunakan sebagai dasar untuk warna aksen
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFFFFB6C1, <int, Color>{
            50: Color(0xFFFFEBEE),
            100: Color(0xFFFFCDD2),
            200: Color(0xFFEEAABB),
            300: Color(0xFFEEAABB),
            400: Color(0xFFEEAABB),
            500: Color(0xFFFFB6C1),
            600: Color(0xFFEEAABB),
            700: Color(0xFFEEAABB),
            800: Color(0xFFEEAABB),
            900: Color(0xFFEEAABB),
          }),
          // Warna aksen kustom
          accentColor: const Color(0xFFE57373),
          // Anda juga dapat menentukan warna lain seperti warna teks, latar belakang, dll.
        ),
      ),
      // Gunakan Stack untuk menempatkan latar belakang gambar di belakang konten utama
      home: Stack(
        children: <Widget>[
          // Latar belakang gambar
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_logo.png'),
                fit: BoxFit.cover, // Atur gambar agar menutupi container
              ),
            ),
            child:
                null, // Tidak ada widget anak di sini karena latar belakang saja
          ),
          // Konten utama aplikasi (AchievementList dalam contoh ini)
          AchievementList(),
        ],
      ),
    );
  }
}
