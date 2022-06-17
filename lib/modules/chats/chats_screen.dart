import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/cubit/social_cubit.dart';
import '../../layout/cubit/social_states.dart';
import '../../models/user_model.dart';
import '../../shard/component/component.dart';
import 'chat_details.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          var model = SocialCubit.get(context).users;

          return ConditionalBuilder(
            condition: model!.length > 0,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                builderUsersItem(model[index], context),
                            separatorBuilder: (context, index) => SizedBox(
                                  child: Divider(
                                    height: 0.1,
                                    color: Colors.grey,
                                  ),
                                ),
                            itemCount: model.length),
                      ),
                    ]),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget builderUsersItem(SocialUserModel model, context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ChatDetailsScreen(
              model: model,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(model.image!),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              model.name!,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            buildTextButton(
                function: () {
                  SocialCubit.get(context).deleteChat(model.uId);
                },
                title: "مسح الرسائل",
                context: context),
          ],
        ),
      ),
    );
  }
}
