import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../models/comment_model.dart';

import '../../shard/styles/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var CommentController = TextEditingController();
    return Builder(builder: (context) {
      SocialCubit.get(context).getComments(postId);

      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, State) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(IconBroken.Arrow___Left)),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => commentItem(context,
                          SocialCubit.get(context).comments[index], index),
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemCount: cubit.comments.length,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: CommentController,
                                decoration: InputDecoration(
                                    hintText: "Write a comment...",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle()),
                              ),
                            ),
                          ),
                          if (cubit.commentImage != null)
                            Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    alignment: AlignmentDirectional.topCenter,
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                cubit.commentImage!))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: IconButton(
                                        alignment: AlignmentDirectional.center,
                                        icon: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          cubit.removeCommentImage();
                                        },
                                      ),
                                    ),
                                  )
                                ]),
                          if (cubit.commentImage == null)
                            IconButton(
                                onPressed: () {
                                  cubit.getCommentImage();
                                },
                                icon: Icon(IconBroken.Image)),
                          TextButton(
                              onPressed: () {
                                if (cubit.commentImage == null) {
                                  cubit.createComment(
                                      postId: postId,
                                      commentText: CommentController.text);
                                } else {
                                  cubit.uploadCommentImage(
                                      postId: postId,
                                      commentText: CommentController.text);
                                }
                              },
                              child: Text("نشر")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }

  Widget commentItem(context, CommentModel model, index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10),
      child: Dismissible(
        key: Key(SocialCubit.get(context).commentId[index]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    model.image!,
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        style: TextStyle(
                          fontSize: 16,
                          height: 0.01,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (model.commentText != "")
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            model.commentText!,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
                if (model.commentImage != "")
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(
                            model.commentImage!,
                          ),
                          fit: BoxFit.cover),
                    ),
                  )
              ],
            ),
          ],
        ),
        onDismissed: (direction) {
          SocialCubit.get(context).deleteComment(
              model.postId, SocialCubit.get(context).commentId[index]);
        },
      ),
    );
  }
}
