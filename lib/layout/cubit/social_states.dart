import '../../models/user_model.dart';

abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

class SocialGetUserLoadingStates extends SocialStates {}

class SocialGetUserSuccessStates extends SocialStates {
  SocialUserModel? socialUserModel;
}

class SocialGetUserErrorStates extends SocialStates {
  final String error;

  SocialGetUserErrorStates(this.error);
}

class SocialGetAllUserSuccessStates extends SocialStates {}

class SocialGetAllUserErrorStates extends SocialStates {}

class SocialGePostsLoadingStates extends SocialStates {}

class SocialGePostsSuccessStates extends SocialStates {
  SocialUserModel? socialUserModel;
}

class SocialGetPostsErrorStates extends SocialStates {
  final String error;

  SocialGetPostsErrorStates(this.error);
}

class ChangeBottomNavStates extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class DeleteCommentSuccessState extends SocialStates {}

class DeleteCommentErrorState extends SocialStates {}

class SocialNewPostStates extends SocialStates {}

class SocialGetAllUserStates extends SocialStates {}

class SocialProfileImagePickedSuccessStates extends SocialStates {}

class SocialProfileImagePickedErrorStates extends SocialStates {}

class SocialCoverImagePickedSuccessStates extends SocialStates {}

class SocialCoverImagePickedErrorStates extends SocialStates {}

class SocialUploadCoverImagedSuccessStates extends SocialStates {}

class SocialUploadCoverImagedErrorStates extends SocialStates {}

class SocialUploadProfileImagedErrorStates extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUploadCommentImagedErrorStates extends SocialStates {}

class SocialUploadCommentImagedSuccessStates extends SocialStates {}

class SocialUserUpdateErrorStates extends SocialStates {}

class SocialUserUpdateLoadingStates extends SocialStates {}

class SocialCreatePostSuccessStates extends SocialStates {}

class SocialCreatePostErrorStates extends SocialStates {}

class SocialCreatePostLoadingStates extends SocialStates {}

class SocialPostImagePickedSuccessStates extends SocialStates {}

class SocialPostImagePickedErrorStates extends SocialStates {}

class SocialRemovePostImageStates extends SocialStates {}

class SocialRemoveCommentImageStates extends SocialStates {}

class SocialPostLikeSuccessStates extends SocialStates {}

class SocialPostCommentSuccessStates extends SocialStates {}

class SocialGetCommentLoadingStates extends SocialStates {}

class SocialGetCommentSuccessStates extends SocialStates {}

class SocialGetCommentErrorStates extends SocialStates {}

class SocialPostCommentErrorStates extends SocialStates {
  final String error;
  SocialPostCommentErrorStates(this.error);
}

class SocialPostLikeErrorStates extends SocialStates {
  final String error;
  SocialPostLikeErrorStates(this.error);
}

class SocialSendMessageSuccessStates extends SocialStates {}

class SocialSendMessageErrorStates extends SocialStates {}

class SocialGetMessageSuccessStates extends SocialStates {}

class SocialGetMessageErrorStates extends SocialStates {}

class SocialMessageImagePickedSuccessStates extends SocialStates {}

class SocialMessageImagePickedErrorStates extends SocialStates {}

class SocialUploadMessageImagedErrorStates extends SocialStates {}

class SocialUploadMessageImagedSuccessStates extends SocialStates {}

class SocialRemoveMessageImageStates extends SocialStates {}

class SocialGetPostsStates extends SocialStates {}

class SocialDeleteChatSuccessState extends SocialStates {}

class SocialDeleteChatErrorState extends SocialStates {}
