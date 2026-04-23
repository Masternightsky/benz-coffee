import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Welcome screen – entry point for the customer.
/// Shows brand logo, name, tagline, and service type selection.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Currently selected service type
  String _selectedServiceType = 'Dine-In'; // 'Dine-In' or 'Take-Out'
  bool _showOrderOptions = false; // Toggles to second screen

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _pulseController;

  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _buttonFade;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Logo fade-in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    // Text slide-up + fade
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    // Button fade-in
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOut,
    );

    // Pulse effect on coffee icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Stagger the animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onStartOrdering() {
    HapticFeedback.mediumImpact();
    setState(() => _showOrderOptions = true);
  }

  void _onSelectServiceType(String type) {
    HapticFeedback.selectionClick();
    setState(() => _selectedServiceType = type);
  }

  void _onProceed(BuildContext context) {
    HapticFeedback.heavyImpact();
    // Navigate to the main app shell (home screen)
    Navigator.of(context).pushReplacementNamed(
      '/home',
      arguments: _selectedServiceType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B5043), // Warm espresso
              Color(0xFF5C3D2E), // Deep brown
              Color(0xFF3B2219), // Dark roast
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _showOrderOptions
                ? _buildOrderOptionsScreen(context)
                : _buildWelcomeContent(context),
          ),
        ),
      ),
    );
  }

  // ── Screen 1: Brand Welcome ──────────────────────────────────────

  Widget _buildWelcomeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Coffee cup logo with pulse animation
          // The complete animated logo section
        FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(
            scale: _pulse,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_cafe_rounded,
                      color: Colors.white,
                      size: 60,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
          const SizedBox(height: 28),
          // Brand name + tagline
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  Text(
                    'benz coffee',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your cup of inspiration...',
                    style: GoogleFonts.dancingScript(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 2),
          // Start Ordering button
          FadeTransition(
            opacity: _buttonFade,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: AppTheme.buttonShadow,
              ),
              child: ElevatedButton(
                onPressed: _onStartOrdering,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start Ordering',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  // ── Screen 2: Dine-In / Take-Out Selection ───────────────────────

  Widget _buildOrderOptionsScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
            'Welcome',
            style: GoogleFonts.nunitoSans(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'How would you like to order?',
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const Spacer(flex: 1),
          // Dine-In button
          _ServiceTypeButton(
            label: 'Dine-In',
            icon: Icons.restaurant_rounded,
            isSelected: _selectedServiceType == 'Dine-In',
            onTap: () => _onSelectServiceType('Dine-In'),
          ),
          const SizedBox(height: 16),
          // Take-Out button
          _ServiceTypeButton(
            label: 'Take-Out',
            icon: Icons.takeout_dining_rounded,
            isSelected: _selectedServiceType == 'Take-Out',
            onTap: () => _onSelectServiceType('Take-Out'),
          ),
          const Spacer(flex: 1),
          // Proceed button
          ElevatedButton(
            onPressed: () => _onProceed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryDark,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Continue',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _showOrderOptions = false),
            child: Text(
              'Back',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

/// Toggle button for Dine-In / Take-Out selection
class _ServiceTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentLight
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accentLight : Colors.white70,
              size: 26,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.accentLight,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
