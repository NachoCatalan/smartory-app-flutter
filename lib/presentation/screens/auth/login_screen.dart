import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  AuthView currentView = AuthView.login;
  ProviderSubscription? _authSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authSub = ref.listenManual<AsyncValue<AuthState>>(authProvider, (
        AsyncValue<AuthState>? previous,
        AsyncValue<AuthState> next,
      ) {
        if (previous is AsyncLoading && next is AsyncError) {
          final message = next.error.toString().replaceFirst('Exception: ', '');

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
        next.whenOrNull(
          data: (authState) {
            if (authState.status == AuthStatus.authenticated) {
              context.goNamed('home');
            }
          },
        );
      });
    });
  }

  @override
  void dispose() {
    _authSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onChangeView(AuthView view) {
      ref.read(authProvider.notifier).clearError();
      setState(() {
        currentView = view;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: switch (currentView) {
          AuthView.login => LoginForm(onChangeView: onChangeView),
          AuthView.register => RegisterForm(onChangeView: onChangeView),
          AuthView.recovery => ForgotPasswordForm(onChangeView: onChangeView),
        },
      ),
    );
  }
}
