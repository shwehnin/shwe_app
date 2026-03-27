import 'package:flutter/material.dart';
import 'package:new_lion/utils/const.dart';
import 'package:new_lion/utils/extension.dart';
import 'package:new_lion/utils/images.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import '../../data/api/login_api.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _signin() async {
    EasyOverlay.show();
    await LoginApi.google();
    EasyOverlay.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return _DiagonalSplitLogin(onSignin: _signin);
  }
}

// ── Main Layout ───────────────────────────────────────────────────────────────

class _DiagonalSplitLogin extends StatelessWidget {
  final VoidCallback onSignin;
  const _DiagonalSplitLogin({required this.onSignin});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Diagonal dark background ──
          ClipPath(
            clipper: _DiagonalClipper(),
            child: Container(
              width: double.infinity,
              height: size.height * 0.62,
              color: const Color(0xFF0F172A),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                // Top brand section
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: size.height * 0.28,
                  child: const _BrandSection(),
                ),

                // Floating card
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: _LoginCard(onSignin: onSignin),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Diagonal Clipper ──────────────────────────────────────────────────────────

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);
    path.lineTo(size.width, size.height * 0.65);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_DiagonalClipper old) => false;
}

// ── Brand Section ─────────────────────────────────────────────────────────────

class _BrandSection extends StatelessWidget {
  const _BrandSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Image.asset(
              Imgs.logo,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          Const.appName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          '2D/3D Realtime Application',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

// ── Login Card ────────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final VoidCallback onSignin;
  const _LoginCard({required this.onSignin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 450),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sign in to continue',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Use your Google account to get started',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),

            const SizedBox(height: 22),

            // Google button
            _GoogleBtn(onTap: onSignin),

            const SizedBox(height: 18),

            // Terms
            const _Terms(),
          ],
        ),
      ),
    );
  }
}

// ── Google Button ─────────────────────────────────────────────────────────────

class _GoogleBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Terms ─────────────────────────────────────────────────────────────────────

class _Terms extends StatelessWidget {
  const _Terms();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, height: 1.6, color: Colors.grey),
    );
  }
}
