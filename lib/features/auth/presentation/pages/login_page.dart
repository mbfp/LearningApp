import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _LoginViewMobile(),
    );
  }
}

class _LoginViewMobile extends StatelessWidget {
  _LoginViewMobile({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    login() {
      if (formKey.currentState?.validate() ?? false) {
        BlocProvider.of<AuthenticationBloc>(context).add(
          LoggedIn(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
      }
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.pageHorizontalPadding),
            child: AutofillGroup(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UITextFormField(
                      autofillHints: [AutofillHints.email],
                      inputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      validation: (text) {
                        if (text!.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text)) {
                          return "Invalid email";
                        }
                      },
                      label: 'Email',
                    ),
                    UITextFormField(
                      autofillHints: [AutofillHints.password],
                      inputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                      controller: passwordController,
                      obscureText: true,
                      validation: (text) {
                        if (text!.isEmpty) {
                          return "Password cannot be empty";
                        }
                      },
                      label: 'Password',
                      onFieldSubmitted: (_) => login(),
                    ),
                    Text(
                        (state is AuthenticationLoadFailure)
                            ? state.message
                            : "",
                        style: UIText.normal.copyWith(
                          color: UIColors.red,
                        )),

                    //Sign up button
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    //Login button
                    UICardButton(
                      color: UIColors.primary,
                      text: Text(
                        "Login",
                        style: UIText.labelBold.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () => login(),
                    ),
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    GestureDetector(
                      onTap: () => context.go(
                        "${AppRouter.landingPath}/${AppRouter.registerPath}",
                      ),
                      child: const Text(
                        "No Account yet? Sign up",
                        style: UIText.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
