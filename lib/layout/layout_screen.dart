import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/new_post/new_post_screen.dart';
import '../shard/component/component.dart';
import '../shard/component/constants.dart';
import '../shard/styles/icon_broken.dart';
import 'cubit/social_cubit.dart';
import 'cubit/social_states.dart';

class SocialAppLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostStates) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: PrimaryColor,
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.bottomList,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
          ),
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: PrimaryColor,
                statusBarIconBrightness: Brightness.light),
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(IconBroken.Notification),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(IconBroken.Search),
                color: Colors.white,
              ),
            ],
          ),
          body: state is SocialGetUserLoadingStates ||
                  SocialCubit.get(context).userModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : cubit.screen[cubit.currentIndex],
        );
      },
    );
  }
}
