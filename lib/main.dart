import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAu3ChMswZ9rBP0Cs3lslA--NptnEhhOSo",
          appId: "1:1062526358504:web:b568a359de65afdfaa4a5d",
          messagingSenderId: "1062526358504",
          projectId: "flutter-first-a21a1",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    GoogleSignIn googleSignIn = GoogleSignIn();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  LoginPage({Key? key}) : super(key: key);

  Future<User?> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                User? user = await _handleSignIn();
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ),
                  );
                }
              },
              child: Text('Google Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tabs Demo'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment)),
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.score)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(),
            Placeholder(), // Replace with your ChatTab
            Placeholder(), // Replace with your ScoreTab
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificateActivity(),
                  ),
                );
              },
              child: Text('Win Certificate'),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateActivity extends StatefulWidget {
  @override
  _CertificateActivityState createState() => _CertificateActivityState();
}

class _CertificateActivityState extends State<CertificateActivity> {
  bool isAnswerEditable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Activity'),
      ),
      body: Column(
        children: [
          Text('Tell me about yourself?'),
          SizedBox(height: 10),
          isAnswerEditable
              ? TextFormField(
                  // Your text input for the answer
                  )
              : Text('Answer: ...'), // Display the submitted answer here
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAnswerEditable = false;
              });
              // Start the timer here
            },
            child: Text('Submit Answer'),
          ),
          // Timer widget can be added here
        ],
      ),
    );
  }
}
