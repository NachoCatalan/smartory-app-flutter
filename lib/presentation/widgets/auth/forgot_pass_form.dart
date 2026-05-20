import 'package:flutter/material.dart';
import 'package:smartory_app/presentation/widgets/auth/login_form.dart';

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Material(
        color: Color(0xffe0e0ff),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
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
                      'Recuperar contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
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
                        Text(
                          'A continuación ingresa el email de la cuenta que deseas recuperar',
                        ),
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
                            child: Text(
                              'Enviar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => widget.onChangeView(AuthView.login),
                          child: Text(
                            'Volver al inicio',
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
