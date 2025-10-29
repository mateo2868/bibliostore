import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handler para notificaciones cuando la app está en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Notificación recibida en segundo plano: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const BiblioStoreApp());
}

class BiblioStoreApp extends StatefulWidget {
  const BiblioStoreApp({super.key});

  @override
  State<BiblioStoreApp> createState() => _BiblioStoreAppState();
}

class _BiblioStoreAppState extends State<BiblioStoreApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Solicitar permisos (Android 13+)
    await _messaging.requestPermission();

    // Obtener el token del dispositivo
    _token = await _messaging.getToken();
    print("🔑 Token del dispositivo: $_token");

    // Escuchar notificaciones cuando la app está abierta
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📢 ${notification.title}: ${notification.body}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliostore - Notificaciones',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(title: const Text('📚 Notificaciones FCM')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Esperando notificaciones...',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SelectableText('Token: $_token'),
            ],
          ),
        ),
      ),
    );
  }
}
