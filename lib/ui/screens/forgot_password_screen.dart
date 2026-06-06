import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../components/core/button.dart';
import '../components/core/logo_circle.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
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
                const Positioned(top: 60, left: 0, right: 0, child: LogoCircle(size: 80)),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight),
                    onPressed: () => context.pop(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "نسيت كلمة المرور؟",
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSuccess 
                      ? "تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني بنجاح."
                      : "أدخل بريدك الإلكتروني وسنرسل لك رابطاً لاستعادة كلمة المرور.",
                    style: const TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  if (!_isSuccess) ...[
                    _buildTextField("البريد الإلكتروني", _emailController, Icons.email_outlined),
                    const SizedBox(height: 32),
                    BonnButton(
                      text: "إرسال الرابط",
                      onPressed: () => setState(() => _isSuccess = true),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    BonnButton(
                      text: "العودة لتسجيل الدخول",
                      onPressed: () => context.pop(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
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
}
