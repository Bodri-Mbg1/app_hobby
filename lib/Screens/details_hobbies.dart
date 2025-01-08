import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsHobbies extends StatefulWidget {
  const DetailsHobbies({super.key});

  @override
  State<DetailsHobbies> createState() => _DetailsHobbiesState();
}

class _DetailsHobbiesState extends State<DetailsHobbies> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Sunday running"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: PageView(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image.asset(
                          "assets/img/Frame-4477.png",
                          fit: BoxFit
                              .cover, // Ajuste l'image pour remplir le conteneur
                          width: double
                              .infinity, // Largeur infinie pour remplir le conteneur
                          height: 200, // Hauteur fixe du conteneur
                        ),
                        Image.asset(
                          "assets/img/istockphoto-1324624694-612x612.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                        Image.asset(
                          "assets/img/sunrise-runner.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: 170,
                child: SmoothPageIndicator(
                  controller: pageController, // Le contrôleur de PageView
                  count: 3, // Nombre total de pages
                  effect: const ExpandingDotsEffect(
                    spacing: 4.5,
                    expansionFactor: 2.0, // Expansion des cercles actifs
                    activeDotColor: Colors.black, // Couleur du cercle actif
                    dotColor: Colors.white, // Couleur des cercles inactifs

                    dotWidth: 3.0, // Largeur des cercles
                    dotHeight: 4.0, // Hauteur des cercles
                  ),
                ),
              )
            ],
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.varelaRound(
                color: Colors.black,
                fontSize: 17,
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'david_234',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' We organize runs every\nSunday and gather on Mission District...',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
