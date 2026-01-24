abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminSuccess extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
