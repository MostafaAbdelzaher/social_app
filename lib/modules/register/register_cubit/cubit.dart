import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/register/register_cubit/states.dart';

import '../../../models/user_model.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value);
      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,
      );
    }).catchError((onError) {
      emit(SocialRegisterErrorState());
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    SocialUserModel? model = SocialUserModel(
        cover:
            'https://image.freepik.com/free-photo/stunned-bearded-young-man-shows-unbelievable-presentation_273609-40654.jpg',
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        image:
            'https://image.freepik.com/free-photo/stunned-bearded-young-man-shows-unbelievable-presentation_273609-40654.jpg',
        bio: "Write your bio..",
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .set(model.toMap()!)
        .then((value) {
      emit(SocialCreateSuccessState(uId));
    }).catchError((onError) {
      emit(SocialCreateErrorState(onError.toString()));
    });
  }

  IconData suffix = Icons.visibility;
  bool isPassWord = true;

  void changVisibilityPassWord() {
    isPassWord = !isPassWord;
    suffix = isPassWord ? Icons.visibility : Icons.visibility_off_outlined;
    emit(ChangRegisterVisibilityPassWord());
  }
}
