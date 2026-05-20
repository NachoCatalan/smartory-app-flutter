import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/presentation/providers/auth/auth_provider.dart';
import 'package:smartory_app/presentation/utils/validators.dart';
import 'package:smartory_app/presentation/widgets/widgets.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key, required this.onChangeView});

  final void Function(AuthView view) onChangeView;

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider.notifier);
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;

    onSubmitted() async {
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
        if (Validators.validatePasswords(
              passwordController.text,
              confirmPasswordController.text,
            ) !=
            null) {
          confirmPasswordFocus.requestFocus();
          return;
        }
        return;
      }
      FocusScope.of(context).unfocus();
      await auth.register(emailController.text, passwordController.text);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: Color(0xffe0e0ff),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardHeaderForm(
                  title: 'Crea tu cuenta',
                  icon: Icons.inventory_2,
                ),
                SizedBox(height: 20),
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
                          validator: Validators.validateEmail,
                          hint: 'tu@email.com',
                          icon: Icons.email_outlined,
                          focus: emailFocus,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            passwordFocus.requestFocus();
                          },
                        ),
                        Align(
                          alignment: AlignmentGeometry.topLeft,
                          child: Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        CustomInput(
                          controller: passwordController,
                          validator: (value) =>
                              Validators.validatePassword(value),
                          hint: '',
                          icon: Icons.lock_outline,
                          focus: passwordFocus,
                          isPassword: true,
                          onFieldSubmitted: (_) {
                            confirmPasswordFocus.requestFocus();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        Align(
                          alignment: AlignmentGeometry.topLeft,
                          child: Text(
                            'CONFIRM PASSWORD',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        CustomInput(
                          controller: confirmPasswordController,
                          validator: (value) => Validators.validatePasswords(
                            passwordController.text,
                            value ?? '',
                          ),
                          hint: '',
                          icon: Icons.lock_outline,
                          focus: confirmPasswordFocus,
                          isPassword: true,
                          onFieldSubmitted: (_) {
                            onSubmitted();
                          },
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 5),
                        AuthButton(
                          onPressed: onSubmitted,
                          isLoading: isLoading,
                          text: 'Registrarme',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('O registrate con')],
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
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => widget.onChangeView(AuthView.login),
                          child: Text(
                            'Ya poseo una cuenta',
                            style: TextStyle(
                              color: Color(0xff3f49e0),
                              fontWeight: FontWeight.w700,
                            ),
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
    );
  }
}
