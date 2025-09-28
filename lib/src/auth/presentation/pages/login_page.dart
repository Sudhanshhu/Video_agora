import 'package:ecommerce/core/common/widget/buttons/loading_view.dart';
import 'package:ecommerce/core/common/widget/k_textform_field.dart';
import 'package:ecommerce/core/toast.dart';
import 'package:ecommerce/src/home/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widget/common_scaffold.dart';
import '../../data/models/user_model.dart';
import '../bloc/auth_bloc.dart';
import 'register_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          UserModel? user = snapshot.data != null
              ? UserModel.fromFirebaseUser(snapshot.data)
              : null;
          return HomePage(user: user!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController =
      TextEditingController(text: "test@test.com");
  final TextEditingController passwordController =
      TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "",
      showAppBar: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            fToast("Login Successful", type: AlertType.success);
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return HomePage(user: state.user); // Replace with your home page
            }));
          } else if (state is AuthError) {
            fToast(state.message, type: AlertType.failure);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: context.read<AuthBloc>().formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  KTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    inputType: InputType.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  KTextFormField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            SignInEvent(
                                emailController.text, passwordController.text),
                          );
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text('Create an Account'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
