import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/modules/register/register_cubit/cubit.dart';
import 'package:social/modules/register/register_cubit/states.dart';

import '../../layout/layout_screen.dart';
import '../../shard/component/component.dart';
import '../../shard/network/local/cache_helper.dart';
import '../../shard/styles/icon_broken.dart';

var nameController = TextEditingController();
var passwordController = TextEditingController();
var phoneController = TextEditingController();
var emailController = TextEditingController();
var formKey = GlobalKey<FormState>();

class SocialRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateSuccessState) {
            CacheHelper.saveData(key: "uId", value: state.uId).then((value) {
              SocialCubit.get(context).getUserData();
              navigateAndFinish(context, SocialAppLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(IconBroken.Arrow___Left_2),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REGISTER",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Register now to Communicate with your friends",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextField(
                            isBorder: true,
                            prefix: Icons.person,
                            type: TextInputType.text,
                            control: nameController,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            label: "User name",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Pleas enter your name";
                              }
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextField(
                            isBorder: true,
                            prefix: Icons.email,
                            type: TextInputType.emailAddress,
                            control: emailController,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            label: "Email",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Pleas enter your email";
                              }
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextField(
                            isBorder: true,
                            isPassword:
                                SocialRegisterCubit.get(context).isPassWord,
                            prefix: Icons.lock,
                            suffix: SocialRegisterCubit.get(context).suffix,
                            suffixButtonPressed: () {
                              SocialRegisterCubit.get(context)
                                  .changVisibilityPassWord();
                            },
                            type: TextInputType.text,
                            control: passwordController,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            label: "password",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Pleas enter your password";
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextField(
                            isBorder: true,
                            prefix: Icons.phone,
                            type: TextInputType.text,
                            control: phoneController,
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            label: "Phone",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Pleas enter your phone";
                              }
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: "Register",
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
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
