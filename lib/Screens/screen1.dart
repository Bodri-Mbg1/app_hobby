import 'dart:io';
import 'dart:convert';
import 'package:app_hobby/Tabs/tab_foryou.dart';
import 'package:app_hobby/Tabs/you.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String userName = 'User';
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadGoogleUserData();
  }

  void _loadGoogleUserData() {
    final User? googleUser = FirebaseAuth.instance.currentUser;

    if (googleUser != null) {
      setState(() {
        userName = googleUser.displayName ?? 'Google User';
        photoUrl = googleUser.photoURL;
      });
    } else {
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
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 12),
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
                  const Icon(Icons.search, size: 35),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
            const Expanded(
              child: TabBarView(
                children: [
                  TabForyou(),
                  You(),
                  CreateOptionsTab(), // Page de choix ajoutée
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateOptionsTab extends StatelessWidget {
  const CreateOptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Crée ta communauté\nou ton poste",
              style: TextStyle(
                  fontSize: 35, fontWeight: FontWeight.w900, height: 1),
            ),
            const SizedBox(height: 20),
            Text(
                'Partage tes interets avec les autres utilisateurs, ou crée ton propre groupe de discussion'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 450,
              decoration: BoxDecoration(
                color: const Color(0xfffafafa),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/img/community.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateEntityTab(
                                        type: 'community'),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF039227),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    'Create Community',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/img/post.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateEntityTab(type: 'post'),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF039227),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    'Create Post',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateEntityTab extends StatefulWidget {
  final String type; // "community" ou "post"

  const CreateEntityTab({super.key, required this.type});

  @override
  State<CreateEntityTab> createState() => _CreateEntityTabState();
}

class _CreateEntityTabState extends State<CreateEntityTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  String? imageUrl;
  String? selectedHobby; // Hobby sélectionné
  List<String> hobbies = []; // Liste des hobbies de l'utilisateur

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  // Charger les hobbies de l'utilisateur depuis Firestore
  Future<void> _loadHobbies() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          hobbies = List<String>.from(doc.data()?['hobbies'] ?? []);
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des hobbies : $e');
    }
  }

  Future<void> _initializeHobby(String hobby) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('hobbies').doc(hobby);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Créer le document du hobby si nécessaire
        await docRef.set({
          'createdAt':
              FieldValue.serverTimestamp(), // Ajout d'une date de création
          'name': hobby, // Le nom du hobby
        });
        print('Hobby "$hobby" initialized in Firestore.');
      }
    } catch (e) {
      print('Error initializing hobby: $e');
      throw Exception('Failed to initialize hobby.');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        setState(() {
          imageUrl = 'data:image/png;base64,$base64Image';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  Future<void> _createEntity() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _hashtagsController.text.isEmpty ||
        imageUrl == null ||
        selectedHobby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a hobby.')),
      );
      return;
    }

    try {
      // Vérifier ou initialiser le hobby
      await _initializeHobby(selectedHobby!);

      // Déterminer la collection cible : "communities" ou "posts"
      final collection = widget.type == 'community' ? 'communities' : 'posts';

      // Préparer les données
      final data = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'hashtags':
            _hashtagsController.text.split(',').map((e) => e.trim()).toList(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Ajouter les données à la sous-collection appropriée
      await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(selectedHobby)
          .collection(collection)
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${widget.type == 'community' ? 'Community' : 'Post'} created successfully!')),
      );

      _clearFields();
    } catch (e) {
      print('Error creating ${widget.type}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating ${widget.type}: $e')),
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _hashtagsController.clear();
    setState(() {
      imageUrl = null;
      selectedHobby = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'community'
            ? 'Create a Community'
            : 'Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Hobby',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: selectedHobby,
              hint: const Text('Select Hobby'),
              isExpanded: true,
              items: hobbies.isEmpty
                  ? [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No hobbies available'),
                      )
                    ]
                  : hobbies.map((hobby) {
                      return DropdownMenuItem(
                        value: hobby,
                        child: Text(hobby),
                      );
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHobby = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hashtagsController,
              decoration: const InputDecoration(
                  labelText: 'Hashtags (comma-separated)'),
            ),
            const SizedBox(height: 10),
            imageUrl != null
                ? Image.network(imageUrl!)
                : ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Upload Image'),
                  ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: _createEntity,
                child: Text(widget.type == 'community'
                    ? 'Create Community'
                    : 'Create Post'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
