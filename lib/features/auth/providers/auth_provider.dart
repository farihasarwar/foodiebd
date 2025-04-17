import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodiebd/features/auth/services/auth_service.dart';
import 'package:foodiebd/shared/models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth state changes stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user data provider with auto-refresh
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Selected index provider for navigation
final selectedIndexProvider = StateProvider<int>((ref) => 0);

// Auth state notifier for managing auth flow
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(authServiceProvider).loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Reset navigation index to home
      _ref.read(selectedIndexProvider.notifier).state = 0;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(authServiceProvider).logout();
      // Reset navigation index to home
      _ref.read(selectedIndexProvider.notifier).state = 0;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 