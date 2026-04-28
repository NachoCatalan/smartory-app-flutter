import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartory_app/presentation/providers/auth_provider.dart';
import 'package:smartory_app/presentation/utils/validators.dart';

enum AuthView { login, register, recovery }

class LoginForm extends ConsumerStatefulWidget {
  final void Function(AuthView) onChangeView;

  const LoginForm({super.key, required this.onChangeView});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (authState) {
          if (authState.status == AuthStatus.authenticated) {
            context.go('/home');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });
    final auth = ref.read(authProvider.notifier);
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;

    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: Color(0xffe0e0ff),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              spacing: 35,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  spacing: 8,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color(0xff3f49e0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.inventory_2,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Bienvenido de nuevo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'Gestiona tu despensa con Smartory',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    spacing: 10,
                    children: [
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: Text(
                          'EMAIL',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'tu@email.com',
                          filled: true,
                          fillColor: Color(0xffe0e0ff),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PASSWORD',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: Color(0xff3f49e0),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: '********',
                          filled: true,
                          fillColor: Color(0xffe0e0ff),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              BeveledRectangleBorder(),
                            ),
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.green;
                                  }
                                  return Color(0xff3f49e0);
                                }),
                          ),
                          child: !isLoading
                              ? Text(
                                  'Iniciar sesión',
                                  style: TextStyle(color: Colors.white),
                                )
                              : CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('O CONTINUA CON')],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withAlpha(100),
                                  width: 1,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              child: Center(
                                child: Text(
                                  'Google',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withAlpha(100),
                                  width: 1,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              child: Center(
                                child: Text(
                                  'GitHub',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes una cuenta?'),
                    SizedBox(width: 5),
                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: Color(0xff3f49e0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
