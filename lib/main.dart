import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Auth/auth_gate.dart'; // Import AuthGate file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ojtnqpisiienkvxhhwwy.supabase.co",
    publishableKey: "sb_publishable_I-CMWSUjeIMKT3JTrESgtg_MHJIhKJB",
  );

  // // Connect to the game server
  // SocketService().connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
