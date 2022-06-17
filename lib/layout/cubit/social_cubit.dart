import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/layout/cubit/social_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/comment_model.dart';
import '../../models/message_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../shard/network/local/cache_helper.dart';
import '../../shard/styles/icon_broken.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userModel;

  getUserData() {
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance
        .collection('user')
        .doc(
          CacheHelper.getData(key: "uId"),
        )
        .get()
        .then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      print(userModel!.uId);
      emit(SocialGetUserSuccessStates());
    }).catchError((error) {
      print(error);
      emit(SocialGetUserErrorStates(error.toString()));
    });
  }

  List<Widget> screen = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    SettingsScreen()
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'New post',
    'Settings',
  ];
  List<BottomNavigationBarItem> bottomList = [
    const BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chat'),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Setting), label: 'settings'),
  ];

  int currentIndex = 0;
  changeBottomNav(index) {
    if (index == 0) getAllUser();

    if (index == 2) {
      emit(SocialNewPostStates());
    } else {
      currentIndex = index;
    }
    emit(ChangeBottomNavStates());
  }

  File? profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorStates());
    }
  }

  Future<void> getProfileImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorStates());
    }
  }

  File? coverImage;
  Future<void> getCoverImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorStates());
    }
  }

  Future<void> getCoverImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorStates());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("User/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((onError) {
        emit(SocialUploadProfileImagedErrorStates());
      });
    }).catchError((onError) {
      emit(SocialUploadProfileImagedErrorStates());
    });
  }

  void uploadCoverImage({
    String? name,
    String? phone,
    String? bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("User/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((onError) {
        print('$onError getDownloadURL');
        emit(SocialUploadCoverImagedErrorStates());
      }).catchError((onError) {
        print('$onError uploadCoverImage');

        emit(SocialUploadCoverImagedErrorStates());
      });
    });
  }

  void updateUser({
    String? name,
    String? phone,
    String? bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUserUpdateLoadingState());

    SocialUserModel model = SocialUserModel(
        name: name,
        phone: phone,
        bio: bio,
        isEmailVerified: userModel!.isEmailVerified,
        uId: userModel!.uId,
        email: userModel!.email,
        cover: cover ?? userModel!.cover,
        image: image ?? userModel!.image);

    FirebaseFirestore.instance
        .collection("user")
        .doc(userModel!.uId)
        .update(model.toMap()!)
        .then((value) {
      getUserData();
    }).catchError((onError) {
      emit(SocialUserUpdateErrorStates());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorStates());
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("User/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        CreatePost(dateTime: dateTime, text: text, PostImage: value);
      }).catchError((onError) {
        emit(SocialUploadCoverImagedErrorStates());
      }).catchError((onError) {
        emit(SocialUploadCoverImagedErrorStates());
      });
    });
  }

  void CreatePost({
    required String text,
    required String dateTime,
    String? PostImage,
  }) {
    emit(SocialCreatePostLoadingStates());
    PostModel model = PostModel(
        name: userModel!.name,
        uId: userModel!.uId,
        image: userModel!.image,
        dateTime: dateTime,
        postImage: PostImage ?? '',
        Text: text);
    FirebaseFirestore.instance
        .collection("Post")
        .add(model.toMap()!)
        .then((value) {
      getPosts();
      emit(SocialCreatePostSuccessStates());
    }).catchError((onError) {
      emit(SocialCreatePostErrorStates());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  bool? boolLikes;
  List<int> commentCount = [];
  void getPosts() {
    FirebaseFirestore.instance.collection('Post').get().then((value) {
      value.docs.forEach((element) {
        posts = [];
        postsId = [];
        likes = [];
        commentCount = [];
        element.reference.collection('Likes').get().then((value) {
          likes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          element.reference.collection("comments").get().then((value) {
            commentCount.add(value.docs.length);
            emit(SocialGetPostsStates());
          });
          postsId.add(element.id);
        }).catchError((onError) {});
      });
    }).catchError((onError) {
      emit(SocialGetPostsErrorStates(onError.toString()));
    });
  }

  void likePosts(String postId) {
    FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('Likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      getPosts();
      emit(SocialPostLikeSuccessStates());
    }).catchError((error) {
      emit(SocialPostLikeErrorStates(error));
    });
  }

  void createComment({
    required String postId,
    required String commentText,
    String? commentImage,
  }) {
    CommentModel model = CommentModel(
        dateTime: DateTime.now().toString(),
        name: userModel!.name,
        image: userModel!.image,
        uId: userModel!.uId,
        commentImage: commentImage ?? '',
        commentText: commentText,
        postId: postId);

    FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('comments')
        .add(model.toMap()!)
        .then((value) {
      emit(SocialPostCommentSuccessStates());
      getPosts();
    }).catchError((error) {
      emit(SocialPostCommentErrorStates(error));
    });
  }

  File? commentImage;
  Future<void> getCommentImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorStates());
    }
  }

  Future<void> uploadCommentImage({
    required String postId,
    required String commentText,
  }) async {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("User/${Uri.file(commentImage!.path).pathSegments.last}")
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createComment(
          postId: postId,
          commentText: commentText,
          commentImage: value,
        );
        emit(SocialUploadCommentImagedSuccessStates());
        getPosts();
      }).catchError((onError) {
        emit(SocialUploadCommentImagedErrorStates());
      }).catchError((onError) {
        emit(SocialUploadCommentImagedErrorStates());
      });
    });
  }

  void removeCommentImage() {
    commentImage = null;
    emit(SocialRemoveCommentImageStates());
  }

  List<CommentModel> comments = [];
  List<String> commentId = [];

  void getComments(postId) {
    FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        commentId.add(element.id);

        emit(SocialGetCommentSuccessStates());
      });
    });
  }

  void deletePost(String? postId) {
    FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .delete()
        .then((value) {
      emit(DeletePostSuccessState());
    }).catchError((error) {
      print('error delete post');
    });
  }

  void deleteComment(String? postId, String postID) {
    FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection("comments")
        .doc(postID)
        .delete()
        .then((value) {
      getComments(postId);
      // emit(DeleteCommentSuccessState());
    }).catchError((error) {
      print('error delete post');
      emit(DeleteCommentErrorState());
    });
  }

  List<SocialUserModel>? users = [];
  void getAllUser() {
    if (users!.length == 0)
      FirebaseFirestore.instance.collection("user").get().then((value) {
        value.docs.forEach((element) {
          if (element.data()["uId"] != userModel!.uId)
            users!.add(SocialUserModel.fromJson(element.data()));
          emit(SocialGetAllUserSuccessStates());
        });
      }).catchError((onError) {
        emit(SocialGetAllUserErrorStates());
      });
  }

  Future<void> sendMessage({
    String? receiverId,
    String? dateTime,
    String? text,
    String? messageImage,
  }) async {
    MessageModel model = MessageModel(
        dateTime: dateTime,
        text: text,
        messageImage: messageImage ?? "",
        receiverId: receiverId,
        senderId: userModel!.uId);
    FirebaseFirestore.instance
        .collection("user")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("message")
        .add(model.toMap()!)
        .then((value) {
      emit(
        SocialSendMessageSuccessStates(),
      );
    }).catchError((onError) {
      emit(
        SocialSendMessageErrorStates(),
      );
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(receiverId)
        .collection("chats")
        .doc(userModel!.uId)
        .collection("message")
        .add(model.toMap()!)
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((onError) {
      emit(SocialSendMessageErrorStates());
    });
  }

  void deleteChat(String? receiverId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .delete()
        .then((value) {
      emit(SocialDeleteChatSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  List<MessageModel> getMessageModel = [];

  void getMessage(String receiverId) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("message")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      getMessageModel = [];

      event.docs.forEach((element) {
        getMessageModel.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessStates());
    });
  }

  File? messageImage;
  Future<void> getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialMessageImagePickedSuccessStates());
    } else {
      print('No Image Selected');
      emit(SocialMessageImagePickedErrorStates());
    }
  }

  Future<void> uploadMessageImage({
    String? receiverId,
    String? dateTime,
    String? text,
  }) async {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("User/${Uri.file(messageImage!.path).pathSegments.last}")
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            receiverId: receiverId,
            dateTime: dateTime,
            text: text,
            messageImage: value);
      }).catchError((onError) {
        emit(SocialUploadMessageImagedErrorStates());
      }).catchError((onError) {
        emit(SocialUploadMessageImagedErrorStates());
      });
    });
  }

  void removeMessageImage() {
    messageImage = null;
    emit(SocialRemoveMessageImageStates());
  }
}
