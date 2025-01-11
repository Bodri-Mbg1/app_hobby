import 'dart:convert';
import 'dart:typed_data';
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

        loadedCommunities.addAll(communitySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'title': data['title'] ?? 'Untitled',
            'description': data['description'] ?? '',
            'imageUrl': data['imageUrl'] ?? '',
            'hashtags': List<String>.from(data['hashtags'] ?? []),
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
            'title': data['title'] ?? 'Untitled',
            'description': data['description'] ?? '',
            'imageUrl': data['imageUrl'] ?? '',
            'hashtags': List<String>.from(data['hashtags'] ?? []),
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
                    child: Text('No communities found.',
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
                    child: Text('No posts found.',
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
    return Padding(
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
    );
  }

  // Widget pour afficher une carte de post
  Widget _buildPostCard(Map<String, dynamic> post) {
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
