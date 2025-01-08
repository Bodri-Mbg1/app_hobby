import 'package:app_hobby/Screens/home.dart';
import 'package:app_hobby/create_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    // Récupérer les informations stockées localement
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    // Vérification des informations
    if (username == savedUsername && password == savedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );

      // Enregistrer l'utilisateur connecté
      await prefs.setString('loggedInUser', username);

      // Redirection vers la page principale
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Transparence pour voir l'arrière-plan
      body: Stack(
        children: [
          // Image en arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/img/télécharger - 2025-01-03T171056.773.jpeg',
              fit: BoxFit.cover, // Adapte l'image à l'écran
            ),
          ),
          // Contenu de la page
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/570-5702967_hobbies-logo-hobbies-text.png',
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(height: 250),
                  const Text(
                    "Hobbies express passions and bring joy!",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.1,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Hobbies are activities we love and enjoy doing in our free time. They help us relax, explore our passions, and develop new skills, whether it's painting, cooking, reading, or playing sports. Hobbies bring joy and balance to our daily lives!",
                    style: TextStyle(
                        color: Colors.white, height: 1.3, fontSize: 10),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Coins arrondis
                      ),
                      minimumSize: const Size(500, 60), // Taille du bouton
                    ),
                    onPressed: () async {
                      await _signInWithGoogle(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/pngegg (9).png',
                          height: 25,
                          width: 25,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sign In with Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Déconnecter l'utilisateur existant pour forcer le choix du compte
      await googleSignIn.signOut();

      // Lancer la connexion
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenue ${googleUser.displayName}")),
        );

        // Redirection vers la page principale
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in cancelled by user.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
