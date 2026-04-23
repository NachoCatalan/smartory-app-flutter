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
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 45,
                bottom: MediaQuery.of(context).viewInsets.bottom + 45,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height,
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                spacing: 30,
                                children: [
                                  Text(
                                    'Smartory App',
                                    style: textTheme.headlineLarge,
                                  ),

                                  TextFormField(
                                    controller: emailController,
                                    focusNode: emailFocus,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      if (!Validators.emailValidator(value)) {
                                        return 'Ingrese un email valido';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        Icons.person_outline_outlined,
                                      ),
                                      label: Text(
                                        'Email',
                                        style: textTheme.labelMedium,
                                      ),
                                    ),
                                  ),

                                  TextFormField(
                                    controller: passwordController,
                                    focusNode: passwordFocus,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.security_outlined),
                                      label: Text(
                                        'Contraseña',
                                        style: textTheme.labelMedium,
                                      ),
                                    ),
                                  ),

                                  FilledButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              emailFocus.requestFocus();
                                              return;
                                            }

                                            auth.login(
                                              emailController.text,
                                              passwordController.text,
                                            );
                                          },
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            'Iniciar sesión',
                                            style: textTheme.labelLarge,
                                          ),
                                  ),

                                  // resto de tu contenido
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
