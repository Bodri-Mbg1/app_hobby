import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String userName = 'User'; // Nom par défaut
  String? photoUrl; // Photo par défaut (null pour les utilisateurs locaux)
  String accountType = 'Local'; // Par défaut, compte local

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? localUsername = prefs.getString('username');
    final User? googleUser = FirebaseAuth.instance.currentUser;

    if (localUsername != null) {
      // Priorité aux données locales si un utilisateur local est connecté
      setState(() {
        userName = localUsername;
        photoUrl = null; // Les comptes locaux n'ont pas de photo
      });
    } else if (googleUser != null) {
      // Sinon, utiliser les données Google si un utilisateur Google est connecté
      setState(() {
        userName = googleUser.displayName ?? 'Google User';
        photoUrl = googleUser.photoURL;
      });
    } else {
      // Par défaut si aucun utilisateur n'est connecté
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
                      // Photo de l'utilisateur (ou icône par défaut pour les locaux)
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
                          Text(
                            accountType == 'Google'
                                ? "Welcome back,"
                                : "Welcome back,",
                            style: const TextStyle(
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
            const SizedBox(
              height: 500,
              child: TabBarView(
                children: [
                  Center(child: Text('Transfer')),
                  Center(child: Text('Matches')),
                  Center(child: Text('Leagues')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
