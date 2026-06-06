import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../components/core/button.dart';
import '../components/core/logo_circle.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    setState(() => _loading = true);
    await ref.read(authProvider.notifier).register(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
    );
    if (mounted) {
      setState(() => _loading = false);
      context.push('/otp');
    }
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
                    "إنشاء حساب جديد",
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "انضم لعائلة بن الغالي واستمتع بمزايا حصرية",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField("الاسم الكامل", _nameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField("البريد الإلكتروني", _emailController, Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildTextField("رقم الهاتف", _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField("كلمة المرور", _passwordController, Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 32),
                  BonnButton(
                    text: _loading ? "جارٍ الإنشاء..." : "إنشاء الحساب",
                    onPressed: _loading ? null : _handleRegister,
                    isLoading: _loading,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("لديك حساب بالفعل؟ ", style: TextStyle(color: AppColors.secondary)),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Text(
                            "تسجيل الدخول",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
        keyboardType: keyboardType,
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
