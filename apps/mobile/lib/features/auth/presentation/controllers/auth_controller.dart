import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/features/auth/data/firebase_auth_service.dart';
import 'package:shilpsetu/features/auth/domain/models/artisan_user.dart';

/// State of the artisan authentication and registration session.
class AuthState {
  const AuthState({
    required this.isLoading,
    this.currentUser,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  factory AuthState.initial() => const AuthState(isLoading: false);

  final bool isLoading;
  final ArtisanUser? currentUser;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState copyWith({
    bool? isLoading,
    ArtisanUser? currentUser,
    String? errorMessage,
    bool? isAuthenticated,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({FirebaseAuthService? firebaseAuthService})
      : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
        super(AuthState.initial());

  final FirebaseAuthService _firebaseAuthService;

  /// Validates Indian 10-digit mobile number.
  bool isValidPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    return cleaned.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned);
  }

  /// Validates artisan name (minimum 2 characters).
  bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  /// Registers a new artisan with Name and Phone number and saves to Firebase Cloud Firestore.
  Future<bool> register({
    required String name,
    required String phoneNumber,
    String? craftType,
    String? location,
  }) async {
    final trimmedName = name.trim();
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (!isValidName(trimmedName)) {
      state = state.copyWith(
        errorMessage: 'कृपया सही नाम दर्ज करें (कम से कम 2 अक्षर)',
      );
      return false;
    }

    if (!isValidPhoneNumber(cleanPhone)) {
      state = state.copyWith(
        errorMessage: 'कृपया 10 अंकों का वैध मोबाइल नंबर दर्ज करें',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _firebaseAuthService.register(
        name: trimmedName,
        phoneNumber: cleanPhone,
        craftType: craftType,
        location: location,
      );

      state = state.copyWith(
        isLoading: false,
        currentUser: user,
        isAuthenticated: true,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: $e',
      );
      return false;
    }
  }

  /// Logs in an existing artisan with phone number and retrieves details from Firebase Cloud Firestore.
  Future<bool> login({
    required String phoneNumber,
    String? existingName,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (!isValidPhoneNumber(cleanPhone)) {
      state = state.copyWith(
        errorMessage: 'कृपया 10 अंकों का वैध मोबाइल नंबर दर्ज करें',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _firebaseAuthService.login(
        phoneNumber: cleanPhone,
        existingName: existingName,
      );

      state = state.copyWith(
        isLoading: false,
        currentUser: user,
        isAuthenticated: true,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: $e',
      );
      return false;
    }
  }

  /// Updates artisan profile name and phone number in Firebase Cloud Firestore.
  Future<bool> updateProfile({
    required String name,
    required String phoneNumber,
    String? craftType,
  }) async {
    final trimmedName = name.trim();
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (!isValidName(trimmedName)) {
      state = state.copyWith(
        errorMessage: 'कृपया सही नाम दर्ज करें',
      );
      return false;
    }

    if (!isValidPhoneNumber(cleanPhone)) {
      state = state.copyWith(
        errorMessage: 'कृपया 10 अंकों का वैध मोबाइल नंबर दर्ज करें',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final currentUser = state.currentUser;
    final updatedUser = ArtisanUser(
      id: currentUser?.id ?? 'artisan_$cleanPhone',
      name: trimmedName,
      phoneNumber: cleanPhone,
      craftType: craftType ?? currentUser?.craftType ?? 'हस्तशिल्प',
      location: currentUser?.location ?? 'भारत',
    );

    try {
      await _firebaseAuthService.updateProfile(updatedUser);

      state = state.copyWith(
        isLoading: false,
        currentUser: updatedUser,
        isAuthenticated: true,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Update failed: $e',
      );
      return false;
    }
  }

  /// Logs out the artisan from Firebase and clears session.
  Future<void> logout() async {
    await _firebaseAuthService.logout();
    state = AuthState.initial();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final firebaseService = ref.watch(firebaseAuthServiceProvider);
  return AuthController(firebaseAuthService: firebaseService);
});
