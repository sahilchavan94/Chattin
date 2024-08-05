import 'package:chattin/core/common/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chattin/features/stories/domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  StoryModel({
    super.userEntity,
    required super.uid,
    required super.phoneNumber,
    required super.imageUrlList,
  });

  Map<String, dynamic> toMap() {
    //adding the uploadedAt field in every uploaded image's url
    // the array will be like this [{url1,referecePath,caption},{url2,referecePath,caption}....]
    //after updating it's like [{url1,referecePath,caption,uploadedAt}....]
    //this step can also be done within the cubit itself
    final urlList = imageUrlList
        .map((e) => {
              ...e,
              "uploadedAt": DateTime.now().millisecondsSinceEpoch,
            })
        .toList();
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'imageUrlList': FieldValue.arrayUnion(
        urlList,
      ),
      //arrayUnion tells the server to union the given
      // elements with any array value that already exists on the server.
      'uid': uid,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      uid: map['uid'] != null ? map['uid'] as String : "",
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : "",
      imageUrlList:
          map["imageUrlList"] != null ? map['imageUrlList'] as List : [],
      userEntity: map['userEntity'] != null
          ? UserModel.fromMap(map['userEntity'])
          : null,
    );
  }
}

// class StoryImageModel {
//   final String url;
//   final String caption;
//   final DateTime uploadedAt;

//   StoryImageModel({
//     required this.url,
//     required this.caption,
//     required this.uploadedAt,
//   });

//   factory StoryImageModel.fromMap(Map<String, dynamic> map) {
//     return StoryImageModel(
//       url: map['url'] != null ? map['url'] as String : "",
//       caption: map['caption'] != null ? map['caption'] as String : "",
//       uploadedAt: map['uploadedAt'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] as int)
//           : DateTime.now(),
//     );
//   }
// }
