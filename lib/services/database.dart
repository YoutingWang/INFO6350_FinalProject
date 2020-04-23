import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/posts.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference itemCollection =
      Firestore.instance.collection('meinan-posts');

  Future updateUserData(
      String title,
      int price,
      String description,
      List<String> imageUrls,
      double latitude,
      double longitude,
      String address) async {
    return await itemCollection.document(uid).setData(
      {
        'title': title,
        'price': price,
        'description': description,
        'imageUrls': imageUrls,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      },
    );
  }

  //posts list from snapshot
  List<Post> _postListFormSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(
      (doc) {
        return Post(
          title: doc.data['title'] ?? '',
          price: doc.data['price'] ?? 0,
          description: doc.data['description'] ?? '',
          images: doc.data['imageUrls'].cast<String>() ?? [],
          latitude: doc.data['latitude'] ?? 0,
          longitude: doc.data['longitude'] ?? 0,
          address: doc.data['address'] ?? '',
        );
      },
    ).toList();
  }

  // get posts stream
  Stream<List<Post>> get posts {
    return itemCollection.snapshots().map(_postListFormSnapshot);
  }
}
