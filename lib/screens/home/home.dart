import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'postList.dart';
import '../authenticate/welcomePage.dart';
import '../../services/auth.dart';
import '../../theme/light_color.dart';
import '../../services/database.dart';
import '../../screens/home/postList.dart';
import '../../models/posts.dart';
import '../../screens/home/newPost.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Container(
        height: 100,
        width: width,
        decoration: BoxDecoration(
          color: LightColor.orange,
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 8,
                right: -120,
                child: _circularContainer(300, LightColor.lightOrange2)),
            Positioned(
                top: -50,
                left: -65,
                child: _circularContainer(width * .5, LightColor.darkOrange)),
            Positioned(
                top: -200,
                right: -30,
                child: _circularContainer(width * .7, Colors.transparent,
                    borderColor: Colors.white38)),
            Positioned(
              top: 50,
              left: -5,
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "HyperGarageSale",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 0,
              child: FlatButton.icon(
                icon: Icon(Icons.account_circle),
                label: Text(
                  'Log Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamProvider<List<Post>>.value(
            value: DatabaseService().posts,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      _header(context),
                      PostList(),
                    ],
                  ),
                ),
              ),
              // create a floating button to navigate to the new post page
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewPost()));
                },
                icon: Icon(Icons.add),
                label: Text('NEW POST'),
                backgroundColor: LightColor.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
