import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final authProvider = context.read<AuthProvider>();
      await authProvider.signInWithGoogle();

      return true;
    } catch (e) {
      _errorMessage = 'ログインに失敗しました: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
