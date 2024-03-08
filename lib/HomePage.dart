import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id;
  final String name;
  final DateTime dob;
  final String phoneNumber;
  final String address;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.dob,
    required this.phoneNumber,
    required this.address,
    required this.email,
  });
}

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUserDetails(widget.username);
  }

  Future<User> fetchUserDetails(String username) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.149:3300/userDetails?username=$username'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return User(
          id: userData['id'],
          name: userData['name'],
          dob: DateTime.parse(userData['dob']),
          phoneNumber: userData['phoneNumber'],
          address: userData['address'],
          email: userData['email'],
        );
      } else {
        throw Exception('Failed to load user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception('Failed to load user details. Check console for details.');
    }
  }

  // Function to handle logout
  void _handleLogout() {
    // Add any logout logic here
    // For now, let's just navigate back to the previous screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            User user = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, ${widget.username}!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('User Details:'),
                  Text('ID: ${user.id}'),
                  Text('Name: ${user.name}'),
                  Text('Date of Birth: ${user.dob.toLocal()}'), // Format the date
                  Text('Phone Number: ${user.phoneNumber}'),
                  Text('Address: ${user.address}'),
                  Text('Email: ${user.email}'),
                  // Add other user details here based on the fetched data

                  // Logout button
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
