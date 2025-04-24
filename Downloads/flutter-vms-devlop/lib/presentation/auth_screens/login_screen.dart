import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vms/common/colors.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/components/inputfields.dart';
import 'package:vms/utils/components/primary_button.dart';

import '../../routes/pages.dart'; // Add this import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool passwordVisible = false;
  bool isLoading = false;
  bool rememberMe = false;

  static const String PREF_EMAIL = 'remembered_email';
  static const String PREF_PASSWORD = 'remembered_password';
  static const String PREF_REMEMBER = 'remember_credentials';
  static const String PREF_MOKSA_TOKEN = 'moksa_auth_token';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emailFocus);
    });

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        _scrollToField(_emailFocus);
      }
    });
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        _scrollToField(_passwordFocus);
      }
    });
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldRemember = prefs.getBool(PREF_REMEMBER) ?? false;
    if (shouldRemember) {
      setState(() {
        emailController.text = prefs.getString(PREF_EMAIL) ?? '';
        passwordController.text =
            prefs.getString(PREF_PASSWORD) ?? '';
        rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString(PREF_EMAIL, emailController.text);
      await prefs.setString(PREF_PASSWORD, passwordController.text);
      await prefs.setBool(PREF_REMEMBER, true);
    } else {
      await prefs.remove(PREF_EMAIL);
      await prefs.remove(PREF_PASSWORD);
      await prefs.setBool(PREF_REMEMBER, false);
    }
  }

  void _scrollToField(FocusNode focusNode) {
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose(); // Dispose FocusNode
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Future<String?> _makeMoksaApiCall() async {
    try {
      final response = await http.post(
        Uri.parse('https://mobile.moksa.ai/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
          "expiry": "1d",
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveMoksaToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREF_MOKSA_TOKEN, token);
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    AuthService auth = AuthService();
    final bool isAuth = await auth.login(
        emailController.text, passwordController.text);

    // if (isAuth) {
    //   await _saveCredentials();
    //   Get.offAndToNamed(AppScreens.home);
    // } else {
    //   debugPrint("Login Failed");
    // }
    if (isAuth) {
      await _saveCredentials();

      final moksaToken = await _makeMoksaApiCall();

      if (moksaToken != null) {
        await _saveMoksaToken(moksaToken);
        debugPrint('Moksa token saved successfully');
      } else {
        debugPrint('Failed to get Moksa token');
      }

      Get.offAndToNamed(AppScreens.home);
    } else {
      debugPrint("Login Failed");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.splashbg,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController, // Set ScrollController
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0,
              MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const SizedBox(height: 80),
                  Center(
                    child: Image.asset('assets/images/moksalogo.png'),
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Login to your account',
                      style: heading2.copyWith(color: textWhiteGrey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Email',
                      suffixIcon: const SizedBox(),
                      controller: emailController,
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            _passwordFocus); // Move focus to password field
                      },
                      autofillHints: [AutofillHints.username],
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      hintText: 'Password',
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      suffixIcon: IconButton(
                        color: textGrey,
                        splashRadius: 1,
                        icon: Icon(passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: togglePassword,
                      ),
                      autofillHints: [AutofillHints.password],
                    ),
                    Gap(16),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                          activeColor: primaryBlue,
                        ),
                        Text(
                          'Remember me',
                          style: regular16pt.copyWith(
                              color: textWhiteGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomPrimaryButton(
                buttonColor: primaryBlue,
                textValue: 'Login',
                textColor: Colors.white,
                isLoading: isLoading,
                onPressed: _login,
              ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
