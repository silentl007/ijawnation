import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ijawnation/blocs/user_bloc.dart';
import 'package:ijawnation/pages/home.dart';
//import 'package:ijawnation/pages/welcome.dart';
import 'package:ijawnation/utils/next_screen.dart';
import '../config/config.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  Future _afterSplash() async {
    final UserBloc ub = context.read<UserBloc>();
    Future.delayed(Duration(milliseconds: 7000)).then((value) {
      ub.isSignedIn == true || ub.guestUser == true
          ? _gotoHomePage()
          : _gotoWelcomePage();
    });
  }

  void _gotoHomePage() {
    nextScreenReplace(context, HomePage());
  }

  void _gotoWelcomePage() {
    nextScreenReplace(context, HomePage());
  }

  @override
  void initState() {
    _afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E0F4F),
      body: Center(
        child: Image(
          height: 295,
          width: 200,
          image: AssetImage(Config.splash),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}