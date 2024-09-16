
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
