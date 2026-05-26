import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../controllers/auth_state.dart';
import '../providers/auth_providers.dart';

final rememberedCredentialsProvider =
    FutureProvider.autoDispose<Map<String, String>?>((ref) async {
      ref.watch(authControllerProvider);
      return ref
          .read(authControllerProvider.notifier)
          .getRememberedCredentials();
    });

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _rememberMe = true;
  bool _obscure = true;
  bool _isRedirectingToHome = false;
  bool _didInitRemembered = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          rememberMe: _rememberMe,
        );
  }

  void _initRemembered(Map<String, String>? creds) {
    if (_didInitRemembered) return;
    _didInitRemembered = true;

    if (creds == null) return;

    final email = (creds['email'] ?? '').trim();
    if (email.isNotEmpty) {
      _emailCtrl.text = email;
    }

    if (!_rememberMe) {
      setState(() => _rememberMe = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is AuthError) {
        if (_isRedirectingToHome && mounted) {
          setState(() => _isRedirectingToHome = false);
        }

        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: const Text('Error'),
          description: Text(next.message),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(14),
          showProgressBar: false,
        );
      }

      if (next is AuthAuthenticated) {
        if (!_isRedirectingToHome && mounted) {
          setState(() => _isRedirectingToHome = true);
        }

        Future.delayed(const Duration(milliseconds: 850), () {
          if (context.mounted) context.go('/home');
        });
      }

      if (next is AuthInitial || next is AuthUnauthenticated) {
        if (_isRedirectingToHome && mounted) {
          setState(() => _isRedirectingToHome = false);
        }
      }
    });

    final state = ref.watch(authControllerProvider);
    final isLoading = state is AuthLoading;
    final showFormLoading = isLoading || _isRedirectingToHome;

    final rememberedAsync = ref.watch(rememberedCredentialsProvider);
    rememberedAsync.whenData(_initRemembered);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF001D39), Color(0xFF0A4174)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7FAFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(900, 260),
                          topRight: Radius.elliptical(900, 260),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 134, 24, 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B2633),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !showFormLoading,
                                decoration: InputDecoration(
                                  hintText: 'you@email.com',
                                  prefixIcon: const Icon(Icons.mail_outline),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'Ingresa tu correo';
                                  if (!value.contains('@')) {
                                    return 'Correo inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B2633),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: _obscure,
                                enabled: !showFormLoading,
                                decoration: InputDecoration(
                                  hintText: '********',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: showFormLoading
                                        ? null
                                        : () => setState(
                                            () => _obscure = !_obscure,
                                          ),
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  final value = v ?? '';
                                  if (value.isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }
                                  if (value.length < 3) {
                                    return 'Contraseña muy corta';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: showFormLoading
                                        ? null
                                        : (v) => setState(
                                            () => _rememberMe = v ?? true,
                                          ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    activeColor: const Color.fromARGB(
                                      255,
                                      53,
                                      118,
                                      197,
                                    ),
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Color(0xFF1B2633),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: showFormLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7BBDE8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              rememberedAsync.when(
                                data: (creds) {
                                  if (creds == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: OutlinedButton.icon(
                                        onPressed: showFormLoading
                                            ? null
                                            : () => ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .loginWithBiometrics(),
                                        icon: const Icon(Icons.fingerprint),
                                        label: const Text(
                                          'Login con huella',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (error, stackTrace) =>
                                    const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showFormLoading)
            Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  color: const Color(0xFF001D39).withValues(alpha: 0.34),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                            color: Colors.black.withValues(alpha: 0.10),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2.6),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Validando acceso...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B2633),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
