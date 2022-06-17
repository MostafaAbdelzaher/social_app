import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../shard/component/component.dart';
import '../../shard/component/constants.dart';
import '../../shard/styles/icon_broken.dart';
import 'message_image_screen.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel model;

  const ChatDetailsScreen({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();

    return Builder(builder: (context) {
      SocialCubit.get(context).getMessage(model.uId!);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(IconBroken.Arrow___Left_2)),
              title: Row(
                children: [
                  CircleAvatar(
                      radius: 20, backgroundImage: NetworkImage(model.image!)),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    model.name!,
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (model.uId ==
                              SocialCubit.get(context)
                                  .getMessageModel[index]
                                  .receiverId)
                            return buildMyMessage(
                                SocialCubit.get(context).getMessageModel[index],
                                context);
                          return buildMessage(
                              SocialCubit.get(context).getMessageModel[index],
                              context);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount:
                            SocialCubit.get(context).getMessageModel.length),
                  ),
                  if (SocialCubit.get(context).messageImage != null)
                    Stack(alignment: AlignmentDirectional.topEnd, children: [
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                    SocialCubit.get(context).messageImage!))),
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
                              SocialCubit.get(context).removeMessageImage();
                            },
                          ),
                        ),
                      )
                    ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.only(start: 5),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type here your message"),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              SocialCubit.get(context).getMessageImage();
                            },
                            icon: Icon(IconBroken.Image)),
                        Container(
                          height: 50,
                          child: MaterialButton(
                            minWidth: 1,
                            color: secondaryColor,
                            onPressed: () {
                              if (SocialCubit.get(context).messageImage ==
                                  null) {
                                SocialCubit.get(context)
                                    .sendMessage(
                                  text: textController.text,
                                  dateTime: DateTime.now().toString(),
                                  receiverId: model.uId,
                                )
                                    .then((value) {
                                  textController.text = "";
                                });
                              } else {
                                SocialCubit.get(context)
                                    .uploadMessageImage(
                                        text: textController.text,
                                        dateTime: DateTime.now().toString(),
                                        receiverId: model.uId)
                                    .then((value) {
                                  textController.text = "";
                                });
                              }
                            },
                            child: Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Column(
          children: [
            if (model.text != "")
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(10),
                        topStart: Radius.circular(10),
                        topEnd: Radius.circular(10))),
                child: Text(model.text!),
              ),
            if (model.messageImage != "")
              InkWell(
                onTap: () {
                  navigateTo(
                      context, MessageImageScreen(image: model.messageImage!));
                },
                child: Container(
                  width: 250,
                  height: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(model.messageImage!),
                      )),
                ),
              ),
          ],
        ),
      );
  Widget buildMyMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (model.text != "")
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(10),
                      bottomStart: Radius.circular(10),
                      topStart: Radius.circular(10),
                    )),
                child: Text(model.text!),
              ),
            if (model.messageImage != "")
              InkWell(
                onTap: () {
                  navigateTo(
                      context, MessageImageScreen(image: model.messageImage!));
                },
                child: Container(
                  width: 250,
                  height: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(model.messageImage!),
                      )),
                ),
              ),
          ],
        ),
      );
}
