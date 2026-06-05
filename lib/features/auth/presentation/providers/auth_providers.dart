import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firestore_service.dart';
import '../../data/auth_service.dart';
import '../../domain/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userModelProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.asyncMap((user) async {
    if (user == null) {
      return null;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  });
});

class AuthUiState {
  const AuthUiState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthUiState copyWith({bool? isLoading, String? error}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => const AuthUiState();

  AuthService get _authService => ref.read(authServiceProvider);

  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.loginWithEmail(email: email, password: password);
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithGoogle();
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    } catch (e) {
      state = AuthUiState(
        error: e.toString().contains('cancelled')
            ? 'Вход через Google отменён'
            : 'Ошибка входа через Google',
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.sendPasswordResetEmail(email);
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String city,
    String? surname,
    String? photoUrl,
  }) async {
    final user = _authService.currentUser;
    if (user == null) {
      state = const AuthUiState(error: 'Пользователь не найден');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(firestoreServiceProvider).updateUserProfile(
            uid: user.uid,
            name: name,
            email: email,
            phone: phone,
            city: city,
            photoUrl: photoUrl,
            surname: surname,
          );
      state = const AuthUiState();
      ref.invalidate(userModelProvider);
      return true;
    } catch (_) {
      state = const AuthUiState(error: 'Не удалось обновить профиль');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    final user = _authService.currentUser;
    if (user == null) {
      state = const AuthUiState(error: 'Пользователь не найден');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(firestoreServiceProvider).deleteUserData(user.uid);
      await user.delete();
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    } catch (_) {
      state = const AuthUiState(error: 'Не удалось удалить аккаунт');
      return false;
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'weak-password':
        return 'Пароль слишком слабый (минимум 6 символов)';
      case 'invalid-email':
        return 'Некорректный email';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'network-request-failed':
        return 'Проверьте подключение к интернету';
      case 'requires-recent-login':
        return 'Для удаления аккаунта войдите снова и повторите попытку';
      default:
        return 'Произошла ошибка. Попробуйте снова';
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthUiState>(AuthController.new);
