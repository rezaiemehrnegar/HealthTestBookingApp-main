// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_diagnos/provider/auth_provider.dart';
import 'package:digi_diagnos/screens/phone.dart';
import 'adminScreen.dart';
import 'editProfile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authProvider.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (authProvider.isSignedIn)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            authProvider.userModel.profilePic,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Name: ${authProvider.userModel.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone: ${authProvider.userModel.phoneNumber}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Bio: ${authProvider.userModel.bio}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email: ${authProvider.userModel.email}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        // Add more user details here

                        if (authProvider.userModel.role == 'admin')
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF3E69FE),
                              ),
                            ),
                            onPressed: () {
                              // Navigate to the developer screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const AdminScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Go to Developer Screen',
                            ),
                          ),
                        // Add a decorative button with the logic
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF3E69FE),
                            ),
                          ),
                          onPressed: () async {
                            // Trigger loading data from Firestore
                            await authProvider.getDataFromFirestore();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Data loaded from Firestore',
                                ),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const EditProfileScreen(),
                              ),
                            );
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Trigger loading data from Firestore

                          await authProvider.getDataFromFirestore();
                        },
                        child: const Text(
                          'Load Data from Firestore',
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.place),
                            title: const Text('Addresses'),
                            onTap: () {
                              // Add your settings logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.electric_bolt),
                            title: const Text(
                              'Electronic Health Records',
                            ),
                            onTap: () {
                              // Add your settings logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            onTap: () {
                              // Add your settings logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.contact_emergency,
                            ),
                            title: const Text('Contact Us'),
                            onTap: () {
                              // Add your settings logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('LogOut'),
                            onTap: () {
                              // Add your settings logic here
                              // Call the AuthProvider method for user sign out
                              AuthProvider().userSignOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const RegisterScreen(),
                                ),
                              ); // Navigate to login screen
                            },
                          ),
                          // Add more menu items here
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.facebook, size: 30),
                        Icon(Icons.email, size: 30),
                        Icon(Icons.whatshot, size: 30),
                        Icon(Icons.facebook, size: 30),
                        Icon(Icons.email, size: 30),
                        Icon(Icons.whatshot, size: 30),
                        // Add more social media icons here
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
