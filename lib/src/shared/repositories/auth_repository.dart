import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('E-mail não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta.');
      } else if (e.code == 'invalid-email') {
         throw AuthException('E-mail inválido.');
      } else {
        throw AuthException('Erro ao fazer login: ${e.code}');
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este e-mail já está cadastrado.');
      } else {
        throw AuthException('Erro ao cadastrar: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}