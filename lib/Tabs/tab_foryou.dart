import 'dart:convert';
import 'dart:typed_data';
import 'package:app_hobby/Screens/CommunityDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabForyou extends StatefulWidget {
  const TabForyou({super.key});

  @override
  State<TabForyou> createState() => _TabForyouState();
}

class _TabForyouState extends State<TabForyou> {
  List<Map<String, dynamic>> communities = [];
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  // Récupérer les communautés et les posts depuis Firestore
  Future<void> _loadEntities() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in.');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final List<String> hobbies =
          List<String>.from(userDoc.data()?['hobbies'] ?? []);

      if (hobbies.isEmpty) {
        setState(() {
          communities = [];
          posts = [];
        });
        return;
      }

      List<Map<String, dynamic>> loadedCommunities = [];
      List<Map<String, dynamic>> loadedPosts = [];

      for (String hobby in hobbies) {
        // Charger les communautés
        final communitySnapshot = await FirebaseFirestore.instance
            .collection('hobbies')
            .doc(hobby)
            .collection('communities')
            .get();

        for (var doc in communitySnapshot.docs) {
          final data = doc.data();

          // Compter les membres de chaque communauté
          final membersSnapshot = await FirebaseFirestore.instance
              .collection('hobbies')
              .doc(hobby)
              .collection('communities')
              .doc(doc.id)
              .collection('members')
              .get();

          loadedCommunities.add({
            ...data,
            'id': doc.id,
            'hobbyId': hobby,
            'memberCount': membersSnapshot.size, // Nombre de membres
          });
        }
      }

      for (String hobby in hobbies) {
        // Charger les communautés
        final communitySnapshot = await FirebaseFirestore.instance
            .collection('hobbies')
            .doc(hobby)
            .collection('communities')
            .get();

        loadedCommunities.addAll(communitySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            ...data,
            'id': doc.id, // Ajouter l'ID du document
            'hobbyId': hobby, // ID du hobby associé
          };
        }).toList());

        // Charger les posts
        final postSnapshot = await FirebaseFirestore.instance
            .collection('hobbies')
            .doc(hobby)
            .collection('posts')
            .get();

        loadedPosts.addAll(postSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            ...data,
            'id': doc.id, // Ajouter l'ID du document
            'hobbyId': hobby, // ID du hobby associé
          };
        }).toList());
      }

      setState(() {
        communities = loadedCommunities;
        posts = loadedPosts;
      });
    } catch (e) {
      print('Error loading entities: $e');
    }
  }

  Future<void> _deleteCommunity(Map<String, dynamic> community) async {
    try {
      await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(community[
              'hobbyId']) // Remplacez par la logique pour obtenir l'ID du hobby
          .collection('communities')
          .doc(community['id']) // Assurez-vous d'avoir stocké l'ID du document
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Community deleted successfully!')),
      );

      _loadEntities(); // Rechargez les communautés après suppression
    } catch (e) {
      print('Error deleting community: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting community.')),
      );
    }
  }

  Future<void> _deletePost(Map<String, dynamic> post) async {
    try {
      await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(post[
              'hobbyId']) // Remplacez par la logique pour obtenir l'ID du hobby
          .collection('posts')
          .doc(post['id']) // Assurez-vous d'avoir stocké l'ID du document
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully!')),
      );

      _loadEntities(); // Rechargez les posts après suppression
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting post.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre pour les communautés
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Communities',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Liste horizontale pour les communautés
            communities.isEmpty
                ? const Center(
                    child: Text('Wait for communities...',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return _buildCommunityCard(community);
                      },
                    ),
                  ),
            const SizedBox(height: 20),

            // Titre pour les posts
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Posts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Liste horizontale pour les posts
            posts.isEmpty
                ? const Center(
                    child: Text('Wait for posts...',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return _buildPostCard(post);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une carte de communauté
  Widget _buildCommunityCard(Map<String, dynamic> community) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        // Naviguer vers la page de détails de la communauté
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailsPage(
              community: community,
              hobbyId: community['hobbyId'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 240,
          width: 270,
          decoration: BoxDecoration(
            color: const Color(0xfffafafa),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: community['imageUrl'].startsWith('data:image/')
                          ? Image.memory(
                              _decodeBase64Image(community['imageUrl']),
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              community['imageUrl'],
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 140,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    // Afficher le nombre de membres
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 12),
                            Text(
                              '${community['memberCount'] ?? 0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (community['creatorId'] == currentUser?.uid)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCommunity(community),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  community['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: community['hashtags']
                      .map<Widget>((hashtag) => Text(
                            '#$hashtag',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xfffafafa),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: post['imageUrl'].startsWith('data:image/')
                        ? Image.memory(
                            _decodeBase64Image(post['imageUrl']),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            post['imageUrl'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (post['creatorId'] ==
                      currentUser?.uid) // Vérifie si c'est le créateur
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePost(post),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post['title'],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Wrap(
                spacing: 4,
                children: post['hashtags']
                    .map<Widget>((hashtag) => Text(
                          '#$hashtag',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image(String base64String) {
    final String base64Data = base64String.split(',')[1];
    return base64Decode(base64Data);
  }
}
