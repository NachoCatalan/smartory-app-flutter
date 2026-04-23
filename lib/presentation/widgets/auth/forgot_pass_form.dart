import 'package:flutter/material.dart';
import 'package:smartory_app/presentation/widgets/auth/login_form.dart';

import '../../utils/validators.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key, required this.onChangeView});

  final void Function(AuthView view) onChangeView;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {

  final _formKey = GlobalKey<FormState>();
  // Focus de inputs
  final emailFocus = FocusNode();
  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          FocusScope.of(context).unfocus()
        },
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: size.height * 0.9,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(245, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 30,
                      children: [
                        Text(
                          'Recuperación de contraseña',
                          style: textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "A continuación ingrese el email de su cuenta a recuperar:",
                          style: textTheme.bodyLarge,
                        ),
                        TextFormField(
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            label: Text('Email', style: textTheme.labelMedium),
                          ),
                          validator: (value) {
                            if ( value == null || value.isEmpty ) {
                              return 'Campo obligatorio';
                            }
                            if (!Validators.emailValidator(value)) {
                              return 'Ingrese email valido';
                            }
                            return null;
                          },
                        ),
                        FilledButton(
                          child: Center(
                            child: Text(
                              'Recuperar cuenta',
                              style: textTheme.labelLarge,
                            ),
                          ),
                          onPressed: () {
                            if ( _formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data'))
                              );
                            }
                            
                          },
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ya poseo una cuenta',
                                style: textTheme.bodySmall,
                              ),
                              SizedBox(width: 5),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    widget.onChangeView(AuthView.login);
                                  },

                                  splashColor: Colors.deepPurple.withValues(
                                    alpha: 0.1,
                                  ),
                                  highlightColor: Colors.deepPurple.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      'Ingresar',
                                      style: TextStyle(
                                        color: Colors.deepPurple
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

