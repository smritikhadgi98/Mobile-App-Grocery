import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/category_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
    try{
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    }catch(e){
      rethrow;
    }
  }

  List<CategoryModel> makeCategory(){
    return [
      CategoryModel(categoryName: "Vegetables", status: "active", imageUrl: "https://media.istockphoto.com/id/1409236261/photo/healthy-food-healthy-eating-background-fruit-vegetable-berry-vegetarian-eating-superfood.jpg?s=1024x1024&w=is&k=20&c=ZVp7_qM1hRjKR-nfx3u_L7Mb16og4S4QwqYxUtWiM8c="),
      CategoryModel(categoryName: "Fruits", status: "active", imageUrl: "https://media.istockphoto.com/id/529664572/photo/fruit-background.jpg?s=612x612&w=0&k=20&c=K7V0rVCGj8tvluXDqxJgu0AdMKF8axP0A15P-8Ksh3I="),
      CategoryModel(categoryName: "Staple", status: "active", imageUrl: "https://media.istockphoto.com/id/611609590/photo/varieties-of-grains-seeds-and-raw-quino.jpg?s=612x612&w=0&k=20&c=jjTr1X7bvFeuJ6cyDchpLxS3jd8YDtswBxNkJwqwm_A="),
      CategoryModel(categoryName: "Spice Mixes", status: "active", imageUrl: "https://media.istockphoto.com/id/477756915/photo/seamless-texture-with-spices-and-herbs.jpg?s=1024x1024&w=is&k=20&c=8FUUNAHDaQaAkcoxwmV9QN6h4zsgA1D28XQprJ8-Wg0="),
      CategoryModel(categoryName: "Packet food", status: "active", imageUrl: "https://media.istockphoto.com/id/1149135424/photo/group-of-sweet-and-salty-snacks-perfect-for-binge-watching.jpg?s=612x612&w=0&k=20&c=YAVqRyUJgj_nXpltYUPpaW_PYtd4v2TC5Mo0DtVFuoo="),
    ];
  }



}