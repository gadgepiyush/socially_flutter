import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShowUsers = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(
            labelText: 'search for user'
          ),

          controller: searchController,

          onFieldSubmitted: (String _){
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),

      body: isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: searchController.text).get(),

        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl'])
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username'])
                );
              });
        },
      ) : Text('posts')
    );
  }
}
