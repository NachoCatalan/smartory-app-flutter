import 'package:flutter/material.dart';
import 'package:smartory_app/presentation/utils/validators.dart';
import 'package:smartory_app/presentation/widgets/auth/login_form.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.onChangeView});

  final void Function(AuthView view) onChangeView;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final _formKey = GlobalKey<FormState>();
  // Focus de inputs
  final emailFocus = FocusNode();
  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    usernameFocus.dispose();
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
                          'Registro de usuario',
                          style: textTheme.titleLarge,
                        ),
                        SizedBox(height: 5),
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
                        TextFormField(
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_pin),
                            label: Text('Username', style: textTheme.labelMedium),
                          ),
                          validator: (value) {
                            if ( value == null || value.isEmpty ) {
                              return 'Campo obligatorio';
                            }
                            if ( value.length <= 5 ) {
                              return 'Largo mínimo de 5 caracteres';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            label: Text(
                              'Contraseña',
                              style: textTheme.labelMedium,
                            ),
                          ),
                          validator: (value) {
                            if ( value == null || value.isEmpty ) {
                              return 'Campo obligatorio';
                            }
                            if ( value.length <= 5 ) {
                              return 'Largo mínimo de 5 caracteres';
                            }
                            return null;
                          },
                        ),
                        FilledButton(
                          child: Center(
                            child: Text(
                              'Registrarme',
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
