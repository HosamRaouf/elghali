import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../components/core/button.dart';
import '../components/core/logo_circle.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (_phoneController.text.isEmpty) return;
    
    setState(() => _loading = true);
    await ref.read(authProvider.notifier).requestOTP(_phoneController.text);
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "أكمل تسجيل الدخول",
                    style: AppTypography.elMessiri.copyWith(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "يرجى إدخال رقم هاتفك لتفعيل حسابك عبر رسالة نصية",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                  const SizedBox(height: 48),
                  _buildPhoneField(),
                  const SizedBox(height: 48),
                  BonnButton(
                    text: _loading ? "جارٍ الإرسال..." : "إرسال كود التفعيل",
                    onPressed: _loading ? null : _handleNext,
                    isLoading: _loading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            "+20",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.secondary.withValues(alpha: 0.2)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.textLight, fontSize: 18),
              decoration: InputDecoration(
                hintText: "123 456 7890",
                hintStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
