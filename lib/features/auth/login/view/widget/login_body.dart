import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import '../../../../../core/helper/validation.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';
import 'text_form_field_custom.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _nationalId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveWidth(
      16,
      tabletValue: 80,
      desktopValue: 200,
    );

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const HeaderAuth(),
                  verticalSpace(context, height: 40),
                  TextFormFieldCustom(
                    validator: AppValidator.validateNationalId,
                    controller: _nationalId,
                    label: 'الرقم القومي',
                    keyboardType: TextInputType.number,
                  ),
                  verticalSpace(context, height: 16),
                  BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (_, current) => current is LoginInitial,
                    builder: (context, state) {
                      return TextFormFieldCustom(
                        validator: AppValidator.validatePassword,
                        controller: _password,
                        obscureText: _isPasswordHidden,
                        suffixIcon: IconButton(
                          color: Colors.grey,
                          onPressed: () => setState(
                            () => _isPasswordHidden = !_isPasswordHidden,
                          ),
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        label: 'كلمة المرور',
                      );
                    },
                  ),
                  verticalSpace(context, height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context.push(AppRouter.kforget),
                        child: Text(
                          'نسيت كلمة المرور ؟',
                          style: TextStyles.cairoRegular14Primary(context),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(context, height: 10),
                  AppButton(
                    text: 'تسجيل دخول',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<LoginCubit>().login(
                        nationalId: _nationalId.text.trim(),
                        password: _password.text.trim(),
                      );
                    },
                  ),
                  verticalSpace(context, height: 105),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب ؟ ',
                        style: TextStyles.cairoRegular14Black(context),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRouter.kregister),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'سجل الأن',
                          style: TextStyles.cairoRegular14Primary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nationalId.dispose();
    _password.dispose();
    super.dispose();
  }
}
