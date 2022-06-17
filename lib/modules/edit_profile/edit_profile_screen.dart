import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../shard/component/component.dart';
import '../../shard/component/constants.dart';
import '../../shard/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var BioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);

    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialGetUserSuccessStates) {
        cubit.profileImage = null;
        cubit.coverImage = null;
      }
    }, builder: (context, state) {
      var model = SocialCubit.get(context).userModel;
      nameController.text = model!.name!;
      phoneController.text = model.phone!;
      BioController.text = model.bio!;
      return Scaffold(
        appBar:
            defaultAppBar(context: context, title: "Edit Profile", actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: buildTextButton(
              title: "UPDATE",
              function: () {
                if (cubit.profileImage != null) {
                  cubit.uploadProfileImage(
                    bio: BioController.text,
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                } else if (cubit.coverImage != null) {
                  cubit.uploadCoverImage(
                    bio: BioController.text,
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                } else {
                  cubit.updateUser(
                    bio: BioController.text,
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                }
              },
              context: context,
            ),
          )
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                if (state is SocialUserUpdateLoadingState)
                  SizedBox(
                    height: 15,
                  ),
                if (state is SocialUserUpdateLoadingState)
                  LinearProgressIndicator(
                    backgroundColor: secondaryColor.withOpacity(0.2),
                  ),
                if (state is SocialUserUpdateLoadingState)
                  SizedBox(
                    height: 10,
                  ),
                SizedBox(
                  height: 190,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              alignment: AlignmentDirectional.topCenter,
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: cubit.coverImage == null
                                        ? NetworkImage(model.image!)
                                        : FileImage(
                                                File(cubit.coverImage!.path))
                                            as ImageProvider,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircleAvatar(
                                radius: 20,
                                child: PopupMenuButton(
                                    offset: Offset(0, 35),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    icon: Icon(IconBroken.Camera),
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              child: InkWell(
                                                onTap: () {
                                                  cubit.getCoverImageCamera();
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Icon(
                                                        IconBroken.Camera,
                                                        color: Colors.blue,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    Text("Camera",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.blue,
                                                            ))
                                                  ],
                                                ),
                                              )),
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              child: InkWell(
                                                onTap: () {
                                                  cubit.getCoverImageGallery();
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Icon(
                                                        size: 18,
                                                        IconBroken.Image,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text("Gallery",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.blue,
                                                            ))
                                                  ],
                                                ),
                                              )),
                                        ],
                                    constraints: BoxConstraints(maxWidth: 80)),
                              ),
                            ),
                            if (cubit.coverImage != null)
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.highlight_remove_sharp)),
                              )
                          ],
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: cubit.profileImage == null
                                  ? NetworkImage(model.image!)
                                  : FileImage(File(cubit.profileImage!.path))
                                      as ImageProvider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 20,
                              child: PopupMenuButton(
                                  offset: Offset(0, 35),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  icon: Icon(IconBroken.Camera),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            padding: EdgeInsets.zero,
                                            child: InkWell(
                                              onTap: () {
                                                cubit.getProfileImageCamera();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      IconBroken.Camera,
                                                      color: Colors.blue,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Text("Camera",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption!
                                                          .copyWith(
                                                            color: Colors.blue,
                                                          ))
                                                ],
                                              ),
                                            )),
                                        PopupMenuItem(
                                            padding: EdgeInsets.zero,
                                            child: InkWell(
                                              onTap: () {
                                                cubit.getProfileImageGallery();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      size: 18,
                                                      IconBroken.Image,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Text("Gallery",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption!
                                                          .copyWith(
                                                            color: Colors.blue,
                                                          ))
                                                ],
                                              ),
                                            )),
                                      ],
                                  constraints: BoxConstraints(maxWidth: 80)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  child: defaultTextField(
                      type: TextInputType.name,
                      control: nameController,
                      label: 'Name',
                      prefix: IconBroken.User,
                      isBorder: true),
                ),
                SizedBox(height: 10),
                Card(
                  child: defaultTextField(
                      type: TextInputType.text,
                      control: phoneController,
                      label: 'Phone',
                      prefix: IconBroken.Call,
                      isBorder: true),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: defaultTextField(
                      type: TextInputType.text,
                      control: BioController,
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle,
                      isBorder: true),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
