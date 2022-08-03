import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/functions/firestore_method.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/comment_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap,}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Column(
        children: [
          //header section
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),

                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.snap['username'], style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                ),

                IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context)=>Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete'
                          ].map((e) => InkWell(
                            onTap: (){},
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: Text(e),
                              ),
                          )).toList(),
                        ),
                      ));
                    },
                    icon: Icon(Icons.more_vert)
                )
              ],
            ),
          ),

          //image section
          GestureDetector(
            onDoubleTap: () async{
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network(widget.snap['postUrl'],fit: BoxFit.cover),
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isLikeAnimating? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: (){
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite, color: Colors.white, size: 121,),
                  ),
                )
              ]
            ),
          ),

          //like comment icon section
          Row(
            children: [
              LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async{
                      await FireStoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes']
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid) ?
                        Icon(FontAwesomeIcons.solidHeart, color: Colors.red,) :
                        Icon(FontAwesomeIcons.heart,)
                )
              ),
              IconButton(
                  onPressed: (){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> CommentScreen()),);
                  },
                  icon: Icon(FontAwesomeIcons.comment)
              ),
              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.paperPlane)),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
              ),

              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.bookmark)),
            ],
          ),

          //Caption and comments section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800 ),
                    child: Text('${widget.snap['likes'].length} likes', style: Theme.of(context).textTheme.bodyText2,)
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children:[
                        TextSpan(text: widget.snap['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${widget.snap['caption']}'),
                      ]
                    ),
                  )
                ),

                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                        'view all 200 comments',
                      style: TextStyle(fontSize: 15, color: secondaryColor),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMMd().format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 15, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
