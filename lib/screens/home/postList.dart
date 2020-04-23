import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/posts.dart';
import '../../screens/home/postDetail.dart';
import '../../screens/home/itemDetail.dart';
import '../../shared/loading.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context);

    if (posts != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
        child: ListView.builder(
          itemCount: posts.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                //click on the listView to itemDetail page show more item details
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetail(post: posts[index]),
                    ),
                  );
                },
                // display brief detail of post in the Home page
                child: PostDetail(post: posts[index]),
              ),
            );
          },
        ),
      );
    } else {
      return Loading();
    }
  }
}
