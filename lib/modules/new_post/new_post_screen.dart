import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../layout/cubit/social_cubit.dart';

import '../../layout/cubit/social_states.dart';
import '../../shard/component/component.dart';
import '../../shard/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialCreatePostSuccessStates) {
        if (postController.text.isNotEmpty &&
            SocialCubit.get(context).postImage != "") {
          showToast(text: "تم النشر ", state: ToastStates.SUCCESS);
        } else {
          showToast(text: "المنشور فارغ ", state: ToastStates.WARING);
        }
        postController.clear();
        SocialCubit.get(context).removePostImage();
      }
    }, builder: (context, state) {
      var cubit = SocialCubit.get(context);

      return Scaffold(
        appBar: defaultAppBar(context: context, title: "Create Post", actions: [
          buildTextButton(
              function: () {
                if (postController.text.isNotEmpty &&
                    SocialCubit.get(context).postImage !=
                        "") if (cubit.postImage == null) {
                  cubit.CreatePost(
                      text: postController.text,
                      dateTime: DateFormat(' kk:mm')
                          .format(DateTime.now())
                          .toString());
                } else {
                  cubit.uploadPostImage(
                      dateTime: DateTime.now().toString(),
                      text: postController.text);
                }
              },
              title: 'Post',
              context: context),
        ]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            if (state is SocialCreatePostLoadingStates)
              LinearProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage(SocialCubit.get(context).userModel!.image!),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Row(children: [
                    Text(
                      'Mostafa Ahmed',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16,
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
                maxLines: 10,
                controller: postController,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What is on your mind ... ",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 15)),
              ),
            ),
            if (cubit.postImage != null)
              Stack(alignment: AlignmentDirectional.topEnd, children: [
                Container(
                  alignment: AlignmentDirectional.topCenter,
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(cubit.postImage!))),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 20,
                    child: IconButton(
                      alignment: AlignmentDirectional.center,
                      icon: Icon(
                        Icons.close,
                        size: 18,
                      ),
                      onPressed: () {
                        cubit.removePostImage();
                      },
                    ),
                  ),
                )
              ]),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add photo",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '#Tags',
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}
