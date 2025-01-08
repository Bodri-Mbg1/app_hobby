import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabForyou extends StatefulWidget {
  const TabForyou({super.key});

  @override
  State<TabForyou> createState() => _TabForyouState();
}

class _TabForyouState extends State<TabForyou> {
  List<Map<String, dynamic>> categories = [];
  List<String> selectedHobbies = [];

  @override
  void initState() {
    super.initState();
    _loadUserHobbies();
  }

  // Récupérer les hobbies sélectionnés par l'utilisateur depuis Firebase
  Future<void> _loadUserHobbies() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            selectedHobbies = List<String>.from(doc.data()?['hobbies'] ?? []);
          });

          // Charger les catégories pour les hobbies sélectionnés
          await _loadCategoriesForSelectedHobbies();
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des hobbies : $e");
    }
  }

  // Récupérer les catégories uniquement pour les hobbies sélectionnés
  Future<void> _loadCategoriesForSelectedHobbies() async {
    final data = await fetchCategoriesForSelectedHobbies(selectedHobbies);
    setState(() {
      categories = data;
    });
  }

  // Récupérer les catégories des hobbies sélectionnés
  Future<List<Map<String, dynamic>>> fetchCategoriesForSelectedHobbies(
      List<String> hobbies) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      List<Map<String, dynamic>> allCategories = [];

      for (var hobby in hobbies) {
        // Récupérer les catégories pour chaque hobby sélectionné
        final QuerySnapshot categoriesSnapshot = await firestore
            .collection('hobbies')
            .doc(hobby)
            .collection('categories')
            .get();

        // Ajouter les catégories à la liste finale
        final categories = categoriesSnapshot.docs
            .map((catDoc) => catDoc.data() as Map<String, dynamic>)
            .toList();
        allCategories.addAll(categories);
      }

      return allCategories;
    } catch (e) {
      print("Erreur lors de la récupération des catégories : $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: categories.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            category['imageUrl'] ?? '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Titre
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            category['title'] ?? "Sans titre",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Hashtags
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Wrap(
                            spacing: 4,
                            children: (category['hashtags'] as List<dynamic>?)
                                    ?.map((hashtag) => Text(
                                          hashtag,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),
                        ),

                        // Badge d'indicateur
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.people,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "24", // Exemple statique
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
