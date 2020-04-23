import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';
import '../../shared/customContainer.dart';
import '../../services/database.dart';
import '../../models/user.dart';
import '../../theme/light_color.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();

  String _currentTitle;
  int _currentPrice;
  String _currentDescription;
  double _currentLatitude;
  double _currentLongitude;
  String _currentAddress;
  List<String> _imageUrls = List<String>();
  List<Asset> _images = List<Asset>();
  Location _currentLocation = Location();
  LocationData _currentData;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              color: Colors.white,
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    backgroundColor: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _titleField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Title cannot be empty' : null,
            onChanged: (val) {
              setState(() => _currentTitle = val);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _priceField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Price cannot be empty' : null,
            onChanged: (val) {
              setState(() => _currentPrice = int.parse(val));
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _descriptionField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val) =>
                val.isEmpty ? 'Description cannot be empty' : null,
            onChanged: (val) {
              setState(() => _currentDescription = val);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _addressField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _currentAddress == null ? '' : _currentAddress,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return _images.length == 0
        ? SizedBox(
            height: 20.0,
          )
        : Container(
            child: SizedBox(
              height: 130,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: List.generate(
                  _images.length,
                  (index) {
                    Asset asset = _images[index];
                    return AssetThumb(
                      asset: asset,
                      width: 150,
                      height: 150,
                    );
                  },
                ),
              ),
            ),
          );
  }

  Widget _customButton(String hint) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2)
        ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [LightColor.lightOrange, LightColor.darkOrange]),
      ),
      child: Text(
        hint,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  void _postNewItemSnackBar(BuildContext context) {
    print('postNewItemSnackbar');
    final snackBar = SnackBar(
      content: new Text(
          "Added new post successfully! You can return to home page to check it now."),
      duration: Duration(minutes: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _getImageList() async {
    try {
      var resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
      );
      setState(() {
        _images = resultList;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _postImage(Asset imageFile) async {
    print('postImage');
    ByteData byteData = await imageFile.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    _imageUrls.add(imageUrl.toString());
  }

  Future _getAddress() async {
    try {
      _currentData = await _currentLocation.getLocation();
      Coordinates coordinates =
          Coordinates(_currentData.latitude, _currentData.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      _currentLatitude = coordinates.latitude;
      _currentLongitude = coordinates.longitude;
      var first = address.first;
      _currentAddress = first.addressLine;
    } catch (e) {
      print(e);
    }
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
    User user = Provider.of<User>(context);
    return Scaffold(
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 80),
                              _titleField(),
                              _priceField(),
                              _descriptionField(),
                              _buildGridView(),
                              RaisedButton(
                                color: Colors.white,
                                elevation: 0.0,
                                child: _customButton('Select Photos'),
                                onPressed: () {
                                  _getImageList();
                                },
                              ),
                              _addressField(),
                              Container(
                                height: 150,
                                child: _currentLatitude == null &&
                                        _currentLongitude == null
                                    ? _map(37.4, -122)
                                    : _map(_currentLatitude, _currentLongitude),
                              ),
                              SizedBox(height: 20.0),
                              RaisedButton(
                                color: Colors.white,
                                elevation: 0.0,
                                child: _customButton('Get Address'),
                                onPressed: () async {
                                  await _getAddress();
                                  setState(() {
                                    print('update successfully!');
                                  });
                                },
                              ),
                              SizedBox(height: 30.0),
                              RaisedButton(
                                color: Colors.white,
                                elevation: 0.0,
                                child: _customButton('Post'),
                                onPressed: () async {
                                  print('post successfully1');
                                  if (_formKey.currentState.validate()) {
                                    //add a snack bar to show user add new post successfully
                                    _postNewItemSnackBar(context);
                                    print('post successfully2');
                                    for (Asset a in _images) {
                                      await _postImage(a);
                                    }
                                    _getAddress();
                                    await DatabaseService(uid: user.uid)
                                        .updateUserData(
                                      _currentTitle,
                                      _currentPrice,
                                      _currentDescription,
                                      _imageUrls,
                                      _currentLatitude,
                                      _currentLongitude,
                                      _currentAddress,
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: CustomContainer())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
