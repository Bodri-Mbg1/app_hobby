import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  late GoogleMapController mapController;

  // ignore: unused_field
  final LatLng _initialPosition =
      const LatLng(37.7749, -122.4194); // San Francisco

  // ignore: unused_element
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String userName = 'User'; // Nom par défaut
  String? photoUrl; // Photo par défaut (null si aucune photo n'est disponible)

  @override
  void initState() {
    super.initState();
    _loadGoogleUserData();
  }

  void _loadGoogleUserData() {
    final User? googleUser = FirebaseAuth.instance.currentUser;

    if (googleUser != null) {
      // Si un utilisateur Google est connecté, récupérer ses informations
      setState(() {
        userName = googleUser.displayName ?? 'Google User';
        photoUrl = googleUser.photoURL;
      });
    } else {
      // Si aucun utilisateur n'est connecté
      setState(() {
        userName = 'User';
        photoUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                // Avatar de l'utilisateur
                CircleAvatar(
                  radius: 24,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(
                    width:
                        16), // Espacement entre l'avatar et le champ de recherche
                // Champ de recherche
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Google Map
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  try {
                    mapController = controller;
                  } catch (e) {
                    // ignore: avoid_print
                    print("Erreur lors de la création de la carte : $e");
                  }
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194),
                  zoom: 10.0,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
