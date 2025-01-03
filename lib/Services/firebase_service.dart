import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<void> addHobbyData(String hobbyName, String title,
      String imageUrl, List<String> hashtags) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore
          .collection('hobbies')
          .doc(hobbyName)
          .collection('posts')
          .add({
        'title': title,
        'imageUrl': imageUrl,
        'hashtags': hashtags,
      });

      print("Données ajoutées avec succès pour $hobbyName !");
    } catch (e) {
      print("Erreur lors de l'ajout des données : $e");
    }
  }
}
