// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/src/models/file.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId:1)
class Folder extends File implements Equatable {
  /// unique never changing id
  @HiveField(0)
  @override
  final String uid;

  /// possibly changing name
  @HiveField(1)
  final String name;

  /// to String formatted creation date
  @HiveField(2)
  final DateTime dateCreated;

  /// id of parent subject to order cards
  @HiveField(3)
  @override
  final List<String> parents;
  Folder({
    required this.uid,
    required this.name,
    required this.dateCreated,
    required this.parents,
  }) : super(uid: uid, parents: parents);

  Folder copyWith({
    String? uid,
    String? name,
    DateTime? dateCreated,
    List<String>? parents,
  }) {
    return Folder(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      parents: parents ?? this.parents,
    );
  }


  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [uid, name, dateCreated, parents];
  }
}
