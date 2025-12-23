class AppValidators {
  AppValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O e-mail é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'O nome é obrigatório';
    if (value.trim().split(' ').length < 2) return 'Informe nome e sobrenome';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'A senha é obrigatória';
    if (value.length < 6) return 'A senha deve ter ao menos 6 caracteres';
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'A confirmação de senha é obrigatória';
    }
    if (password != confirmPassword) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'O telefone é obrigatório';
    final phoneRegex = RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$');
    if (!phoneRegex.hasMatch(value)) return 'Telefone inválido';
    return null;
  }
}