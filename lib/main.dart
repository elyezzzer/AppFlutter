import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB78QXftEU_suzpxObMvIjyS93rIv1wLU8",
        authDomain: "emprestimodeferramentas.firebaseapp.com",
        projectId: "emprestimodeferramentas",
        storageBucket: "emprestimodeferramentas.firebasestorage.app",
        messagingSenderId: "731362222841",
        appId: "1:731362222841:web:725b47d2a1e2f3bc7eb828",
        measurementId: "G-Y1KZKPCP1S"
      ),
    );
    print('✅ FIREBASE INICIALIZADO!');
  } catch (e) {
    print('❌ ERRO NO FIREBASE: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empréstimo Ferramentas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Ferramentas')),
        body: Center(child: Text('App em desenvolvimento...')),
      ),
    );
  }
}