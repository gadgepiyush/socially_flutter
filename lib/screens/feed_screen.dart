import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          'Socially',
          style: GoogleFonts.lobsterTwo(fontSize: 32 ),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.paperPlane))
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index)=>  PostCard(
                snap : snapshot.data!.docs[index].data(),
              )
          );
        },
      ),
    );
  }
}
