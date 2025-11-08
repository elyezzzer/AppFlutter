import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/available_tools_page.dart';
import 'pages/borrowed_tools_page.dart';
import 'pages/add_tool_page.dart';

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
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    AvailableToolsPage(),
    BorrowedToolsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Ferramentas Disponíveis' : 'Ferramentas Emprestadas'),
        backgroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Disponíveis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Emprestadas',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddToolPage()),
                );
              },
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}