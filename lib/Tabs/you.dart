import 'package:app_hobby/Screens/details_hobbies.dart';
import 'package:flutter/material.dart';

class You extends StatefulWidget {
  const You({super.key});

  @override
  State<You> createState() => _YouState();
}

class _YouState extends State<You> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Text(
                  'Sport communities',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  '4 active',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailsHobbies()));
                  },
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset('assets/img/Frame-4477.png'),
                              ),
                              Positioned(
                                bottom: 110,
                                right: 7,
                                child: Container(
                                  height: 25,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffa6b2b7),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      Text('24',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text('    Sunday running',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          const Text(
                              '    #sunday # sport #running\n    #team #marathon'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  'assets/img/yoga-ameliorer-sommeil.jpg',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 110,
                              right: 7,
                              child: Container(
                                height: 25,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xffa6b2b7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('24',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('    Sunday running',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const Text(
                            '    #sunday # sport #running\n    #team #marathon'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Text(
                  'Cooking posts',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  'View all',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 220,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/img/BlogSeries2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 90,
                              right: 7,
                              child: Container(
                                height: 25,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xffa6b2b7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('42',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ]),
                          const SizedBox(height: 10),
                          const Text(' Sunday running',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text('#sunday # sport #running #team',
                              style: TextStyle(fontSize: 10)),
                        ]),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 220,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/img/images (3).jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 90,
                              right: 7,
                              child: Container(
                                height: 25,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xffa6b2b7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('35',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ]),
                          const SizedBox(height: 10),
                          const Text(' Sunday running',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text('#sunday # sport #running #team',
                              style: TextStyle(fontSize: 10)),
                        ]),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 220,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/img/how-to-make-banh-mi-vietnamese-baguette-bread-from-scratch-fluffy-cottony-inside-thumb.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 90,
                              right: 7,
                              child: Container(
                                height: 25,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xffa6b2b7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('24',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ]),
                          const SizedBox(height: 10),
                          const Text(' Sunday running',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text('#sunday # sport #running #team',
                              style: TextStyle(fontSize: 10)),
                        ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
