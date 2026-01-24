class SignUpState {}
class SignUpInatialState extends SignUpState{}
class SignUpLoadingState extends SignUpState{}
class SignUpSuccessState extends SignUpState{}
class SignUpErrorState extends SignUpState{
  String em;
  SignUpErrorState(this.em);

}
