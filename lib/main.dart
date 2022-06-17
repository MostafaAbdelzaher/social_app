import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/login/login_screen.dart';
import 'package:social/shard/bloc_observer.dart';
import 'package:social/shard/component/constants.dart';
import 'package:social/shard/network/local/cache_helper.dart';
import 'package:social/shard/styles/themes.dart';

import 'layout/cubit/social_cubit.dart';
import 'layout/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  uId = CacheHelper.getData(key: "uId");
  Widget widget;
  if (uId != null) {
    widget = SocialAppLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getPosts()
        ..getAllUser(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false, theme: them, home: startWidget),
    );
  }
}
