import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/functions/storage_method.dart';
import 'package:instagram_flutter/models/posts.dart';
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

}