import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/layout_screen.dart';
import '../../shard/component/component.dart';
import '../../shard/network/local/cache_helper.dart';
import '../register/social_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

var formKey = GlobalKey<FormState>();
var emailController = TextEditingController();
var passwordController = TextEditingController();

class SocialLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            // showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: "uId", value: state.uId).then((value) {
              navigateTo(context, SocialAppLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Login now to Communicate with your friends",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultTextField(
                            prefix: Icons.email,
                            type: TextInputType.text,
                            control: emailController,
                            label: "Email",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "pleas enter your Email";
                              }
                            },
                            isBorder: false),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultTextField(
                            isBorder: false,
                            isPassword:
                                SocialLoginCubit.get(context).isPassWord,
                            prefix: Icons.lock,
                            suffix: SocialLoginCubit.get(context).suffix,
                            suffixButtonPressed: () {
                              SocialLoginCubit.get(context)
                                  .changVisibilityPassWord();
                            },
                            type: TextInputType.text,
                            control: passwordController,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            label: "password",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "pleas enter your password";
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginSuccessState,
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            width: double.infinity,
                            text: "LOGIN",
                            height: 50,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'don\' have an account ?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            buildTextButton(
                                function: () {
                                  navigateTo(context, SocialRegisterScreen());
                                },
                                title: "register",
                                context: context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
