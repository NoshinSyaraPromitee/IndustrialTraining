import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IUT ID Card',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 23, 7),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkPanel = Color(0xFF1E1E1E);
    const accentBlue = Color(0xFF2E86DE);

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),

          child: Container(
            width: 340,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            clipBehavior: Clip.antiAlias,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // IUT HEADER
                Container(
                  width: double.infinity,
                  color: darkPanel,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),

                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/iut.png',
                        width: 80,
                        height: 80,

                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.shield_outlined,
                            size: 80,
                            color: Colors.white,
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // STUDENT PHOTO
                Transform.translate(
                  offset: const Offset(0, -35),

                  child: Container(
                    width: 130,
                    height: 150,

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: darkPanel,
                        width: 3,
                      ),
                      color: Colors.grey.shade200,
                    ),

                    child: Image.asset(
                      'assets/images/pic.png',
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.grey.shade500,
                        );
                      },
                    ),
                  ),
                ),

                // STUDENT INFORMATION
                Transform.translate(
                  offset: const Offset(0, -25),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        // Student ID label
                        Row(
                          children: [
                            const Icon(
                              Icons.vpn_key,
                              size: 22,
                              color: Colors.black87,
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              'Student ID',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Student ID
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: darkPanel,
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Container(
                                width: 26,
                                height: 26,

                                decoration: const BoxDecoration(
                                  color: accentBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Text(
                                '220041120',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),

                              const SizedBox(width: 16),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Student Name
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 22,
                              color: Colors.black87,
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              'Student Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            top: 2,
                          ),

                          child: Text(
                            'Noshin Syara',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Program
                        Row(
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 22,
                              color: Colors.black87,
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              'Program B.Sc. in CSE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Department
                        Row(
                          children: [
                            const Icon(
                              Icons.groups_outlined,
                              size: 22,
                              color: Colors.black87,
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              'Department CSE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Country
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 22,
                              color: Colors.black87,
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              'Bangladesh',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // FOOTER
                Container(
                  width: double.infinity,
                  color: darkPanel,
                  padding: const EdgeInsets.symmetric(vertical: 12),

                  child: const Text(
                    'A subsidiary organ of OIC',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
