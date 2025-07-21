import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/contact_provider.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadUsers();
      Provider.of<ContactProvider>(context, listen: false).loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'JP Chat Talk,Fun,Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: AppColors.errorColor),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (chatProvider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No contacts yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add friends by username',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatProvider.users.length,
            itemBuilder: (context, index) {
              final user = chatProvider.users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(
                          user['displayName']?.isNotEmpty == true
                              ? user['displayName'][0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (user['isOnline'] == true)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.onlineColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    user['displayName'] ?? 'Unknown User',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    user['statusText'] ?? 'Hey there! I am using JP Chat Talk,Fun,Chat',
                    style: TextStyle(
                      color: user['isOnline'] == true
                          ? AppColors.onlineColor
                          : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.videocam,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          Get.snackbar(
                            'Video Call',
                            'Video calling feature will be available with Agora setup',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: AppColors.accentColor,
                        ),
                        onPressed: () {
                          Get.snackbar(
                            'Voice Call',
                            'Voice calling feature will be available with Agora setup',
                            backgroundColor: AppColors.accentColor,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.toNamed('/chat', arguments: user);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.person_add),
        onPressed: () {
          _showAddContactDialog();
        },
      ),
    );
  }

  void _showAddContactDialog() {
    final TextEditingController usernameController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the username of the person you want to add:'),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'e.g. john_doe',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              usernameController.dispose();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final username = usernameController.text.trim();
              if (username.isNotEmpty) {
                Get.back();
                await _addContactByUsername(username);
              }
              usernameController.dispose();
            },
            child: const Text(
              'Add Contact',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addContactByUsername(String username) async {
    try {
      final contactProvider = Provider.of<ContactProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      
      // Search for user by username
      final user = await contactProvider.getUserByUsername(username);
      
      if (user == null) {
        Get.snackbar(
          'User Not Found',
          'No user found with username: $username',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        return;
      }
      
      // Add to contacts
      final success = await contactProvider.addContact(user);
      
      if (success) {
        Get.snackbar(
          'Contact Added',
          'Successfully added $username to your contacts!',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
        // Reload the chat users list
        await chatProvider.loadUsers();
      }
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add contact. Please try again.',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
