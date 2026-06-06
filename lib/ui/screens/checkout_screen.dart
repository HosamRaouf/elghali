import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/breakpoints.dart';
import '../../data/coffee_data.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../components/core/logo_circle.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _step = 0;
  String? _paymentMethod;
  bool _ordered = false;
  bool _loading = false;
  int _deliveryType = 0; // 0 = delivery, 1 = pickup

  // Payment State
  String _vodafoneNumber = "";

  // Card Info State
  String _cardNumber = "";
  String _cardHolder = "";
  String _expiryDate = "";
  String _cvv = "";

  final _steps = ["معلومات التوصيل", "طريقة الدفع", "تأكيد الطلب"];

  void _handleNext() async {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _ordered = true;
      });
      ref.read(cartProvider.notifier).clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ordered) return _buildSuccessScreen(context);

    final cartState = ref.watch(cartProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = getDeviceType(constraints.maxWidth) == DeviceType.desktop;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_step > 0) {
                                setState(() => _step--);
                              } else {
                                context.pop();
                              }
                            },
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _steps[_step],
                            style: AppTypography.elMessiri.copyWith(
                              fontSize: 24,
                              color: AppColors.textLight,
                            ),
                          ),
                          const Spacer(),
                          const LogoCircle(size: 44),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Step Indicators
                      Row(
                        children: List.generate(_steps.length, (i) {
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: i < _steps.length - 1 ? 8 : 0,
                              ),
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: i <= _step
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFFB5682A),
                                        ],
                                      )
                                    : null,
                                color: i <= _step
                                    ? null
                                    : Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: isDesktop
                  ? _buildDesktopContent(cartState)
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStep(cartState),
                ),
              ),
            ),

            // CTA (mobile only)
            if (!isDesktop)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ElevatedButton(
                onPressed: _loading ? null : _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: AppTypography.cairo.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  disabledBackgroundColor: AppColors.primary,
                ),
                child: _loading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.background,
                                  shape: BoxShape.circle,
                                ),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveY(
                                begin: -4,
                                end: 4,
                                duration: 600.ms,
                                delay: (i * 150).ms,
                              );
                        }),
                      )
                    : Text(
                        _step < _steps.length - 1 ? "التالي" : "تأكيد الطلب",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildDesktopContent(CartState cartState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStep(cartState),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ملخص الطلب", style: TextStyle(color: AppColors.textLight, fontSize: 18)),
                      const SizedBox(height: 12),
                      ...cartState.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item.product.name} × ${toArabicNum(item.quantity)}",
                              style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 13)),
                            Text("${toArabicNum(item.totalPrice)} ج.م",
                              style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 13)),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: AppColors.primary.withValues(alpha: 0.15), height: 1),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text("التوصيل", style: AppTypography.cairo.copyWith(color: AppColors.secondary, fontSize: 14)),
                        Text("${toArabicNum(cartState.deliveryFee)} ج.م",
                          style: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 14)),
                      ]),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text("الإجمالي", style: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 18)),
                        Text("${toArabicNum(cartState.total)} ج.م",
                          style: AppTypography.cairo.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _handleNext,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: AppColors.primary, foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: AppTypography.cairo.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                          elevation: 8, shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          disabledBackgroundColor: AppColors.primary,
                        ),
                        child: _loading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (i) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                                ).animate(onPlay: (c) => c.repeat(reverse: true))
                                  .moveY(begin: -4, end: 4, duration: 600.ms, delay: (i * 150).ms)),
                              )
                            : Text(_step < _steps.length - 1 ? "التالي" : "تأكيد الطلب"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(CartState cartState) {
    if (_step == 0) {
      return SizedBox(
        key: const ValueKey(0),
        child: _buildStep1(),
      ).animate().fadeIn().slideX(begin: 0.2, end: 0, duration: 300.ms);
    } else if (_step == 1) {
      return SizedBox(
        key: const ValueKey(1),
        child: _buildStep2(),
      ).animate().fadeIn().slideX(begin: 0.2, end: 0, duration: 300.ms);
    } else {
      return SizedBox(
        key: const ValueKey(2),
        child: _buildStep3(cartState),
      ).animate().fadeIn().slideX(begin: 0.2, end: 0, duration: 300.ms);
    }
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDeliveryType(0, "توصيل"),
              const SizedBox(width: 12),
              _buildDeliveryType(1, "استلام من الفرع"),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "عنوان التوصيل",
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField("الاسم الكامل", "أدخل اسمك"),
          _buildTextField(
            "رقم الجوال",
            "01X XXXX XXXX",
            keyboardType: TextInputType.phone,
          ),
          _buildTextField("المدينة", "المنصورة"),
          _buildTextField("الحي والشارع", "اكتب عنوانك بالتفصيل"),
        ],
      ),
    );
  }

  Widget _buildDeliveryType(int type, String label) {
    final isSelected = _deliveryType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _deliveryType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      const Color(0xFFB5682A).withValues(alpha: 0.1),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.cairo.copyWith(
                color: isSelected ? AppColors.primary : AppColors.secondary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String placeholder, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.cairo.copyWith(
              color: AppColors.secondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: keyboardType,
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTypography.cairo.copyWith(
                color: AppColors.textLight.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final methods = [
      {'id': 'card', 'label': 'بطاقة بنكية', 'icon': Icons.credit_card},
      {
        'id': 'vodafone',
        'label': 'فودافون كاش',
        'icon': Icons.account_balance_wallet,
      },
      {'id': 'cash', 'label': 'الدفع عند الاستلام', 'icon': Icons.money},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_paymentMethod == 'card') ...[
            const SizedBox(height: 16),
            _buildBankCardUI(),
            const SizedBox(height: 24),
            _buildCardInputFields(),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 24),
          ],
          if (_paymentMethod == 'vodafone') ...[
            const SizedBox(height: 16),
            _buildVodafoneCashFields(),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 16),
          Text(
            "اختر طريقة الدفع",
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...methods.map((method) {
            final isSelected = _paymentMethod == method['id'];
            return GestureDetector(
              onTap: () =>
                  setState(() => _paymentMethod = method['id'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.03),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.06),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        method['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        method['label'] as String,
                        style: AppTypography.cairo.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textLight,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.background,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBankCardUI() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF8B5E3C), Color(0xFF4A2C18)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: _CardPatternPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "بنك",
                      style: AppTypography.elMessiri.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.contactless,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _cardNumber.isEmpty ? "•••• •••• •••• ••••" : _cardNumber,
                  style: AppTypography.cairo.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "حامل البطاقة",
                          style: AppTypography.cairo.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          _cardHolder.isEmpty ? "الاسم بالكامل" : _cardHolder,
                          style: AppTypography.cairo.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تنتهي في",
                          style: AppTypography.cairo.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          _expiryDate.isEmpty ? "MM/YY" : _expiryDate,
                          style: AppTypography.cairo.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn();
  }

  Widget _buildVodafoneCashFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCreditCardField(
          "رقم فودافون كاش",
          "010 XXXX XXXX",
          onChanged: (v) => setState(() => _vodafoneNumber = v),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "سيتم توجيهك لتطبيق أنا فودافون أو إدخال رمز التحقق لإتمام الدفع",
                  style: AppTypography.cairo.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildCardInputFields() {
    return Column(
      children: [
        _buildCreditCardField(
          "رقم البطاقة",
          "0000 0000 0000 0000",
          onChanged: (v) => setState(() => _cardNumber = v),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
        ),
        _buildCreditCardField(
          "اسم صاحب البطاقة",
          "HOSAM ABDELRAOUF",
          onChanged: (v) => setState(() => _cardHolder = v.toUpperCase()),
          textCapitalization: TextCapitalization.characters,
        ),
        Row(
          children: [
            Expanded(
              child: _buildCreditCardField(
                "تاريخ الانتهاء",
                "MM/YY",
                onChanged: (v) => setState(() => _expiryDate = v),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCreditCardField(
                "رمز CVV",
                "123",
                onChanged: (v) => setState(() => _cvv = v),
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreditCardField(
    String label,
    String hint, {
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.cairo.copyWith(
              color: AppColors.secondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            style: AppTypography.cairo.copyWith(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.cairo.copyWith(
                color: AppColors.textLight.withValues(alpha: 0.2),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(CartState cartState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مراجعة الطلب",
                  style: AppTypography.elMessiri.copyWith(
                    color: AppColors.textLight,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                ...cartState.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item.product.name} × ${toArabicNum(item.quantity)}",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.secondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${toArabicNum(item.totalPrice)} ج.م",
                          style: AppTypography.cairo.copyWith(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "التوصيل",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${toArabicNum(cartState.deliveryFee)} ج.م",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الإجمالي",
                      style: AppTypography.elMessiri.copyWith(
                        color: AppColors.textLight,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${toArabicNum(cartState.total)} ج.م",
                      style: AppTypography.cairo.copyWith(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "بالضغط على تأكيد الطلب، أنت توافق على شروط الخدمة",
            style: AppTypography.tajawal.copyWith(
              color: AppColors.secondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.2),
                                  const Color(
                                    0xFFB5682A,
                                  ).withValues(alpha: 0.15),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: AppColors.primary,
                                size: 48,
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.08, 1.08),
                            duration: 2.seconds,
                          ),
                      const SizedBox(height: 24),
                      Text(
                        "تم الطلب بنجاح!",
                        style: AppTypography.elMessiri.copyWith(
                          fontSize: 30,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "طلبك قيد التحضير... قهوتك في الطريق إليك\nالوقت المتوقع: ٢٠ - ٣٠ دقيقة",
                        textAlign: TextAlign.center,
                        style: AppTypography.tajawal.copyWith(
                          color: AppColors.secondary,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "رقم الطلب",
                              style: AppTypography.cairo.copyWith(
                                color: AppColors.secondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "#BNG-${toArabicNum(1234)}", // Using a static random for now
                              style: AppTypography.cairo.copyWith(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: AppTypography.cairo.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text("العودة للرئيسية"),
                      ),
                    ],
                  ).animate().fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 10; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2),
        i * 20.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonSpaceLength = i + 1;
      if (nonSpaceLength % 4 == 0 && nonSpaceLength != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonSlashLength = i + 1;
      if (nonSlashLength == 2 && nonSlashLength != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
