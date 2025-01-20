import 'package:app_hobby/Screens/EditHobbiesPage.dart';
import 'package:app_hobby/Screens/Screen_search.dart';
import 'package:flutter/material.dart';
import 'package:app_hobby/Screens/screen1.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.search, 'label': 'Search'},
    {'icon': Icons.send, 'label': 'Send'},
  ];

  final List<Widget> pages = [
    const Screen1(), // Page pour Home
    const EditHobbiesPage(),
    const ScreenSearch(),
    const Center(child: Text('Send Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Les pages derrière la nav bar
          IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
          // La nav bar
          Positioned(
            bottom: 16, // Position en bas
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Conteneur actif
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 55,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff1c1d21),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        navItems[selectedIndex]['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                      if (navItems[selectedIndex]['label'].isNotEmpty)
                        const SizedBox(width: 8),
                      if (navItems[selectedIndex]['label'].isNotEmpty)
                        Text(
                          navItems[selectedIndex]['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                // Icônes restantes
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(navItems.length, (index) {
                      if (index == selectedIndex) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            navItems[index]['icon'],
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
