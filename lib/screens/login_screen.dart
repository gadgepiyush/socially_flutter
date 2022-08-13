import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_flutter/functions/auth_method.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/reponsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:instagram_flutter/utils/global_var.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_feild_input.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  //method to simply call the login user method from the AuthMethod class
  void loginUserRunner() async{
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().loginUser(email: _email.text, password: _password.text);

    setState(() {
      _isLoading = false;
    });

    if(result != 'success'){
      showSnackBar(result, context);
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(), 
            mobileScreenLayout: MobileScreenLayout()
          )
        ) 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize ?
            const EdgeInsets.symmetric(horizontal: 32) :
            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3) ,

            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 2, child: Container(),),
      
                Text(
                  'Socially',
                  style: GoogleFonts.lobsterTwo(fontSize: 64),
                ),
      
                const SizedBox(height: 64,
                ),
      
                TextFeildInput(
                    textEditingController: _email,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress
                ),
      
                const SizedBox(height: 25,),
      
               TextFeildInput(
                    textEditingController: _password,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.visiblePassword,
                    isPassWord: true,
                ),
      
                const SizedBox(height: 25,),
      
                InkWell(
                  onTap: (){
                    print("start");
                    loginUserRunner();
                    print("end");
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      color: Colors.blue,
                    ),
                    child: !_isLoading ? const Text("Log in") :
                     const CupertinoActivityIndicator(color: primaryColor,),
                  ),
                ),
      
                Flexible( flex: 2,child: Container(),),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have an account? ")
      
                    ),
      
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Sign up.",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ),
                  ]
                ),
              ],
            )
          ),
      ),
    );
  }
}
