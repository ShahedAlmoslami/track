import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track/logic/sign_up/state.dart';

class SignUpCubit extends Cubit<SignUpState>{
  SignUpCubit():super (SignUpInatialState());
  Future signUp (String email,String password)async{
    try{
      emit(SignUpLoadingState());
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password:password );
     final SharedPreferences prefes= await SharedPreferences.getInstance();
     prefes.setBool("isSigedUp",true);
     emit(SignUpSuccessState());
    }
    catch(e){
      emit(SignUpErrorState(e.toString()));
    }
  }

}