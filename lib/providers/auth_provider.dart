import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:copy_app/models/user_model.dart';
import 'package:copy_app/features/auth/data/auth_service.dart';
import 'package:copy_app/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      if (user != null) {
        _fetchUserModel(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> _fetchUserModel(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      _userModel = UserModel.fromMap(doc.data()!);
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.loginWithEmail(email: email, password: password);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } catch (e) {
      _error = e.toString().contains('cancelled')
          ? 'Вход через Google отменён'
          : 'Ошибка входа через Google';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String city,
    String? surname,
  }) async {
    if (_user == null) {
      _error = 'Пользователь не найден';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      await _firestoreService.updateUserProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        phone: phone,
        city: city,
        photoUrl: _userModel?.photoUrl,
        surname: surname,
      );
      await _fetchUserModel(_user!.uid);
      _error = null;
      return true;
    } catch (_) {
      _error = 'Не удалось обновить профиль';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    if (_user == null) {
      _error = 'Пользователь не найден';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      await _firestoreService.deleteUserData(_user!.uid);
      await _authService.deleteCurrentUser();
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } catch (_) {
      _error = 'Не удалось удалить аккаунт';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
