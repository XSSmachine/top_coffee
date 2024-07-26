import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/controllers/auth_controller.dart';
import 'package:team_coffee/pages/auth/group_page.dart';
import 'package:team_coffee/pages/auth/sign_in_page.dart';
import 'package:team_coffee/pages/home/home_page.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';


import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _donutsAnimation;
  late Animation<double> _kafaAnimation;
  late Animation<double> _friesAnimation;
  late Animation<double> _hamburgerAnimation;
  late Animation<double> _sodaAnimation;
  late Animation<double> _titleOpacityAnimation;

  late AuthController auth;

  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    auth=Get.find<AuthController>();
    player = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _donutsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _kafaAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    _friesAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 1, curve: Curves.easeOutCirc),
      ),
    );
    _hamburgerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _sodaAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1, curve: Curves.decelerate),
      ),
    );
    _kafaAnimation.addListener(() async {
      if (_kafaAnimation.value == 1.0) {
        await player.setSource(AssetSource('audio/crunchy.mp3'));
        await player.resume();
      }
    });

   _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward().then((_) {
      if(auth.groupId.isNotEmpty){
        if(auth.userLoggedIn()){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroupPage()),
        );
      }


    });


  }

  @override
  void dispose() {
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: 180,
              child: AnimatedBuilder(
                animation: _donutsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _donutsAnimation.value * 200),
                    child: Transform.rotate(
                      angle: _donutsAnimation.value * 0.8,
                      child: Transform.scale(
                        scale: _donutsAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 130,
                  child: Image.asset(
                    "assets/image/donuts.png",
                    width: 330,
                    height: 330,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: 20,
              child: AnimatedBuilder(
                animation: _kafaAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _kafaAnimation.value * 150),
                    child: Transform.rotate(
                      angle: _kafaAnimation.value * 0.6,
                      child: Transform.scale(
                        scale: _kafaAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80,
                  child: Image.asset(
                    "assets/image/kafa.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: 60,
              child: AnimatedBuilder(
                animation: _friesAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _friesAnimation.value * 100),
                    child: Transform.rotate(
                      angle: _friesAnimation.value * 0.4,
                      child: Transform.scale(
                        scale: _friesAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  child: Image.asset(
                    "assets/image/fries.png",
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 400,
              right: 50,
              child: AnimatedBuilder(
                animation: _hamburgerAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _hamburgerAnimation.value * 200),
                    child: Transform.rotate(
                      angle: _hamburgerAnimation.value * 0.8,
                      child: Transform.scale(
                        scale: _hamburgerAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 90,
                  child: Image.asset(
                    "assets/image/hamburger.png",
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 360,
              right: 250,
              child: AnimatedBuilder(
                animation: _sodaAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _sodaAnimation.value * 150),
                    child: Transform.rotate(
                      angle: _sodaAnimation.value * 0.6,
                      child: Transform.scale(
                        scale: _sodaAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80,
                  child: Image.asset(
                    "assets/image/soda.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: AnimatedBuilder(
                  animation: _titleOpacityAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _titleOpacityAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sync",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          height: 0.8,
                        ),
                      ),
                      Text(
                        "Snack",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}