// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chattin/features/stories/domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  StoryModel({
    required super.displayName,
    required super.phoneNumber,
    required super.imageUrl,
    required super.imageUrlList,
    required super.uid,
  });

  Map<String, dynamic> toMap() {
    final urlList = imageUrlList
        .map((e) => {
              ...e,
              "uploadedAt": DateTime.now().millisecondsSinceEpoch,
            })
        .toList();
    return <String, dynamic>{
      'displayName': displayName,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'imageUrlList': FieldValue.arrayUnion(urlList),
      'uid': uid,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      uid: map['uid'] != null ? map['uid'] as String : "",
      displayName:
          map['displayName'] != null ? map['displayName'] as String : "",
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : "",
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : "",
      imageUrlList:
          map["imageUrlList"] != null ? map['imageUrlList'] as List : [],
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
