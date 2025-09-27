import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widget/k_textform_field.dart';
import '../../../../core/toast.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return Form(
            key: context.read<AuthBloc>().signUpFormKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
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
                            SignUpEvent(
                                emailController.text, passwordController.text),
                          );
                    },
                    child: const Text('Create Account'),
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
