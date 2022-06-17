abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates {
  SocialRegisterErrorState();
}

class SocialCreateSuccessState extends SocialRegisterStates {
  final String uId;

  SocialCreateSuccessState(this.uId);
}

class SocialCreateErrorState extends SocialRegisterStates {
  final error;

  SocialCreateErrorState(this.error);
}

class ChangRegisterVisibilityPassWord extends SocialRegisterStates {}
