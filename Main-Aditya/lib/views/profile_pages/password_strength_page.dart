import 'package:flutter/material.dart';
import 'dart:math';

class PasswordStrengthPage extends StatefulWidget {
  const PasswordStrengthPage({super.key});

  @override
  State<PasswordStrengthPage> createState() => _PasswordStrengthPageState();
}

class _PasswordStrengthPageState extends State<PasswordStrengthPage> {
  final TextEditingController _passwordController = TextEditingController();
  String _passwordStrength = '';
  String _suggestion = '';

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 'Enter a password';
        _suggestion = '';
      });
      return;
    }

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final isLongEnough = password.length >= 8;

    if (hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters &&
        isLongEnough) {
      setState(() {
        _passwordStrength = 'Strong';
        _suggestion = '';
      });
    } else if ((hasUppercase || hasLowercase) &&
        hasDigits &&
        (hasSpecialCharacters || isLongEnough)) {
      setState(() {
        _passwordStrength = 'Medium';
        _suggestion =
            'Add more special characters, uppercase letters, or make it longer.';
      });
    } else {
      setState(() {
        _passwordStrength = 'Weak';
        _suggestion =
            'Use at least 8 characters, including uppercase, lowercase, numbers, and special characters.';
      });
    }
  }

  String _generateStrongPassword(String inputPassword) {
    const specialCharacters = '!@#\$%^&*()_+{}|:<>?';
    final random = Random();

    String strongPassword = inputPassword;

    if (!strongPassword.contains(RegExp(r'[A-Z]'))) {
      strongPassword += String.fromCharCode(random.nextInt(26) + 65);
    }
    if (!strongPassword.contains(RegExp(r'[a-z]'))) {
      strongPassword += String.fromCharCode(random.nextInt(26) + 97);
    }
    if (!strongPassword.contains(RegExp(r'[0-9]'))) {
      strongPassword += random.nextInt(10).toString();
    }
    if (!strongPassword.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      strongPassword +=
          specialCharacters[random.nextInt(specialCharacters.length)];
    }

    while (strongPassword.length < 12) {
      strongPassword += String.fromCharCode(random.nextInt(94) + 33);
    }

    return strongPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Strength',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your password:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter password',
              ),
              onChanged: _checkPasswordStrength,
            ),
            const SizedBox(height: 20),
            Text(
              'Password Strength: $_passwordStrength',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _passwordStrength == 'Strong'
                    ? Colors.green
                    : _passwordStrength == 'Medium'
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
            if (_suggestion.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Suggestion: $_suggestion',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final strongPassword =
                    _generateStrongPassword(_passwordController.text);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Strong Password Suggestion'),
                    content: Text(strongPassword),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Suggest Strong Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
