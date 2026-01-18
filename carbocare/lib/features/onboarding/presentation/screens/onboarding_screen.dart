import 'package:flutter/material.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation Controllers
  late AnimationController _imageAnimController;
  late AnimationController _textAnimController;
  late AnimationController _buttonAnimController;

  // Animations
  late Animation<double> _imageScaleAnim;
  late Animation<double> _imageRotateAnim;
  late Animation<Offset> _textSlideAnim;
  late Animation<double> _textFadeAnim;
  late Animation<double> _buttonScaleAnim;
  late Animation<double> _buttonFadeAnim;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "โลกกำลังส่งสัญญาณเตือน 🌩️",
      "desc":
          "น้ำท่วมฉับพลัน พายุรุนแรง และอากาศที่ร้อนจัด ไม่ใช่เรื่องบังเอิญ แต่คือผลกระทบจาก \"ภาวะโลกเดือด\" ที่กำลังคุกคามชีวิตประจำวันของเรา",
      "image": "assets/earth/onboarding1.png",
    },
    {
      "title": "คาร์บอน = ผ้าห่มล่องหน 🌫️",
      "desc":
          "ก๊าซคาร์บอนจากการเดินทางและการใช้ชีวิต ลอยขึ้นไปสะสมเหมือน \"ผ้าห่มหนาๆ\" ที่ห่อหุ้มโลกไว้ ทำให้ความร้อนระบายออกไม่ได้ จนโลกเป็นไข้สูง",
      "image": "assets/earth/onboarding2.png",
    },
    {
      "title": "กู้โลกได้...เริ่มที่ก้าวของคุณ 👣",
      "desc":
          "แค่เปลี่ยนการเดินทาง ขยับมาเดิน หรือปั่นจักรยาน ก็ช่วยดึงผ้าห่มร้อนๆ ออกจากโลกได้ มาเริ่มสะสมแต้มความดีและลดคาร์บอนไปพร้อมกันเถอะ!",
      "image": "assets/earth/onboarding3.png",
    },
  ];

  final List<Color> _bgColors = [
    const Color(0xFFFFE5E5),
    const Color(0xFFFFF4E0),
    const Color(0xFFE8F5E9),
  ];

  final List<Color> _textColors = [
    Color(0xFFD32F2F),
    Color(0xFFE65100),
    Color(0xFF2E7D32),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    // Image Animation Controller
    _imageAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _imageScaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimController,
        curve: Curves.elasticOut,
      ),
    );

    _imageRotateAnim = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _imageAnimController,
        curve: Curves.easeOutBack,
      ),
    );

    // Text Animation Controller
    _textAnimController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimController,
        curve: Curves.easeOutCubic,
      ),
    );

    _textFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimController,
        curve: Curves.easeIn,
      ),
    );

    // Button Animation Controller
    _buttonAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimController,
        curve: Curves.easeOutBack,
      ),
    );

    _buttonFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _imageAnimController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _textAnimController.forward();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      _buttonAnimController.forward();
    });
  }

  void _resetAndPlayAnimations() {
    _imageAnimController.reset();
    _textAnimController.reset();
    _buttonAnimController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    _textAnimController.dispose();
    _buttonAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _bgColors[_currentPage],
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentPage < 2)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: TextButton(
                              onPressed: _goToHome,
                              child: Text(
                                "ข้าม",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      const SizedBox(height: 48),
                  ],
                ),
              ),

              // Content PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _resetAndPlayAnimations();
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Image
                          AnimatedBuilder(
                            animation: _imageAnimController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _imageScaleAnim.value,
                                child: Transform.rotate(
                                  angle: _imageRotateAnim.value,
                                  child: Container(
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _textColors[index]
                                              .withOpacity(0.2),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        _onboardingData[index]["image"]!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 50),

                          // Animated Title
                          SlideTransition(
                            position: _textSlideAnim,
                            child: FadeTransition(
                              opacity: _textFadeAnim,
                              child: Text(
                                _onboardingData[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: _textColors[index],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Animated Description
                          SlideTransition(
                            position: _textSlideAnim,
                            child: FadeTransition(
                              opacity: _textFadeAnim,
                              child: Text(
                                _onboardingData[index]["desc"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 10,
                          width: _currentPage == index ? 30 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _textColors[_currentPage]
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Animated Button
                    ScaleTransition(
                      scale: _buttonScaleAnim,
                      child: FadeTransition(
                        opacity: _buttonFadeAnim,
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: _currentPage == 2
                              ? _buildFinalButton()
                              : _buildNextButton(),
                        ),
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

  Widget _buildNextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _textColors[_currentPage],
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: _textColors[_currentPage].withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "ถัดไป",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value * 5, 0),
                child: const Icon(Icons.arrow_forward_rounded, size: 22),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinalButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.green.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: _goToHome,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.95, end: 1.05),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "เริ่มต้นภารกิจกู้โลก",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 2000),
                  builder: (context, rotateValue, child) {
                    return Transform.rotate(
                      angle: rotateValue * 0.5,
                      child: const Text(
                        "🌍",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}