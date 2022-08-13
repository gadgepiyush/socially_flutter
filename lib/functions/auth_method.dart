import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/functions/storage_method.dart';
import 'package:instagram_flutter/models/user.dart' as models;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return models.User.fromSnap(snap);
  }

  //sign-up _userName
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async{

    String result = 'Some error occured';

    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        models.User user = models.User(
          uid: cred.user!.uid,
          email: email,
          username: username,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl, 
        );

        //add created user in the database
         await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }

      result = 'success';
    } 
    catch(error){
      result = error.toString();
      print("exception ala re bhau $result");
    }
    

    return result;
  }


  //method to login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async{
    String result = "Some error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        //login user with the credentials
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        result = 'success';
      }
    }
    catch(error){
      result = error.toString();
      print("exception ala re bhau $result");
    }

    return result;
  }

  //function to signOut User
  Future<void> signOut() async {
    await _auth.signOut();
  }

}