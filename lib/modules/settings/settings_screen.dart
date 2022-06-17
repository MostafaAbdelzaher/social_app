import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/edit_profile/edit_profile_screen.dart';

import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../shard/component/component.dart';
import '../../shard/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SocialCubit.get(context).userModel;
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            alignment: AlignmentDirectional.topCenter,
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(model!.cover!),
                                )),
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(model.image!),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '${model.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model.bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '240',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '10k',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '64',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  'Followings',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: OutlinedButton(
                        child: const Text('Add Photos'),
                        onPressed: () {},
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        child: const Icon(
                          IconBroken.Edit,
                          size: 16,
                        ),
                        onPressed: () {
                          navigateTo(context, EditProfileScreen());
                        },
                      ),
                      buildTextButton(
                          context: context,
                          title: "تسجيل خروج",
                          function: () {
                            signOut(context);
                            FirebaseAuth.instance.signOut();
                            SocialCubit.get(context).userModel!.uId = null;
                          })
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
