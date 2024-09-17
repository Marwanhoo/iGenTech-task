
abstract class AppState {}

class AppInitial extends AppState {}



class GenderChangedState extends AppState {
  final String gender;
  GenderChangedState(this.gender);
}

class DateChangedState extends AppState {
  final DateTime birthdate;
  DateChangedState(this.birthdate);
}


class ChangePasswordVisibilityState extends AppState {}


class LoadingState extends AppState {}

class ProfileLoadedState extends AppState {
  final List<Map> profileData;

  ProfileLoadedState(this.profileData);
}

class EmptyProfileState extends AppState {}

class ProfileErrorState extends AppState {
  final String error;

  ProfileErrorState(this.error);
}







class FormSubmittingState extends AppState {}

class FormSubmittedState extends AppState {}

class FormErrorState extends AppState {
  final String message;
  FormErrorState(this.message);
}

