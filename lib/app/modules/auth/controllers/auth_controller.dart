import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userUid = ''.obs;
  final RxBool isGuest = false.obs;
  final Rx<User?> firebaseUser = Rx<User?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
    // Listen to auth state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _checkSavedLogin();
  }

  Future<void> _checkSavedLogin() async {
    final isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    final savedUid = _prefs?.getString('uid') ?? '';
    
    if (isLoggedIn && savedUid.isNotEmpty) {
      // Try to auto-login with saved credentials
      try {
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.uid == savedUid) {
          // User is already logged in, load data and go to home
          await _loadSavedUserData();
          Get.offAllNamed(AppRoutes.home);
        }
      } catch (e) {
        print('Auto-login failed: $e');
        await clearLoginData();
      }
    }
  }

  Future<void> _loadSavedUserData() async {
    userUid.value = _prefs?.getString('uid') ?? '';
    userEmail.value = _prefs?.getString('email') ?? '';
    userName.value = _prefs?.getString('name') ?? '';
    userRole.value = _prefs?.getString('role') ?? 'patient';
    isGuest.value = false;
    
    if (userUid.value.isNotEmpty) {
      await _loadUserData(userUid.value);
    }
  }

  Future<void> _saveUserData(String uid, String email, String name, String role) async {
    await _prefs?.setBool('isLoggedIn', true);
    await _prefs?.setString('uid', uid);
    await _prefs?.setString('email', email);
    await _prefs?.setString('name', name);
    await _prefs?.setString('role', role);
  }

  Future<void> clearLoginData() async {
    await _prefs?.setBool('isLoggedIn', false);
    await _prefs?.remove('uid');
    await _prefs?.remove('email');
    await _prefs?.remove('name');
    await _prefs?.remove('role');
  }

  void _handleAuthChanged(User? user) {
    if (user == null && !isGuest.value) {
      // User is not logged in and not in guest mode
      userName.value = '';
      userEmail.value = '';
    } else if (user != null) {
      // User is logged in
      isGuest.value = false;
      userEmail.value = user.email ?? '';
      _loadUserData(user.uid);
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        userName.value = data?['name'] ?? '';
        userRole.value = data?['role'] ?? 'patient';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    // Clear fields when switching
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final uid = user.uid;
        final email = user.email ?? '';
        final role = 'patient'; // Default role
        
        // Load user name from Firestore
        await _loadUserData(uid);
        final name = userName.value.isNotEmpty ? userName.value : email.split('@')[0];
        
        // Save user data to SharedPreferences
        await _saveUserData(uid, email, name, role);
        
        userUid.value = uid;
        userRole.value = role;
        
        isGuest.value = false;
        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'Welcome!',
          'Successfully logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green,
        );
      } else {
        // User is null - show error
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (nameController.text.isEmpty || 
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final uid = user.uid;
        final email = user.email ?? '';
        final name = nameController.text.trim();
        final role = 'patient'; // Default role

        // Create user document in Firestore
        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update display name in Firebase Auth
        await user.updateDisplayName(name);

        // Save user data to SharedPreferences
        await _saveUserData(uid, email, name, role);
        
        isGuest.value = false;
        userName.value = name;
        userEmail.value = email;
        userUid.value = uid;
        userRole.value = role;

        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'Welcome!',
          'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green,
        );
      } else {
        throw Exception('User creation failed - user is null');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Sign up failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists with this email';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void continueAsGuest() {
    isGuest.value = true;
    userName.value = 'Guest';
    userEmail.value = '';
    
    Get.offAllNamed(AppRoutes.home);
    
    Get.snackbar(
      'Guest Mode',
      'You are browsing as a guest',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange,
    );
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Sign out from Firebase Auth
      await _auth.signOut();
      
      // Clear SharedPreferences
      await clearLoginData();
      
      // Clear local state
      isGuest.value = false;
      userName.value = '';
      userEmail.value = '';
      userUid.value = '';
      userRole.value = '';
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      
      Get.offAllNamed(AppRoutes.auth);
      
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Don't dispose controllers here since AuthController is permanent
    // Controllers will be reused when navigating back to auth screen
    super.onClose();
  }
}
