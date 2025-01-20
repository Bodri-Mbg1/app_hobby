import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityDetailsPage extends StatefulWidget {
  final Map<String, dynamic> community;
  final String hobbyId;

  const CommunityDetailsPage({
    super.key,
    required this.community,
    required this.hobbyId,
  });

  @override
  State<CommunityDetailsPage> createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isMember = false;
  String? editingCommentId; // ID du commentaire en cours de modification
  bool showCommentField =
      false; // Pour afficher/masquer le champ de commentaire

  @override
  void initState() {
    super.initState();
    _checkMembership();
  }

  Future<void> _checkMembership() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isMember = widget.community['creatorId'] == user.uid;
    });

    if (!isMember) {
      final doc = await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(widget.hobbyId)
          .collection('communities')
          .doc(widget.community['id'])
          .collection('members')
          .doc(user.uid)
          .get();

      setState(() {
        isMember = doc.exists;
      });
    }
  }

  Future<void> _joinCommunity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(widget.hobbyId)
          .collection('communities')
          .doc(widget.community['id'])
          .collection('members')
          .doc(user.uid)
          .set({
        'joinedAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'userPhoto': user.photoURL ?? '',
      });

      setState(() {
        isMember = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have joined the community!')),
      );
    } catch (e) {
      print('Error joining community: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error joining the community.')),
      );
    }
  }

  Future<void> _postComment(String comment) async {
    if (comment.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (editingCommentId == null) {
        // Ajouter un nouveau commentaire
        await FirebaseFirestore.instance
            .collection('hobbies')
            .doc(widget.hobbyId)
            .collection('communities')
            .doc(widget.community['id'])
            .collection('comments')
            .add({
          'userId': user.uid,
          'userName': user.displayName ?? 'Anonymous',
          'photoUrl': user.photoURL ?? '',
          'comment': comment,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully!')),
        );
      } else {
        // Modifier un commentaire existant
        await FirebaseFirestore.instance
            .collection('hobbies')
            .doc(widget.hobbyId)
            .collection('communities')
            .doc(widget.community['id'])
            .collection('comments')
            .doc(editingCommentId)
            .update({
          'comment': comment,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          editingCommentId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment updated successfully!')),
        );
      }

      _commentController.clear();
      setState(() {
        showCommentField = false;
      });
    } catch (e) {
      print('Error posting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error posting comment.')),
      );
    }
  }

  Widget _buildCommentSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hobbies')
          .doc(widget.hobbyId)
          .collection('communities')
          .doc(widget.community['id'])
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final comments = snapshot.data!.docs;

        if (comments.isEmpty) {
          return const Text('No comments yet. Be the first to comment!');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index].data() as Map<String, dynamic>;
            final DateTime createdAt =
                (comment['createdAt'] as Timestamp?)?.toDate() ??
                    DateTime.now();

            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: comment['photoUrl'] != null &&
                        comment['photoUrl'].isNotEmpty
                    ? NetworkImage(
                        comment['photoUrl']) // Utilisez l'URL si elle existe
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider, // Sinon, utilisez une image par défaut
                child:
                    comment['photoUrl'] == null || comment['photoUrl'].isEmpty
                        ? const Icon(Icons.person, size: 20)
                        : null,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comment['userName'] ?? 'Anonymous',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    timeago.format(createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Text(comment['comment'] ?? ''),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.community['imageUrl'].startsWith('data:image/')
                    ? Image.memory(
                        _decodeBase64Image(widget.community['imageUrl']),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.community['imageUrl'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),
              Text(widget.community['description'],
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: widget.community['hashtags']
                    .map<Widget>((hashtag) => Chip(label: Text('#$hashtag')))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Divider(),
              const SizedBox(height: 8),
              _buildCommentSection(),
              const SizedBox(height: 56),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ de commentaire qui s'affiche en haut
                  if (showCommentField)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Write a comment...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () =>
                                _postComment(_commentController.text.trim()),
                          ),
                        ],
                      ),
                    ),
                  // Icône et bouton alignés côte à côte
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrer horizontalement
                    children: [
                      // Icône pour afficher le champ de commentaire
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 2.0)),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline),
                          onPressed: () {
                            setState(() {
                              showCommentField = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Espacement entre les deux éléments
                      // Bouton "Join now" ou "You are a member"
                      if (FirebaseAuth.instance.currentUser?.uid !=
                          widget.community['creatorId'])
                        GestureDetector(
                          onTap: () {
                            if (!isMember) {
                              _joinCommunity();
                            }
                          },
                          child: Container(
                            height: 80,
                            width: 170,
                            decoration: BoxDecoration(
                              color: isMember ? Colors.grey : Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                isMember ? 'You are a member' : 'Join now',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
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
