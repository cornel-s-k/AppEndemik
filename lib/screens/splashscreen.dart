import 'package:flutter/material.dart';
import 'package:uasendemic/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 3), // Durasi total animasi
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    // Removed addListener here, as it's not strictly necessary for this specific animation.
    // The build method will re-render automatically when the controller updates.

    _animationController.forward(); // Mulai animasi
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animasi selesai, sekarang navigasi
        _navigateToHome();
      }
    });

  }

  // PENTING: Dispose AnimationController
  @override
  void dispose() {
    _animationController.dispose(); // <--- Pastikan ini ada!
    super.dispose();
  }

  void _navigateToHome() {
    // Pastikan widget masih ada di pohon widget sebelum melakukan navigasi
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Gunakan AnimatedBuilder untuk mengoptimalkan performa jika ada banyak widget anak
        // yang bergantung pada nilai animasi. Untuk Opacity saja, bisa juga langsung.
        child: AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            );
          },
          child: Column( // Pindahkan children ke sini
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/spalsh_logo.png', height: 150),
              SizedBox(height: 20),
              Text(
                "EndemikDB",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}