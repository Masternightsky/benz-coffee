import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

/// PIN Login Screen with custom numeric keypad for touchscreen kiosks
/// Default PIN: 1234 (hardcoded for now)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _enteredPin = '';
  final String _correctPin = '123456';
  String _errorMessage = '';
  bool _isLoading = false;

  // Maximum PIN length (4-6 digits)
  static const int _maxPinLength = 6;
  static const int _minPinLength = 4;

  void _addDigit(String digit) {
    if (_enteredPin.length < _maxPinLength) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = '';
      });
      HapticFeedback.lightImpact();
    }
  }

  void _removeDigit() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      });
      HapticFeedback.lightImpact();
    }
  }

  void _clearPin() {
    setState(() {
      _enteredPin = '';
      _errorMessage = '';
    });
    HapticFeedback.mediumImpact();
  }

  void _validateAndLogin() async {
    if (_enteredPin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your PIN';
      });
      HapticFeedback.heavyImpact();
      return;
    }

    if (_enteredPin.length < _minPinLength) {
      setState(() {
        _errorMessage = 'PIN must be $_minPinLength-$_maxPinLength digits';
      });
      HapticFeedback.heavyImpact();
      return;
    }

    if (_enteredPin == _correctPin) {
      setState(() {
        _isLoading = true;
      });

      HapticFeedback.heavyImpact();

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid PIN. Please try again.';
        _enteredPin = '';
      });
      HapticFeedback.heavyImpact();
    }
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
              Color(0xFF7B5043),
              Color(0xFF5C3D2E),
              Color(0xFF3B2219),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coffee cup icon - smaller
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.coffee_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title - smaller
                  Text(
                    'Staff Access',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle - smaller
                  Text(
                    'Enter your PIN to continue',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // PIN Display Circles - smaller
                  _buildPinDisplay(),

                  const SizedBox(height: 20),

                  // Error message
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.lato(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Custom Numeric Keypad - smaller buttons
                  _buildNumericKeypad(),

                  const SizedBox(height: 12),

                  // Hint for default PIN - smaller
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Default PIN: 123456',
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Loading indicator
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.accentLight,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// PIN display with circles
  /// PIN display with circles - COMPACT VERSION
Widget _buildPinDisplay() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min, // This makes it shrink to fit content
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxPinLength, (index) {
        final bool isFilled = index < _enteredPin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? AppTheme.accentLight
                : Colors.white.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: isFilled
              ? const Icon(
                  Icons.circle_rounded,
                  size: 6,
                  color: Colors.white,
                )
              : null,
        );
      }),
    ),
  );
}

  /// Custom numeric keypad - smaller buttons
  Widget _buildNumericKeypad() {
    return Column(
      children: [
        // Row 1: 1 2 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _KeypadButton(digit: '1', onPressed: () => _addDigit('1')),
            _KeypadButton(digit: '2', onPressed: () => _addDigit('2')),
            _KeypadButton(digit: '3', onPressed: () => _addDigit('3')),
          ],
        ),
        const SizedBox(height: 8),
        // Row 2: 4 5 6
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _KeypadButton(digit: '4', onPressed: () => _addDigit('4')),
            _KeypadButton(digit: '5', onPressed: () => _addDigit('5')),
            _KeypadButton(digit: '6', onPressed: () => _addDigit('6')),
          ],
        ),
        const SizedBox(height: 8),
        // Row 3: 7 8 9
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _KeypadButton(digit: '7', onPressed: () => _addDigit('7')),
            _KeypadButton(digit: '8', onPressed: () => _addDigit('8')),
            _KeypadButton(digit: '9', onPressed: () => _addDigit('9')),
          ],
        ),
        const SizedBox(height: 8),
        // Row 4: Clear 0 Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _KeypadButton(
              icon: Icons.backspace_rounded,
              label: 'DEL',
              isSpecial: true,
              onPressed: _removeDigit,
            ),
            _KeypadButton(digit: '0', onPressed: () => _addDigit('0')),
            _KeypadButton(
              icon: Icons.clear_rounded,
              label: 'CLEAR',
              isSpecial: true,
              onPressed: _clearPin,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Enter button - smaller
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _validateAndLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'LOGIN',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual keypad button widget - smaller
class _KeypadButton extends StatelessWidget {
  final String? digit;
  final IconData? icon;
  final String? label;
  final bool isSpecial;
  final VoidCallback onPressed;

  const _KeypadButton({
    this.digit,
    this.icon,
    this.label,
    this.isSpecial = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 65,
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSpecial
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: digit != null
              ? Text(
                  digit!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSpecial ? AppTheme.accentLight : Colors.white,
                      size: 22,
                    ),
                    if (label != null)
                      Text(
                        label!,
                        style: GoogleFonts.lato(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: isSpecial
                              ? AppTheme.accentLight
                              : Colors.white70,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}