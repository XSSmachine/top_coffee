import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/auth_controller.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/pages/auth/sign_in_page.dart';
import 'package:team_coffee/pages/home/home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../utils/dimensions.dart';
import '../error/error_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _donutsAnimation;
  late Animation<double> _kafaAnimation;
  late Animation<double> _friesAnimation;
  late Animation<double> _hamburgerAnimation;
  late Animation<double> _sodaAnimation;
  late Animation<double> _titleOpacityAnimation;

  final AuthController auth = Get.find<AuthController>();

  late AudioPlayer player = AudioPlayer();

  final EventController _eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    ;
    player = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _donutsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _kafaAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    _friesAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1, curve: Curves.easeOutCirc),
      ),
    );
    _hamburgerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _sodaAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1, curve: Curves.decelerate),
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

  Future<void> _startAnimation() async {
    _animationController.forward().then((_) async {
      // Check internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _navigateToErrorPage("No internet connection");
        return;
      }

      if (auth.userLoggedIn()) {
        try {
          await _eventController.fetchPendingEvents("MIX");
          await _eventController.fetchInProgressEvents("MIX");
          _navigateToHomePage();
        } catch (e) {
          _navigateToErrorPage(
              "Failed to fetch events. Please try again later.");
        }
      } else {
        _navigateToSignInPage();
      }
    });
  }

  void _navigateToErrorPage(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ErrorPage(message: message)),
    );
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _navigateToSignInPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
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
              top: -Dimensions.height10 * 5,
              right: Dimensions.width10 * 16,
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
                  radius: Dimensions.radius20 * 6.5,
                  child: Image.asset(
                    "assets/image/donuts.png",
                    width: Dimensions.width10 * 33,
                    height: Dimensions.width10 * 33,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -Dimensions.height10 * 5,
              right: Dimensions.width20,
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
                  radius: Dimensions.radius20 * 4,
                  child: Image.asset(
                    "assets/image/kafa.png",
                    width: Dimensions.width10 * 15,
                    height: Dimensions.width10 * 15,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Dimensions.height20 * 9.5,
              right: Dimensions.width20 * 2.2,
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
                  radius: Dimensions.radius20 * 3.5,
                  child: Image.asset(
                    "assets/image/fries.png",
                    width: Dimensions.width20 * 9,
                    height: Dimensions.width20 * 9,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Dimensions.height20 * 20,
              right: Dimensions.width20 * 2.5,
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
                  radius: Dimensions.radius15 * 6,
                  child: Image.asset(
                    "assets/image/hamburger.png",
                    width: Dimensions.width20 * 12.5,
                    height: Dimensions.width20 * 12.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Dimensions.height10 * 36,
              right: Dimensions.width20 * 12.5,
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
                  radius: Dimensions.radius20 * 4,
                  child: Image.asset(
                    "assets/image/soda.png",
                    width: Dimensions.width15 * 10,
                    height: Dimensions.width15 * 10,
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
                          fontSize: Dimensions.font20 * 2.5,
                          fontWeight: FontWeight.w600,
                          height: 0.8,
                        ),
                      ),
                      Text(
                        "Snack",
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 2.5,
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
