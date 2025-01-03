import 'dart:math'; // Import pour générer des couleurs aléatoires
import 'package:app_hobby/Screens/screen1.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Liste des hobbies avec leurs icônes
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

  // Générer une couleur aléatoire
  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Opacité maximale (0-255)
      random.nextInt(156) + 100, // Rouge (100-255)
      random.nextInt(156) + 100, // Vert (100-255)
      random.nextInt(156) + 100, // Bleu (100-255)
    ).withOpacity(0.5);
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
                  crossAxisCount: 3, // 3 colonnes
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
                          // Si déjà sélectionné, retirer de la liste
                          selectedHobbies.remove(hobby['name']);
                          selectedColors.remove(hobby['name']);
                        } else {
                          // Sinon, ajouter et générer une couleur aléatoire
                          selectedHobbies.add(hobby['name']);
                          selectedColors[hobby['name']] =
                              _generateRandomColor();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColors[hobby[
                                'name']] // Couleur aléatoire pour les sélections
                            : Colors.grey[
                                200], // Couleur uniforme pour les non-sélections
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
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
                          const SizedBox(height: 8),
                          Text(
                            hobby['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Screen1()));
                },
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      children: [
                        Text(
                          "Start",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Icon(Icons.arrow_forward_rounded),
                        )
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