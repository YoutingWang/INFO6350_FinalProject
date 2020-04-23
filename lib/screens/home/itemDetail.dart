import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'imageDetail.dart';
import '../../models/posts.dart';
import '../../theme/light_color.dart';

class ItemDetail extends StatelessWidget {
  final Post post;

  ItemDetail({this.post});

  Widget buildGridView(context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      children: List.generate(
        post.images.length,
        (index) {
          return GestureDetector(
            child: Hero(
              tag: post.images[index],
              child: new Container(
                child: CachedNetworkImage(
                  imageUrl: post.images[index],
                  placeholder: (context, url) => new Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImageDetail(post.images[index], post.images[index])));
            },
          );
        },
      ),
    );
  }

  Widget _map(double latitude, double longitude) {
    GoogleMapController _map;

    Set<Marker> _markers() {
      return <Marker>[
        Marker(
          markerId: MarkerId('Home'),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarker,
        )
      ].toSet();
    }

    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers(),
      initialCameraPosition:
          CameraPosition(target: LatLng(latitude, longitude), zoom: 11.0),
      onMapCreated: (GoogleMapController googleMapController) {
        _map = googleMapController;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.orange,
        elevation: 10.0,
        title:
            Text('Item Detail', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                'Title: ' + post.title,
                                style: TextStyle(
                                    color: LightColor.darkOrange,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                'Price: ' + ' \$${post.price}',
                                style: TextStyle(
                                    color: LightColor.darkpurple,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                'Description: ' + post.description,
                                style: TextStyle(
                                    color: LightColor.darkOrange,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          post.images.length == 0
                              ? SizedBox(
                                  height: 20.0,
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      'Related Images: ',
                                      style: TextStyle(
                                          color: LightColor.darkpurple,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 20.0,
                          ),
                          post.images.length == 0
                              ? new Text("User didn't upload images.")
                              : buildGridView(context),
                          SizedBox(
                            height: 20.0,
                          ),
                          post.address == null
                              ? new Text("User didn't upload address.")
                              : Container(
                                  height: 150,
                                  child: _map(post.latitude, post.longitude),
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                post.address == null
                                    ? ''
                                    : 'Garage Location:' + post.address,
                                style: TextStyle(
                                  color: LightColor.darkpurple,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
