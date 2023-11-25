import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((userReturn) {
      user = userReturn;
      isLoading = false;
      notifyListeners();
    });
  }

  register(String email, String senha, String nome) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
      _saveUsername(nome);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A Senha deve conter no mínimo 6 caracteres');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está sendo utilizado');
      } else if (e.code == "invalid-email") {
        throw AuthException('Informe um email válido.');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw AuthException('Usuário ou Senha inválidos.');
      } else if (e.code == "invalid-email") {
        throw AuthException('Informe um email válido');
      }
    }
  }

  logout() async {
    _auth.signOut();
    _getUser();
  }

  _getUser() async {
    user = _auth.currentUser;
    notifyListeners();
  }

  _saveUsername(String nome) async {
    user = _auth.currentUser;
    await user?.updateDisplayName(nome);
  }
}

class AuthException implements Exception {
  String message = '';

  AuthException(this.message);
}
