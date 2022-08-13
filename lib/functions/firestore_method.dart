import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/functions/storage_method.dart';
import 'package:instagram_flutter/models/posts.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String caption,
      Uint8List file,
      String uid,
      String username,
      String profImage,

      ) async{
    String result = "Some error occurred! try again";
    try{
      //uploadImageToStorage is a function in the storage_method.dart file
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = Uuid().v1();

      Posts post = Posts(
          caption : caption,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      result = 'success';

    }
    catch(e){
      e.toString();
    }

    return result;
  }

  //function to add uid to the likes array if it is no there and remove if its already there
  Future<void> likePost(String postId, String uid, List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(e){
      print(e.toString());
    }
  }


  //function to add Comment in the comments subCollection
  Future<void> postComment(String postId, String text, String uid, String name, String profilePic, BuildContext context) async{
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name' : name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      }
      else{
        showSnackBar('comment is empty', context);
      }
    }
    catch(e){
      print(e.toString());
    }
  }


  //function to delete the post
  Future<void> deletePost(String postId, BuildContext context) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }
    catch(e){
      showSnackBar('some error occurred', context);
    }
  }


  //function to follow User

  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

}