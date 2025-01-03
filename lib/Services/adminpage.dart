import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _hobbyNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  Future<void> _addDataToFirestore() async {
    final String hobbyName = _hobbyNameController.text.trim();
    final String title = _titleController.text.trim();
    final String imageUrl = _imageUrlController.text.trim();
    final List<String> hashtags = _hashtagsController.text
        .trim()
        .split(',')
        .map((e) => e.trim())
        .toList();

    if (hobbyName.isEmpty || title.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      // Ajouter les données dans Firestore
      await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(hobbyName)
          .collection('posts')
          .add({
        'title': title,
        'imageUrl': imageUrl,
        'hashtags': hashtags,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data added successfully for $hobbyName!")),
      );

      // Clear les champs après ajout
      _hobbyNameController.clear();
      _titleController.clear();
      _imageUrlController.clear();
      _hashtagsController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin: Add Hobby Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _hobbyNameController,
              decoration: const InputDecoration(
                labelText: "Hobby Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Post Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: "Image URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hashtagsController,
              decoration: const InputDecoration(
                labelText: "Hashtags (comma-separated)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDataToFirestore,
              child: const Text("Add Data"),
            ),
          ],
        ),
      ),
    );
  }
}
