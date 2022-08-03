import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/utils/colors.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comments')
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(right: 8, left: 8),

          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                //backgroundImage: NetworkImage("aa"),
                backgroundColor: Colors.white,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Comment as username'
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text('Post', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
