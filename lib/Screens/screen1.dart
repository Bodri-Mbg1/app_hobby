import 'package:app_hobby/Tabs/tab_foryou.dart';
import 'package:app_hobby/Tabs/you.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String userName = 'User'; // Nom par défaut
  String? photoUrl; // Photo par défaut (null si aucune photo n'est disponible)

  @override
  void initState() {
    super.initState();
    _loadGoogleUserData();
  }

  void _loadGoogleUserData() {
    final User? googleUser = FirebaseAuth.instance.currentUser;

    if (googleUser != null) {
      // Si un utilisateur Google est connecté, récupérer ses informations
      setState(() {
        userName = googleUser.displayName ?? 'Google User';
        photoUrl = googleUser.photoURL;
      });
    } else {
      // Si aucun utilisateur n'est connecté
      setState(() {
        userName = 'User';
        photoUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Photo de l'utilisateur (ou icône par défaut si aucune photo)
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 12),
                      // Message de bienvenue
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.search,
                    size: 35,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 40,
              child: ButtonsTabBar(
                decoration: BoxDecoration(
                  color: const Color(0xFF1c1d21),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF422f96),
                    width: 1,
                  ),
                ),
                unselectedDecoration: BoxDecoration(
                  color: const Color(0xFFfafafa),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF422f96),
                    width: 1,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Color(0xFF1c1d21),
                  fontWeight: FontWeight.bold,
                ),
                buttonMargin: const EdgeInsets.symmetric(horizontal: 17),
                contentPadding: const EdgeInsets.symmetric(horizontal: 17),
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Most popular'),
                  Tab(text: '+ Create'),
                ],
              ),
            ),
            // Utiliser un Expanded pour que TabBarView occupe l'espace restant
            const Expanded(
              child: TabBarView(
                children: [
                  You(),
                  Center(child: Text('Most popular')),
                  Center(child: Text('+ Create')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
