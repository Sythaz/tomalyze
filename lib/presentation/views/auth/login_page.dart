import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/core/constants/app_colors.dart';
import 'package:tomalyze/core/constants/app_text_styles.dart';
import 'package:tomalyze/core/providers/local_auth_provider.dart';
import 'package:tomalyze/presentation/widgets/custom_button.dart';

import '../../../core/services/google_auth_service.dart';
import '../../widgets/google_sign_in_button.dart';
import '../main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon/app-icon.png',
                    width: 225,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tomalyze',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 25,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username', style: AppTextStyles.bold),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        style: AppTextStyles.regular.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.textFieldBg,
                          hintText: 'Masukkan username anda',
                          hintStyle: AppTextStyles.light.copyWith(
                            fontSize: 14,
                            color: AppColors.blackGrey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          } else if (value.length < 3 || value.length > 10) {
                            return 'Username harus antara 3-10 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Password', style: AppTextStyles.bold),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isPasswordObscured,
                        textInputAction: TextInputAction.done,
                        style: AppTextStyles.regular.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: AppColors.textFieldBg,
                          hintText: 'Masukkan password anda',
                          hintStyle: AppTextStyles.light.copyWith(
                            fontSize: 14,
                            color: AppColors.blackGrey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: AppColors.blackGrey,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          } else if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: Text(
                          'Login',
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        borderRadius: 12,
                        backgroundColor: AppColors.primaryRed,
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                FocusScope.of(context).unfocus();

                                setState(() => _isLoading = true);
                                final localAuth = context
                                    .read<LocalAuthProvider>();
                                final success = await localAuth.login(
                                  username: _usernameController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                if (!mounted) return;

                                if (success) {
                                  Navigator.pushReplacement(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainPage(),
                                    ),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Username atau password salah',
                                      ),
                                    ),
                                  );
                                }

                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              },
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xFFE9EBED),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'atau masuk dengan',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xFFE9EBED),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            GoogleSignInButton(
                              onPressed: () async {
                                // Handle Google Sign-In
                                final user = await GoogleAuthService()
                                    .signInWithGoogleFirebase();

                                if (user != null) {
                                  // User signed in successfully, navigate to home page
                                  Navigator.pushReplacement(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainPage(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
