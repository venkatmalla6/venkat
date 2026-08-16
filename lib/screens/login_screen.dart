import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  bool _isLogin = true;
  bool _loading = false;
  bool _obscure = true;
  String? _errorMsg;
  bool _cardIsWhite = true; // White Card vs Black Ink Card
  bool _rememberMe = true;

  // Lighting & Character States
  bool _isLightOn = false;
  bool _isCoveringEyes = false;
  bool _isReachingSwitch = false;
  bool _isThumbsUp = false;
  String _characterSpeech = "Hold on, let me turn on the switch for you... 💡";

  // Animation Controllers
  late AnimationController _introController;
  late Animation<double> _walkAnimation;
  late AnimationController _breatheController;
  late AnimationController _blinkController;
  late AnimationController _cardEnterController;

  @override
  void initState() {
    super.initState();

    // Intro walk-in and switch flip animation
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _walkAnimation = Tween<double>(begin: -1.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Card entrance
    _cardEnterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Idle breathing & eye blinking animations
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Focus listeners for character reactions
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus) {
        setState(() {
          _isCoveringEyes = true;
          _characterSpeech = "I'm looking away! Your password is safe 🙈";
        });
      } else {
        setState(() {
          _isCoveringEyes = false;
          if (_isLightOn && !_isThumbsUp) {
            _characterSpeech = "I won't tell anyone! 😉";
          }
        });
      }
    });

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus && !_isCoveringEyes) {
        setState(() {
          _characterSpeech = "What's your email address? ✏️";
        });
      }
    });

    // Start cinematic intro on startup
    _playIntroSequence();
  }

  void _playIntroSequence() {
    setState(() {
      _isLightOn = false;
      _isReachingSwitch = false;
      _isCoveringEyes = false;
      _isThumbsUp = false;
      _characterSpeech = "Hold on, let me turn on the switch for you... 💡";
    });

    _introController.reset();
    _cardEnterController.reset();
    _introController.forward();

    // Reaching for the switch
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      setState(() {
        _isReachingSwitch = true;
        _characterSpeech = "Reaching the switch... *click*";
      });
    });

    // Switch flipped ON
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isLightOn = true;
        _isReachingSwitch = false;
        _characterSpeech = "Voila! Welcome to your sketchbook! ✨";
      });
      _cardEnterController.forward();
    });

    // Idle stance
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      setState(() {
        _isReachingSwitch = false;
      });
    });
  }

  void _toggleSwitch() {
    setState(() {
      _isLightOn = !_isLightOn;
      if (_isLightOn) {
        _cardEnterController.forward();
        _characterSpeech = "Light is ON! Let's get to work ✨";
      } else {
        _cardEnterController.reverse();
        _characterSpeech = "Who turned off the lights? 🔦";
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _introController.dispose();
    _breatheController.dispose();
    _blinkController.dispose();
    _cardEnterController.dispose();
    super.dispose();
  }

  // ── Firebase Auth ──────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_isLightOn) {
      _toggleSwitch();
    }
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _characterSpeech = "Oops, check the details in your sketch! ✏️";
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMsg = null;
      _characterSpeech = "Checking your sketch credentials... ⏳";
    });

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      }

      setState(() {
        _isThumbsUp = true;
        _characterSpeech = "You're in! Loading your timetable! 🎉";
      });

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/timetable');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMsg = _friendlyError(e.code);
        _characterSpeech = "Hmm, something didn't match. Try again! 🤔";
      });
    } catch (e) {
      // Fallback for offline demo mode
      setState(() {
        _isThumbsUp = true;
        _characterSpeech = "Welcome! Opening timetable... 🎉";
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/timetable');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    if (!_isLightOn) _toggleSwitch();
    setState(() {
      _loading = true;
      _errorMsg = null;
      _characterSpeech = "Connecting to Google... 🎨";
    });
    try {
      final provider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(provider);
      setState(() {
        _isThumbsUp = true;
        _characterSpeech = "Google signed in! Let's go! 🚀";
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pushReplacementNamed(context, '/timetable');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMsg = _friendlyError(e.code));
    } catch (e) {
      if (mounted) Navigator.pushReplacementNamed(context, '/timetable');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No sketch account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return 'Authentication failed ($code)';
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 860;

    // Background color based on switch
    final bgColor = _isLightOn
        ? const Color(0xFFFFDA44) // Vibrant warm yellow
        : const Color(0xFF141416); // Charcoal dark

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: _isLightOn
              ? const RadialGradient(
                  center: Alignment(-0.6, -0.6),
                  radius: 1.4,
                  colors: [
                    Color(0xFFFFEE88),
                    Color(0xFFFFDA44),
                    Color(0xFFE5B000),
                  ],
                  stops: [0.0, 0.45, 1.0],
                )
              : const RadialGradient(
                  center: Alignment(-0.6, -0.6),
                  radius: 1.2,
                  colors: [
                    Color(0xFF222228),
                    Color(0xFF141416),
                  ],
                ),
        ),
        child: Stack(
          children: [
            // Pencil paper texture & crosshatch painter
            Positioned.fill(
              child: CustomPaint(
                painter: _PencilPaperPainter(isLightOn: _isLightOn),
              ),
            ),

            // Top Toolbar: Brand, Card Theme Toggle & Replay Button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Logo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isLightOn ? const Color(0xFF1C1917) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.draw_rounded,
                            size: 20,
                            color: _isLightOn ? Colors.white : const Color(0xFF1C1917),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Atelier Sketch',
                          style: TextStyle(
                            color: _isLightOn ? const Color(0xFF1C1917) : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    // Actions
                    Row(
                      children: [
                        // Card Theme Switcher (White vs Black Card)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isLightOn
                                ? Colors.white.withValues(alpha: 0.3)
                                : const Color(0xFF27272A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isLightOn
                                  ? const Color(0xFF1C1917)
                                  : const Color(0xFF52525B),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildCardStyleToggle(
                                label: 'White',
                                isSelected: _cardIsWhite,
                                isLightOn: _isLightOn,
                                onTap: () => setState(() => _cardIsWhite = true),
                              ),
                              _buildCardStyleToggle(
                                label: 'Black',
                                isSelected: !_cardIsWhite,
                                isLightOn: _isLightOn,
                                onTap: () => setState(() => _cardIsWhite = false),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Replay Intro Button
                        ElevatedButton.icon(
                          onPressed: _playIntroSequence,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLightOn
                                ? Colors.white
                                : const Color(0xFF27272A),
                            foregroundColor: _isLightOn
                                ? const Color(0xFF1C1917)
                                : Colors.white,
                            elevation: 0,
                            side: BorderSide(
                              color: _isLightOn
                                  ? const Color(0xFF1C1917)
                                  : const Color(0xFF52525B),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          icon: const Icon(Icons.replay_rounded, size: 16),
                          label: const Text(
                            'Replay Intro',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Wall Light Switch
            Positioned(
              top: 80,
              left: 30,
              child: _buildSwitchPlate(),
            ),

            // Main Content Area
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left: Character Sketch Arena
                              Expanded(
                                flex: 5,
                                child: _buildCharacterSection(),
                              ),
                              const SizedBox(width: 40),
                              // Right: The Login Card
                              Expanded(
                                flex: 6,
                                child: _buildAnimatedLoginCard(),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              _buildCharacterSection(height: 230),
                              const SizedBox(height: 20),
                              _buildAnimatedLoginCard(),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Style Toggle Pill ──────────────────────────────────────────────────
  Widget _buildCardStyleToggle({
    required String label,
    required bool isSelected,
    required bool isLightOn,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLightOn ? const Color(0xFF1C1917) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? (isLightOn ? Colors.white : const Color(0xFF1C1917))
                : (isLightOn ? const Color(0xFF1C1917) : Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  // ── Hand-Drawn Light Switch Plate ──────────────────────────────────────────
  Widget _buildSwitchPlate() {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: Tooltip(
        message: 'Tap to flip the switch!',
        child: Column(
          children: [
            Container(
              width: 58,
              height: 94,
              decoration: BoxDecoration(
                color: _isLightOn
                    ? const Color(0xFFFAF8F2)
                    : const Color(0xFF27272A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isLightOn
                      ? const Color(0xFF1C1917)
                      : const Color(0xFF71717A),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isLightOn
                        ? const Color(0xFF1C1917).withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.6),
                    offset: const Offset(4, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top screw
                  _buildScrew(),
                  // Switch toggle
                  Container(
                    width: 28,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isLightOn
                          ? const Color(0xFFE4E4E7)
                          : const Color(0xFF18181B),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _isLightOn
                            ? const Color(0xFF1C1917)
                            : const Color(0xFF52525B),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          alignment: _isLightOn
                              ? Alignment.topCenter
                              : Alignment.bottomCenter,
                          child: Container(
                            width: 24,
                            height: 22,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: _isLightOn
                                  ? const Color(0xFFFEF08A)
                                  : const Color(0xFF52525B),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: const Color(0xFF1C1917),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 2,
                                  offset: _isLightOn
                                      ? const Offset(0, 2)
                                      : const Offset(0, -2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _isLightOn ? 'I' : 'O',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: _isLightOn
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom screw
                  _buildScrew(),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'LIGHT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: _isLightOn
                    ? const Color(0xFF1C1917)
                    : const Color(0xFFE4E4E7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrew() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: _isLightOn ? const Color(0xFFD4D4D8) : const Color(0xFF3F3F46),
        shape: BoxShape.circle,
        border: Border.all(
          color: _isLightOn ? const Color(0xFF1C1917) : const Color(0xFF71717A),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 1,
          color: _isLightOn ? const Color(0xFF1C1917) : Colors.white,
        ),
      ),
    );
  }

  // ── Character Arena & SVG-Like Custom Pencil Painter ───────────────────────
  Widget _buildCharacterSection({double height = 360}) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _introController,
        _breatheController,
        _blinkController,
      ]),
      builder: (context, child) {
        final walkOffset = _walkAnimation.value * 250;
        final breathe = math.sin(_breatheController.value * math.pi) * 3;
        final isBlinking = _blinkController.value > 0.95;

        return Transform.translate(
          offset: Offset(walkOffset, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Speech bubble
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isLightOn ? Colors.white : const Color(0xFF27272A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isLightOn
                        ? const Color(0xFF1C1917)
                        : const Color(0xFFE4E4E7),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isLightOn
                          ? const Color(0xFF1C1917).withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.4),
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  _characterSpeech,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isLightOn
                        ? const Color(0xFF1C1917)
                        : const Color(0xFFF4F4F5),
                  ),
                ),
              ),

              // The Pencil Sketch Human Character
              SizedBox(
                width: 220,
                height: height,
                child: CustomPaint(
                  painter: _PencilSketchHumanPainter(
                    breatheOffset: breathe,
                    isBlinking: isBlinking,
                    isReachingSwitch: _isReachingSwitch,
                    isCoveringEyes: _isCoveringEyes,
                    isThumbsUp: _isThumbsUp,
                    isLightOn: _isLightOn,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Animated Login Card ────────────────────────────────────────────────────
  Widget _buildAnimatedLoginCard() {
    return AnimatedBuilder(
      animation: _cardEnterController,
      builder: (context, child) {
        final scale = 0.85 + (_cardEnterController.value * 0.15);
        final opacity = _isLightOn ? _cardEnterController.value.clamp(0.0, 1.0) : 0.25;

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                color: _cardIsWhite
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF18181C),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _cardIsWhite
                      ? const Color(0xFF1C1917)
                      : const Color(0xFFE4E4E7),
                  width: 3.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _cardIsWhite
                        ? const Color(0xFF1C1917)
                        : const Color(0xFF09090B),
                    offset: const Offset(8, 9),
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(26),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildCardHeader(),
                    const SizedBox(height: 16),

                    // Quick Demo Fill Chip
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _emailCtrl.text = 'artist@sketch.studio';
                          _passCtrl.text = 'Palette#2026Master';
                          _characterSpeech = "Demo draft credentials loaded! 🚀";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _cardIsWhite
                              ? const Color(0xFFFEF08A).withValues(alpha: 0.5)
                              : const Color(0xFF27272A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _cardIsWhite
                                ? const Color(0xFF1C1917)
                                : const Color(0xFF71717A),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('✏️ '),
                            Text(
                              'Try Demo: artist@sketch.studio',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _cardIsWhite
                                    ? const Color(0xFF1C1917)
                                    : const Color(0xFFE4E4E7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildSketchTextField(
                      controller: _emailCtrl,
                      focusNode: _emailFocusNode,
                      label: 'Email Address',
                      hint: 'artist@example.com',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password Field
                    _buildSketchTextField(
                      controller: _passCtrl,
                      focusNode: _passFocusNode,
                      label: 'Password',
                      hint: 'Enter secret key',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _cardIsWhite
                              ? const Color(0xFF52525B)
                              : const Color(0xFFA1A1AA),
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Must be at least 6 chars';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: const Color(0xFF1C1917),
                                checkColor: const Color(0xFFFEF08A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color: _cardIsWhite
                                      ? const Color(0xFF1C1917)
                                      : const Color(0xFFE4E4E7),
                                  width: 1.5,
                                ),
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Keep signed in',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _cardIsWhite
                                    ? const Color(0xFF52525B)
                                    : const Color(0xFFA1A1AA),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recovery sketch link sent! 📬'),
                                backgroundColor: Color(0xFF16A34A),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              color: _cardIsWhite
                                  ? const Color(0xFF1C1917)
                                  : const Color(0xFFFEF08A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Error Message
                    if (_errorMsg != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x1AEF4444),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        child: Text(
                          _errorMsg!,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Submit Button (Hand-sketched look)
                    ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _cardIsWhite
                            ? const Color(0xFF1C1917)
                            : const Color(0xFFFDE047),
                        foregroundColor: _cardIsWhite
                            ? Colors.white
                            : const Color(0xFF18181B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        side: BorderSide(
                          color: _cardIsWhite
                              ? const Color(0xFF1C1917)
                              : const Color(0xFFFDE047),
                          width: 2,
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isLogin
                                      ? 'Sign In to Workspace'
                                      : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                    const SizedBox(height: 14),

                    // Google Login
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _googleSignIn,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: BorderSide(
                          color: _cardIsWhite
                              ? const Color(0xFF1C1917)
                              : const Color(0xFF52525B),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: _cardIsWhite
                            ? const Color(0xFFFAF8F5)
                            : const Color(0xFF222228),
                      ),
                      icon: Icon(
                        Icons.g_mobiledata_rounded,
                        size: 24,
                        color: _cardIsWhite
                            ? const Color(0xFF1C1917)
                            : Colors.white,
                      ),
                      label: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: _cardIsWhite
                              ? const Color(0xFF1C1917)
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Register Switch
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _errorMsg = null;
                            _characterSpeech = _isLogin
                                ? "Welcome back! 🎨"
                                : "Let's create a new sketchbook! 📖";
                          });
                        },
                        child: Text(
                          _isLogin
                              ? "Don't have an account? Create one"
                              : "Already have a sketch book? Sign In",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            color: _cardIsWhite
                                ? const Color(0xFF52525B)
                                : const Color(0xFFA1A1AA),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _cardIsWhite
                ? const Color(0xFFFEF3C7)
                : const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _cardIsWhite
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF71717A),
            ),
          ),
          child: Text(
            'HANDCRAFTED ATELIER',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: _cardIsWhite
                  ? const Color(0xFF92400E)
                  : const Color(0xFFFDE68A),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _isLogin ? 'Welcome Back' : 'Create Account',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: _cardIsWhite ? const Color(0xFF1C1917) : Colors.white,
          ),
        ),
        Text(
          'Sign in to your creative study timetable',
          style: TextStyle(
            fontSize: 12,
            color: _cardIsWhite
                ? const Color(0xFF71717A)
                : const Color(0xFFA1A1AA),
          ),
        ),
      ],
    );
  }

  Widget _buildSketchTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: _cardIsWhite ? const Color(0xFF1C1917) : Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            color: _cardIsWhite ? const Color(0xFF1C1917) : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: _cardIsWhite
                  ? const Color(0xFFA1A1AA)
                  : const Color(0xFF71717A),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: _cardIsWhite
                  ? const Color(0xFF52525B)
                  : const Color(0xFFA1A1AA),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: _cardIsWhite
                ? const Color(0xFFFAF8F5)
                : const Color(0xFF222228),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _cardIsWhite
                    ? const Color(0xFF1C1917)
                    : const Color(0xFF52525B),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _cardIsWhite
                    ? const Color(0xFF1C1917)
                    : const Color(0xFF52525B),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _cardIsWhite
                    ? const Color(0xFF1C1917)
                    : const Color(0xFFFDE047),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2.5),
            ),
            errorStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PENCIL PAPER BACKGROUND PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _PencilPaperPainter extends CustomPainter {
  final bool isLightOn;
  const _PencilPaperPainter({required this.isLightOn});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isLightOn
          ? const Color(0xFF1C1917).withValues(alpha: 0.04)
          : Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PencilPaperPainter oldDelegate) =>
      oldDelegate.isLightOn != isLightOn;
}

// ─────────────────────────────────────────────────────────────────────────────
//  HUMAN PENCIL SKETCH CUSTOM PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _PencilSketchHumanPainter extends CustomPainter {
  final double breatheOffset;
  final bool isBlinking;
  final bool isReachingSwitch;
  final bool isCoveringEyes;
  final bool isThumbsUp;
  final bool isLightOn;

  const _PencilSketchHumanPainter({
    required this.breatheOffset,
    required this.isBlinking,
    required this.isReachingSwitch,
    required this.isCoveringEyes,
    required this.isThumbsUp,
    required this.isLightOn,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / 420;
    canvas.save();
    canvas.scale(scale, scale);

    final inkColor = const Color(0xFF1C1917);
    final paperFill = const Color(0xFFFFF9F0);

    final linePaint = Paint()
      ..color = inkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = paperFill
      ..style = PaintingStyle.fill;

    final darkFill = Paint()
      ..color = inkColor
      ..style = PaintingStyle.fill;

    // Floor Shadow
    canvas.drawOval(
      const Rect.fromLTWH(40, 400, 140, 16),
      Paint()
        ..color = inkColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );

    // Legs & Shoes
    canvas.drawLine(const Offset(90, 260), const Offset(85, 395), linePaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(65, 395, 32, 14),
        const Radius.circular(6),
      ),
      darkFill,
    );

    canvas.drawLine(const Offset(130, 260), const Offset(135, 395), linePaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(125, 395, 32, 14),
        const Radius.circular(6),
      ),
      darkFill,
    );

    // Torso / Jacket
    final torsoPath = Path()
      ..moveTo(75, 140)
      ..quadraticBezierTo(65, 200, 70, 265)
      ..quadraticBezierTo(110, 275, 150, 265)
      ..quadraticBezierTo(155, 200, 145, 140)
      ..close();
    canvas.drawPath(torsoPath, fillPaint);
    canvas.drawPath(torsoPath, linePaint);

    // Lapels & Buttons
    canvas.drawLine(const Offset(90, 140), const Offset(110, 180), linePaint);
    canvas.drawLine(const Offset(130, 140), const Offset(110, 180), linePaint);
    canvas.drawLine(const Offset(110, 180), const Offset(110, 265), linePaint..strokeWidth = 2);

    canvas.drawCircle(const Offset(110, 200), 2.5, darkFill);
    canvas.drawCircle(const Offset(110, 225), 2.5, darkFill);
    canvas.drawCircle(const Offset(110, 250), 2.5, darkFill);

    // Head & Neck (Affected by breath)
    final headY = 90 + breatheOffset;

    // Neck
    canvas.drawLine(Offset(100, headY + 38), Offset(100, 145), linePaint..strokeWidth = 3);
    canvas.drawLine(Offset(120, headY + 38), Offset(120, 145), linePaint..strokeWidth = 3);

    // Head Base
    canvas.drawOval(
      Rect.fromCenter(center: Offset(110, headY), width: 68, height: 78),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(110, headY), width: 68, height: 78),
      linePaint..strokeWidth = 3.5,
    );

    // Hair
    final hairPath = Path()
      ..moveTo(76, headY - 5)
      ..quadraticBezierTo(74, headY - 42, 110, headY - 45)
      ..quadraticBezierTo(146, headY - 42, 144, headY - 5)
      ..quadraticBezierTo(130, headY - 25, 110, headY - 20)
      ..quadraticBezierTo(90, headY - 25, 76, headY - 5)
      ..close();
    canvas.drawPath(hairPath, darkFill);
    canvas.drawPath(hairPath, linePaint..strokeWidth = 2);

    // Ears
    canvas.drawArc(
      Rect.fromCenter(center: Offset(76, headY + 5), width: 10, height: 16),
      -1.5,
      3.0,
      false,
      linePaint..strokeWidth = 2.5,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(144, headY + 5), width: 10, height: 16),
      1.5,
      3.0,
      false,
      linePaint..strokeWidth = 2.5,
    );

    // Eyebrows
    canvas.drawLine(Offset(90, headY - 12), Offset(102, headY - 10), linePaint..strokeWidth = 2.5);
    canvas.drawLine(Offset(118, headY - 10), Offset(130, headY - 12), linePaint..strokeWidth = 2.5);

    // Eyes (or Glasses)
    if (!isBlinking) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(86, headY - 8, 20, 18),
          const Radius.circular(5),
        ),
        linePaint..strokeWidth = 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(114, headY - 8, 20, 18),
          const Radius.circular(5),
        ),
        linePaint..strokeWidth = 2,
      );
      canvas.drawLine(Offset(106, headY + 1), Offset(114, headY + 1), linePaint..strokeWidth = 2);

      // Pupils
      canvas.drawCircle(Offset(96, headY + 1), 3.5, darkFill);
      canvas.drawCircle(Offset(124, headY + 1), 3.5, darkFill);
    } else {
      // Blinking lines
      canvas.drawLine(Offset(88, headY + 1), Offset(104, headY + 1), linePaint..strokeWidth = 2.5);
      canvas.drawLine(Offset(116, headY + 1), Offset(132, headY + 1), linePaint..strokeWidth = 2.5);
    }

    // Nose
    canvas.drawLine(Offset(110, headY), Offset(107, headY + 12), linePaint..strokeWidth = 2);
    canvas.drawLine(Offset(107, headY + 12), Offset(113, headY + 12), linePaint..strokeWidth = 2);

    // Mouth
    final mouthPath = Path();
    if (isThumbsUp) {
      mouthPath.moveTo(98, headY + 22);
      mouthPath.quadraticBezierTo(110, headY + 34, 122, headY + 22);
    } else {
      mouthPath.moveTo(100, headY + 24);
      mouthPath.quadraticBezierTo(110, headY + 30, 120, headY + 24);
    }
    canvas.drawPath(mouthPath, linePaint..strokeWidth = 2.5);

    // Cheeks blush
    final blushPaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.4)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(82, headY + 14), Offset(88, headY + 9), blushPaint);
    canvas.drawLine(Offset(86, headY + 16), Offset(92, headY + 11), blushPaint);
    canvas.drawLine(Offset(128, headY + 11), Offset(134, headY + 16), blushPaint);
    canvas.drawLine(Offset(132, headY + 9), Offset(138, headY + 14), blushPaint);

    // ── ARMS & HAND INTERACTIONS ──
    if (isCoveringEyes) {
      // Both hands covering eyes!
      final handLeft = Path()
        ..moveTo(70, 150)
        ..quadraticBezierTo(75, 100, 96, headY)
        ..lineTo(106, headY + 4)
        ..quadraticBezierTo(80, 120, 75, 160)
        ..close();
      canvas.drawPath(handLeft, fillPaint);
      canvas.drawPath(handLeft, linePaint..strokeWidth = 3);

      final handRight = Path()
        ..moveTo(150, 150)
        ..quadraticBezierTo(145, 100, 124, headY)
        ..lineTo(114, headY + 4)
        ..quadraticBezierTo(140, 120, 145, 160)
        ..close();
      canvas.drawPath(handRight, fillPaint);
      canvas.drawPath(handRight, linePaint..strokeWidth = 3);
    } else if (isReachingSwitch) {
      // Left arm stretched up high reaching switch!
      final reachArm = Path()
        ..moveTo(75, 150)
        ..quadraticBezierTo(40, 70, 10, 10)
        ..lineTo(18, 5)
        ..quadraticBezierTo(50, 80, 80, 160)
        ..close();
      canvas.drawPath(reachArm, fillPaint);
      canvas.drawPath(reachArm, linePaint..strokeWidth = 3.5);

      // Pointing finger
      canvas.drawLine(const Offset(10, 10), const Offset(-5, -5), linePaint..strokeWidth = 3.5);

      // Right arm resting
      canvas.drawLine(const Offset(145, 150), const Offset(165, 235), linePaint..strokeWidth = 3.5);
    } else if (isThumbsUp) {
      // Left arm resting
      canvas.drawLine(const Offset(75, 150), const Offset(55, 235), linePaint..strokeWidth = 3.5);

      // Right arm thumbs up!
      final thumbsArm = Path()
        ..moveTo(145, 150)
        ..quadraticBezierTo(170, 190, 175, 210);
      canvas.drawPath(thumbsArm, linePaint..strokeWidth = 3.5);

      // Thumb
      canvas.drawLine(const Offset(175, 210), const Offset(175, 190), linePaint..strokeWidth = 4);
    } else {
      // Normal idle arms
      canvas.drawLine(const Offset(75, 150), const Offset(55, 235), linePaint..strokeWidth = 3.5);
      canvas.drawLine(const Offset(145, 150), const Offset(165, 235), linePaint..strokeWidth = 3.5);
    }

    // Yellow pencil in pocket
    canvas.save();
    canvas.translate(140, 210);
    canvas.rotate(0.3);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 5, 26),
      Paint()..color = const Color(0xFFF59E0B),
    );
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 5, 6),
      Paint()..color = const Color(0xFFF43F5E),
    );
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PencilSketchHumanPainter oldDelegate) {
    return oldDelegate.breatheOffset != breatheOffset ||
        oldDelegate.isBlinking != isBlinking ||
        oldDelegate.isReachingSwitch != isReachingSwitch ||
        oldDelegate.isCoveringEyes != isCoveringEyes ||
        oldDelegate.isThumbsUp != isThumbsUp ||
        oldDelegate.isLightOn != isLightOn;
  }
}
