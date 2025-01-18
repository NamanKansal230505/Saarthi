import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saarthi/constraints.dart';
import 'package:saarthi/screens/signin_page.dart';
import 'package:saarthi/widgets/my_text_button.dart';

import 'register_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
            child: Flexible(
                child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 90),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    'assets/images/team.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              "Enterprise team \n collaboration.",
              style: aHeadLine,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Bring together your files,your tools,projects and people. Including a new mobile and desktop  application.",
                style: aBodyText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 150),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(children: [
                Expanded(
                  child: MyTextButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    bgColor: Colors.white,
                    buttonName: "Register",
                    textColor: Colors.black87,
                  ),
                ),
                Expanded(
                  child: MyTextButton(
                    bgColor: Colors.transparent,
                    buttonName: "Sign In",
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SigninPage(),
                          ));
                      // Navigator.pushNamed(context, MyRoutes.homeRoute);
                    },
                    textColor: Colors.white,
                  ),
                )
              ]),
            ),
          ],
        ))),
      ),
    );
  }
}
