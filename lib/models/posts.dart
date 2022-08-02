import 'dart:typed_data';

class Posts{
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Posts({
       required this.caption,
       required this.uid,
       required this.username,
       required this.postId,
       required this.datePublished,
       required this.postUrl,
       required this.profImage,
       required this.likes
      });

  Map<String, dynamic> toJson(){
    return {
      'caption' : caption,
      'uid': uid,
      'username' : username,
      'postId' : postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profImage': profImage,
      'likes' : likes,
    };
  }

}