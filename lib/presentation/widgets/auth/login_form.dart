import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartory_app/presentation/providers/auth/auth_provider.dart';
import 'package:smartory_app/presentation/utils/validators.dart';
import 'package:smartory_app/presentation/widgets/widgets.dart';

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
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(error.toString().replaceFirst('Exception: ', '')),
              ),
            );
        },
      );
    });
    final auth = ref.read(authProvider.notifier);
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;

    void onSubmitted() async {
      final isValid = _formKey.currentState!.validate();

      if (!isValid) {
        if (Validators.validateEmail(emailController.text) != null) {
          emailFocus.requestFocus();
          return;
        }
        if (Validators.validatePassword(passwordController.text) != null) {
          passwordFocus.requestFocus();
          return;
        }
        return;
      }
      FocusScope.of(context).unfocus();

      await auth.login(emailController.text, passwordController.text);
    }

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
                CardHeaderForm(
                  icon: Icons.inventory_2,
                  title: 'Bienvenido de nuevo',
                  subTitle: 'Gestiona tu despensa con Smartory',
                ),
                Form(
                  key: _formKey,
                  child: Container(
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
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        CustomInput(
                          controller: emailController,
                          focus: emailFocus,
                          icon: Icons.email_outlined,
                          textInputAction: TextInputAction.next,
                          hint: 'tu@email.com',
                          validator: Validators.validateEmail,
                          onFieldSubmitted: (_) {
                            passwordFocus.requestFocus();
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PASSWORD',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  widget.onChangeView(AuthView.recovery),
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Color(0xff3f49e0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        CustomInput(
                          controller: passwordController,
                          focus: passwordFocus,
                          textInputAction: TextInputAction.done,
                          hint: "********",
                          isPassword: true,
                          icon: Icons.lock_outline,
                          validator: Validators.validatePassword,
                          onFieldSubmitted: (_) {
                            onSubmitted();
                          },
                        ),
                        SizedBox(height: 5),
                        AuthButton(
                          onPressed: onSubmitted,
                          isLoading: isLoading,
                          text: 'Iniciar sesión',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('O continua con')],
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes una cuenta?'),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () => widget.onChangeView(AuthView.register),
                      child: Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: Color(0xff3f49e0),
                          fontWeight: FontWeight.w700,
                        ),
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
