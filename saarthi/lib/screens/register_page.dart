import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saarthi/rootnavigator.dart';
import '../constraints.dart';
import '../widgets/my_passwordfield.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_textfield.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: (){},

      ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: aHeadLine,
                          ),
                          Text(
                            "Create new account to get started.",
                            style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500,color:Colors.black),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          MyTextField(
                            hintText: 'Name',
                            inputType: TextInputType.name,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyTextField(
                            hintText: 'Phone',
                            inputType: TextInputType.phone,
                          ),
                          MyPasswordField(
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: aBodyText,
                        ),
                        Text(
                          "Sign In",
                          style: aBodyText.copyWith(
                            color: Color(0xff132137),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Spacer(),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: () {
                         Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RootNavigator(),
                          ));
                      },
                      bgColor: Color(0xff132137),
                      textColor: Colors.white,
                    ),
                    SizedBox(height:40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}