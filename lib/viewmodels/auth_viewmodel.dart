import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user/user.dart';
import '../models/user/user_data.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isVerifyingPhone;
  final User? user;
  final String? tempPhone;

  const AuthState({
    this.isAuthenticated = false,
    this.isVerifyingPhone = false,
    this.user,
    this.tempPhone,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isVerifyingPhone,
    User? user,
    String? tempPhone,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isVerifyingPhone: isVerifyingPhone ?? this.isVerifyingPhone,
      user: user ?? this.user,
      tempPhone: tempPhone ?? this.tempPhone,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, we'd check credentials here
    state = state.copyWith(isVerifyingPhone: false); 
  }

  Future<void> loginWithSocial(String provider) async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isVerifyingPhone: false);
  }

  Future<void> register(String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isVerifyingPhone: false, tempPhone: phone);
  }

  Future<void> requestOTP(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(tempPhone: phone, isVerifyingPhone: true);
  }

  Future<void> verifyOTP(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock successful verification
    state = state.copyWith(
      isAuthenticated: true,
      isVerifyingPhone: false,
      user: mockUser.copyWith(phone: state.tempPhone ?? mockUser.phone),
    );
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});

extension UserExtension on User {
  User copyWith({String? id, String? name, String? phone, int? points}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      points: points ?? this.points,
    );
  }
}
