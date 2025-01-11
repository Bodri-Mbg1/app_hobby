import 'dart:math'; // Import pour générer des couleurs aléatoires
import 'package:app_hobby/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> hobbies = [
    {'name': 'Cars', 'icon': Icons.directions_car},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Running', 'icon': Icons.directions_run},
    {'name': 'Traveling', 'icon': Icons.flight},
    {'name': 'Reading', 'icon': Icons.book},
    {'name': 'Swimming', 'icon': Icons.pool},
    {'name': 'Cycling', 'icon': Icons.pedal_bike},
    {'name': 'Writing', 'icon': Icons.edit},
    {'name': 'Art', 'icon': Icons.brush},
    {'name': 'Animals', 'icon': Icons.pets},
    {'name': 'Cooking', 'icon': Icons.restaurant},
    {'name': 'Photo', 'icon': Icons.camera_alt},
  ];

  final List<String> selectedHobbies = []; // Liste des hobbies sélectionnés
  final Map<String, Color> selectedColors =
      {}; // Couleurs aléatoires pour chaque sélection

  @override
  void initState() {
    super.initState();
    _checkAndRedirect(); // Vérifiez et redirigez si nécessaire
  }

  // Vérifier et rediriger si des hobbies existent déjà
  Future<void> _checkAndRedirect() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final hobbiesFromDB = List<String>.from(doc.data()?['hobbies'] ?? []);

        if (hobbiesFromDB.isNotEmpty) {
          // Rediriger directement vers la page suivante
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomNavBar()),
          );
        } else {
          // Charger les hobbies si l'utilisateur n'a pas encore sélectionné
          setState(() {
            selectedHobbies.addAll(hobbiesFromDB);
            for (var hobby in hobbiesFromDB) {
              selectedColors[hobby] = _generateRandomColor();
            }
          });
        }
      }
    }
  }

  // Générer une couleur aléatoire
  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(156) + 100,
      random.nextInt(156) + 100,
      random.nextInt(156) + 100,
    ).withOpacity(0.8); // Couleur vive
  }

  Future<void> _saveHobbiesToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'hobbies': selectedHobbies,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hobbies saved successfully!")),
        );

        // Rediriger vers la page suivante après la sauvegarde
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user logged in!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving hobbies: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Select hobbies\n& interests.",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: hobbies.length,
                itemBuilder: (context, index) {
                  final hobby = hobbies[index];
                  final isSelected = selectedHobbies.contains(hobby['name']);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHobbies.remove(hobby['name']);
                          selectedColors.remove(hobby['name']);
                        } else {
                          selectedHobbies.add(hobby['name']);
                          selectedColors[hobby['name']] =
                              _generateRandomColor();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColors[hobby['name']]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hobby['icon'],
                            size: 30,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            hobby['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _saveHobbiesToFirebase,
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      children: [
                        const Text(
                          "Start",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
