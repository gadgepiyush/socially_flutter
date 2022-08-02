import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/functions/auth_method.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/reponsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_feild_input.dart';
import 'dart:typed_data';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _email.dispose();
    _password.dispose();
    _bio.dispose();
    _userName.dispose();
  }

  //method to select image and show it in the CircleAvatar
  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  //method to simply call the signUpUser method from AuthMethod class
  void signUpUserRunner() async{
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().signUpUser(
      email: _email.text, 
      password: _password.text, 
      username: _userName.text, 
      bio: _bio.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if(result != 'success') {
      showSnackBar(result, context);
    } 
    else{
      Navigator.of(context).pushReplacement( 
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(), 
              mobileScreenLayout: MobileScreenLayout(),
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Flexible(flex: 2,child: Container(),),
               
                Text(
                  'Socially',
                  style: GoogleFonts.lobsterTwo(fontSize: 64),
                ),

                const SizedBox(height: 60,),

                Stack(
                  children: [
                    _image !=null ? 
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                    : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage('https://wallpaperaccess.com/full/1909531.jpg'),
                    ),

                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: (){selectImage();},
                          icon: const Icon(Icons.add_a_photo,)
                      )
                    )
                  ],
                ),

                const SizedBox(height: 25,),

                TextFeildInput(
                  textEditingController: _userName,
                  hintText: 'Enter your name', 
                  textInputType: TextInputType.text
                ),

                const SizedBox(height: 25,),

                TextFeildInput(
                  textEditingController: _email,
                  hintText: 'Enter your email', 
                  textInputType: TextInputType.emailAddress
                ),

                const SizedBox(height: 25,),

                TextFeildInput(
                  textEditingController: _password, 
                  hintText: 'Enter a password', 
                  textInputType: TextInputType.visiblePassword,
                  isPassWord: true,
                ),
                
                const SizedBox(height: 25,),

                TextFeildInput(
                  textEditingController: _bio,
                  hintText: 'Enter your bio', 
                  textInputType: TextInputType.text
                ),


                const SizedBox(height: 25,),

                InkWell(
                  onTap: (){
                    //this method simply calls the Auth classes signUpUser Method
                    signUpUserRunner();
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
                    child: !_isLoading ? Text("Sign up") :
                     const CupertinoActivityIndicator(color: primaryColor ),
                  ),
                ),

              ],
            ),
        )
      ),
    );
  }
}