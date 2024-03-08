import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'HomePage.dart';
import 'main.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  Future<void> registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:3300/register'), // Replace with your server URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'fullName': fullNameController.text,
            'dob': dobController.text,
            'phoneNumber': phoneNumberController.text,
            'address': addressController.text,
            'emailAddress': emailAddressController.text,
            'password': passwordController.text,
          }),
        );

        if (response.statusCode == 201) {
          print('User registered successfully');
          showSuccessMessage('User registered successfully!');
          // Navigate to the next screen or perform other actions
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          });
        } else {
          print('Error registering user: ${response.body}');
          // Handle registration error
          showErrorMessage('Error registering user');
        }
      } catch (e) {
        print('Exception during registration: $e');
        // Handle other exceptions
        showErrorMessage('Error during registration');
      }
    }
  }

  // Date of birth validation function
  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    // Validate date format (YYYY-MM-DD) with only numeric values
    final RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegExp.hasMatch(value)) {
      return 'Invalid date format. Please use YYYY-MM-DD';
    }

    // Additional date validation logic can be added if needed

    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Format the selected date as needed (YYYY-MM-DD)
      dobController.text =
      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  void showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (YYYY-MM-DD)',
                          border: OutlineInputBorder(),
                          suffix: Text('-'), // Add a suffix to the input field
                        ),

                        keyboardType: TextInputType.number,
                        validator: validateDateOfBirth,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Add more specific phone number validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: emailAddressController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Add more specific email validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add more specific password validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Material(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: registerUser,
                      child: Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







