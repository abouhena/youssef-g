
import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/screen/layout_screen.dart';
import 'package:tourism_app/screen/register_screen.dart';
import 'package:tourism_app/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: Column(
                    children: [
                  Image.asset(
                    'assets/image/logo.jpg',
                    height: 150,
                    width: 150,
                    fit:  BoxFit.cover,
                  ),
                  const SizedBox(height: 28),

                  CustomTextFormField(
                      controller: emailController,
                      hintText: "UserName",
                      textInputType:
                      TextInputType.emailAddress,
                      prefix: Icon(Icons.email ,color : Color(0xffFFBB2B)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return  "Please enter User Name";
                        }
                        return null;
                      },
                      contentPadding: EdgeInsets.all(15)),

                  SizedBox(height: 20),

                  CustomTextFormField(
                      controller: passwordController,
                      hintText: "Password",
                      textInputType: TextInputType.text,
                      obscureText: true,
                      prefix: Icon(Icons.lock,color : Color(0xffFFBB2B)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                      contentPadding: EdgeInsets.all(15)),

                     const SizedBox(height: 25),

                      BlocConsumer<AppCubit, AppState>(
                          builder: (context,state){
                            var cubit = AppCubit.get(context);

                        return (state is LoadingLoginState)?
                        const CircularProgressIndicator():
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffFFBB2B))
                          ),
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              cubit.login(
                                email: emailController.text,
                                password: passwordController.text
                              );
                            }
                          },
                          child: const Text(
                            'Sign in',
                            style:
                            TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }, listener: (context,state){
                            if(state is SuccessLoginState){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                return LayoutScreen();
                              }));
                            }else if(state is ErrorLoginState){
                              Fluttertoast.showToast(
                                msg: 'Please Enter Vaild UserName and Password',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.TOP,
                                fontSize: 18,
                                textColor: Colors.white,
                              );
                            }

                      }),



                  SizedBox(height: 18),




                      GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RegisterView();
                        }));
                      },
                      child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text:
                                "Dont have an account",
                                style: TextStyle(
                                  color:  Color(0xffFFBB2B),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),),
                            TextSpan(text: " "),
                            TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  color:Color(0xffFFBB2B),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),)
                          ]),
                          textAlign: TextAlign.left)),
                  SizedBox(height: 5)
                ]))));
  }

}
