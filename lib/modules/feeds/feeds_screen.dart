import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/post_model.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../models/user_model.dart';
import '../../shard/component/component.dart';
import '../../shard/component/constants.dart';
import '../../shard/styles/icon_broken.dart';
import '../comment/comment_screen.dart';
import '../friendsProfile/friends_profile.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var cubit = SocialCubit.get(context);
        var posts = SocialCubit.get(context).posts;
        return ConditionalBuilder(
          condition: posts.isNotEmpty || userModel != null,
          builder: (context) => Container(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                                cubit.users!.length,
                                (index) =>
                                    friendsItem(cubit.users![index], context)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(userModel!.image!),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextFormField(
                              onTap: () {
                                showModalBottomSheet(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height -
                                              50,
                                    ),
                                    isScrollControlled: true,
                                    context: (context),
                                    builder: (builder) {
                                      return NewPostScreen();
                                    });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 20),
                                hintText: "What is on your mind ... ",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildPostItem(context, posts[index], index),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 8,
                            ),
                        itemCount: posts.length)
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Card buildPostItem(BuildContext context, PostModel model, int index) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.image!),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          model.name!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(height: 1.4),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: secondaryColor,
                          size: 16.5,
                        )
                      ]),
                      Text(
                        model.dateTime!,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {
                      SocialCubit.get(context)
                          .deletePost(SocialCubit.get(context).postsId[index]);
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 16,
                    ))
              ],
            ),
            myDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Text(model.Text!,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 25,
                        child: MaterialButton(
                          minWidth: 1,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Text(
                            "#Software",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 25,
                        child: MaterialButton(
                          minWidth: 1,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Text(
                            "#Software",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (model.postImage != "")
              Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(model.postImage!),
                    ),
                  )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${SocialCubit.get(context).likes[index]}',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${SocialCubit.get(context).commentCount[index]}',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            myDivider(),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 120,
                          ),
                          isScrollControlled: true,
                          context: (context),
                          builder: (builder) {
                            return CommentScreen(
                                postId:
                                    SocialCubit.get(context).postsId[index]);
                          });
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              SocialCubit.get(context).userModel!.image!),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Write comment..",
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context)
                        .likePosts(SocialCubit.get(context).postsId[index]);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget myDivider() => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1.0,
      width: double.infinity,
      color: Colors.grey[300],
    );
Widget friendsItem(SocialUserModel model, context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              friendsProfile(
                model: model,
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    image: NetworkImage(model.image!), fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(model.name!, style: Theme.of(context).textTheme.caption)
          ],
        ),
      ),
    );
