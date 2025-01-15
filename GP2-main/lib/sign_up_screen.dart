import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'verification_screen.dart'; // Import the VerificationScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _phoneError = '';
  String _firstNameError = '';
  String _lastNameError = '';
  final List<String> _passwordErrors = [];
  String _confirmPasswordError = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _validateInputs() {
    setState(() {
      _phoneError = '';
      _firstNameError = '';
      _lastNameError = '';
      _passwordErrors.clear();
      _confirmPasswordError = '';

      // Validate First Name (only alphabets)
      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'Please enter your first name';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(_firstNameController.text)) {
        _firstNameError = 'First name can only contain alphabets';
      }

      // Validate Last Name (only alphabets)
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Please enter your last name';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(_lastNameController.text)) {
        _lastNameError = 'Last name can only contain alphabets';
      }

      // Validate Phone Number (only digits, exactly 10 digits)
      String phoneText = _phoneController.text;
      if (phoneText.isEmpty || !RegExp(r'^[0-9]{10}$').hasMatch(phoneText)) {
        _phoneError = 'Please enter a valid 10-digit phone number';
      }

      // Validate Password
      if (_passwordController.text.isEmpty) {
        _passwordErrors.add('Please enter a password');
      } else {
        String password = _passwordController.text;
        if (password.length < 8) {
          _passwordErrors.add('Password must be at least 8 characters long');
        }
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one uppercase letter');
        }
        if (!RegExp(r'[a-z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one lowercase letter');
        }
        if (!RegExp(r'[0-9]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one number');
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one special character');
        }
      }

      // Validate Confirm Password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _passwordErrors.add('Passwords do not match!');
        _confirmPasswordError = 'Passwords do not match!';
      }
    });
  }

  void _validateAndContinue() {
    _validateInputs();

    if (_phoneError.isEmpty &&
        _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _passwordErrors.isEmpty &&
        _confirmPasswordError.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(Icons.person_add_alt_1, size: 80, color: Color(0xFF2094F3)),
                  SizedBox(height: 10),
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Fill in the details to sign up',
                    style: TextStyle(fontSize: 16, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Input Fields
            _buildTextField(
              'First Name',
              _firstNameController,
              Icons.person,
              _firstNameError,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), // Only allow alphabets
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Last Name',
              _lastNameController,
              Icons.person,
              _lastNameError,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), // Only allow alphabets
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Phone Number',
              _phoneController,
              Icons.phone,
              _phoneError,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
                LengthLimitingTextInputFormatter(10), // Limit to 10 digits
              ],
            ),
            const SizedBox(height: 20),
            _buildPasswordField('Password', _passwordController, _passwordErrors),
            const SizedBox(height: 20),
            _buildPasswordField('Confirm Password', _confirmPasswordController, [], isConfirmPassword: true),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2094F3),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller,
    IconData icon,
    String errorMessage, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters, // Apply input formatters
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: const TextStyle(color: Color(0xFF888888)),
            prefixIcon: Icon(icon, color: const Color(0xFF60778A)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF2094F3), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(
    String hintText,
    TextEditingController controller,
    List<String> errorMessages, {
    bool isConfirmPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: const TextStyle(color: Color(0xFF888888)),
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF60778A)),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPassword
                    ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                    : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                color: const Color(0xFF60778A),
              ),
              onPressed: () {
                setState(() {
                  if (isConfirmPassword) {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  } else {
                    _isPasswordVisible = !_isPasswordVisible;
                  }
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (errorMessages.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errorMessages
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(e, style: const TextStyle(color: Colors.red, fontSize: 14)),
                    ))
                .toList(),
          ),
      ],
    );
  }
}