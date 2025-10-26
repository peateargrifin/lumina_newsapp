// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:news/extensions/mediaquery.dart';
//
// import 'home.dart';
//
// class splash extends StatefulWidget {
//   const splash({super.key});
//
//   @override
//   State<splash> createState() => _splashState();
// }
//
// class _splashState extends State<splash> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(width: double.infinity),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20.0), // round corners
//               child: Image.asset(
//                 'assets/images/peakpx.jpg',
//                 width: context.width * 0.8, // resize width
//                 height: context.height * 0.6, // resize height
//                 fit: BoxFit.cover, // adjust how image fits
//               ),
//             ),
//
//             SizedBox(height: context.height * 0.04),
//
//             Text(
//               'N E W S   A P P.',
//               style: GoogleFonts.rockSalt(
//                 letterSpacing: 0.6,
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             SizedBox(height: context.height * 0.04),
//
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => home()),
//                 );
//               },
//               child: Container(
//                 child: Text('stay informed , stay ahead.'),
//                 //color: Colors.blueGrey,
//                 padding: EdgeInsets.all(10),
//                 alignment: Alignment.center,
//                 width: context.width * 0.8,
//                 height: context.height * 0.05,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Color(0xFFF88EA8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/extensions/mediaquery.dart';

import 'home.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFCF9EA),
              Color(0xFFBADFDB),
              Color(0xFFFFBDBD),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: context.height * 0.08),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: context.width * 0.7,
                          height: context.width * 0.7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: Offset(0, 15),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/peakpx.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.height * 0.06),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Lumira',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: context.width * 0.12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                '.',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: context.width * 0.12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFC107),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: context.height * 0.015),

                          Text(
                            'Stay Informed, Stay Ahead',
                            style: GoogleFonts.inter(
                              fontSize: context.width * 0.042,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[900]?.withOpacity(0.9),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom section with button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.08,
                  vertical: context.height * 0.05,
                ),
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => home()),
                          );
                        },
                        child: Container(
                          width: context.width * 0.85,
                          height: context.height * 0.07,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.height * 0.035),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.poppins(
                                fontSize: context.width * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2575FC),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.height * 0.025),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: context.width * 0.035,
                            color: Colors.grey[900]?.withOpacity(0.7),
                          ),
                          SizedBox(width: context.width * 0.015),
                          Text(
                            'Your trusted source for breaking news',
                            style: GoogleFonts.inter(
                              fontSize: context.width * 0.025,
                              color: Colors.grey[900]?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
