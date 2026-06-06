import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../components/core/button.dart';
import '../components/core/logo_circle.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _loading = true);
    await ref.read(authProvider.notifier).loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );
    if (mounted) {
      setState(() => _loading = false);
      context.push('/phone-input');
    }
  }

  void _handleSocialLogin(String provider) async {
    setState(() => _loading = true);
    await ref.read(authProvider.notifier).loginWithSocial(provider);
    if (mounted) {
      setState(() => _loading = false);
      context.push('/phone-input');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Logo
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x660D0500), Color(0xFA0D0500)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(top: 80, left: 0, right: 0, child: LogoCircle(size: 100)),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مرحباً بك مجدداً",
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "سجّل دخولك للاستمتاع بأفضل أنواع القهوة",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Email/Password Fields
                  _buildTextField("البريد الإلكتروني", _emailController, Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildTextField("كلمة المرور", _passwordController, Icons.lock_outline, isPassword: true),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(color: AppColors.secondary, fontSize: 13),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  BonnButton(
                    text: _loading ? "جارٍ تسجيل الدخول..." : "تسجيل الدخول",
                    onPressed: _loading ? null : _handleLogin,
                    isLoading: _loading,
                  ),

                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),

                  // Social Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          "Google",
                          'assets/icons/google.png', // Assuming asset exists
                          () => _handleSocialLogin("Google"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSocialButton(
                          "Apple",
                          Icons.apple,
                          () => _handleSocialLogin("Apple"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // Register Link
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("ليس لديك حساب؟ ", style: TextStyle(color: AppColors.secondary)),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: const Text(
                            "أنشئ حساباً الآن",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text(
                        "تصفح كضيف",
                        style: TextStyle(color: AppColors.secondary, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.5)),
          border: InputBorder.none,
          icon: Icon(icon, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.secondary.withValues(alpha: 0.2))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("أو عبر", style: TextStyle(color: AppColors.secondary, fontSize: 12)),
        ),
        Expanded(child: Divider(color: AppColors.secondary.withValues(alpha: 0.2))),
      ],
    );
  }

  Widget _buildSocialButton(String label, dynamic icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon is IconData)
              Icon(icon, color: AppColors.textLight, size: 24)
            else
              const Icon(Icons.g_mobiledata, color: AppColors.textLight, size: 32), // Placeholder for Google
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
