import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../admin_router.dart';
import '../data/admin_services.dart';
import '../logic/admin_auth_cubit.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _changingRequiredPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _changeRequiredPassword() async {
    final messenger = ScaffoldMessenger.of(context);
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var saving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تغيير كلمة المرور مطلوب'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'أدخل كلمة المرور'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    helperText: 'يجب أن تتكون من 12 حرفًا على الأقل',
                  ),
                  validator: (value) => value == null || value.length < 12
                      ? 'كلمة المرور يجب ألا تقل عن 12 حرفًا'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setDialogState(() => saving = true);
                      final result = await AdminServices.repository
                          .changePassword(
                            currentPassword: currentPassword.text,
                            newPassword: newPassword.text,
                          );
                      if (!mounted || !dialogContext.mounted) return;
                      switch (result) {
                        case Success():
                          await AdminServices.repository.logout();
                          if (!mounted || !dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم تغيير كلمة المرور. سجل الدخول مجددًا.',
                              ),
                            ),
                          );
                          _password.clear();
                        case Failure(:final error):
                          setDialogState(() => saving = false);
                          if (dialogContext.mounted) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(content: Text(error.message)),
                            );
                          }
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('تغيير كلمة المرور'),
            ),
          ],
        ),
      ),
    );
    currentPassword.dispose();
    newPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminAuthCubit(AdminServices.repository),
      child: BlocListener<AdminAuthCubit, AdminAuthState>(
        listener: (context, state) async {
          if (state is! AdminAuthSuccess) return;
          if (state.session.mustChangePassword) {
            if (_changingRequiredPassword) return;
            _changingRequiredPassword = true;
            await _changeRequiredPassword();
            _changingRequiredPassword = false;
          } else {
            context.go(AdminRouter.dashboard);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 52,
                              color: Color(0xFF167C65),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'تسجيل دخول الإدارة',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username],
                              decoration: const InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) =>
                                  value == null || !value.contains('@')
                                  ? 'أدخل بريدًا إلكترونيًا صحيحًا'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _password,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'أدخل كلمة المرور'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AdminAuthCubit, AdminAuthState>(
                              builder: (context, state) => FilledButton(
                                onPressed: state is AdminAuthLoading
                                    ? null
                                    : () {
                                        if (!(_formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          return;
                                        }
                                        context.read<AdminAuthCubit>().login(
                                          email: _email.text.trim(),
                                          password: _password.text,
                                        );
                                      },
                                child: state is AdminAuthLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('دخول'),
                              ),
                            ),
                            BlocBuilder<AdminAuthCubit, AdminAuthState>(
                              builder: (context, state) =>
                                  state is AdminAuthFailure
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
