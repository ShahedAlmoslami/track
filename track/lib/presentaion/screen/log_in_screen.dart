import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track/core/const/txt.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/logic/login/cubit.dart';
import 'package:track/logic/login/state.dart';
import 'package:track/presentaion/screen/home_screen.dart';
import 'package:track/presentaion/screen/sign_up_screen.dart';
import 'package:track/presentaion/widgets/button_style.dart';
import 'package:track/presentaion/widgets/text_form_field_widget.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("User cancelled Google sign-in");
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (state is LoginErrorState) {
              final snackBar = SnackBar(
                content: Text(state.em),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoadingState;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          hintText: Tex.email,
                          controller: emailController,
                        ),
                        SizedBox(height: 10),
                        TextFormFieldWidget(
                          hintText: Tex.pass,
                          controller: passController,
                        ),
                        SizedBox(height: 200),
                        IgnorePointer(
                          ignoring: isLoading,
                          child: InkWell(
                            onTap: () {
                              context.read<LoginCubit>().logIn(
                                emailController.text,
                                passController.text,
                              );
                            },
                            child: MyButtonStyle(
                              buttonHight: 60,
                              buttonWidth: 329,
                              buttonText: Tex.Login,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            signInWithGoogle();
                          },
                          child: MyButtonStyle(
                            buttonHight: 60,
                            buttonWidth: 329,
                            buttonText: Tex.continueWithGoogle,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: ColorManager.prymaryColor,
                                height: 5,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Or',
                              style: TextStyle(
                                color: ColorManager.prymaryColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: ColorManager.prymaryColor,
                                height: 5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Tex.dontHaveAcc,
                              style: TextStyle(
                                color: ColorManager.prymaryColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                                
                              },
                              child: const Text('Sign Up',style: TextStyle(color:ColorManager.prymaryColor ),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
