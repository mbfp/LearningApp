// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';

/// {@template cards_api}
/// The interface and models for an API providing access to cards.
/// {@endtemplate}
abstract class CardsApi {
  /// {@macro cards_api}
  const CardsApi();

  /// provide a [Stream] of all subjects
  ValueListenable<Box<Subject>> getSubjects();

  /// return all cards which should get learned
  List<Card> learnAllCards();

  /// search for cards
  List<SearchResult> searchCard(String searchRequest, String? id);

  /// search for cards
  List<SearchResult> searchFolder(String searchRequest, String? id);

  /// search for cards
  List<Subject> searchSubject(String searchRequest);

  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(
      Card card, List<EditorTile>? editorTiles, String? parentId);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject);

  /// Saves a [folder]
  /// If a [folder] with same id already exists, it will be replaced
  Future<void> saveFolder(Folder folder, String? parentId);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is
  /// thrown
  Future<void> deleteSubject(String id);

  /// delete files when ids match to folder or cards and everything
  /// if you delete a folder all children get automatically deleted
  Future<void> deleteFiles(List<String> ids);

  /// Move folder and every children to [newParentId]
  Future<void> moveFiles(List<String> fileIds, String newParentId);

  /// return all children in stream to a given parentId
  ValueNotifier<List<File>> getChildrenById(String id);

  /// get contents of card
  Future<List<EditorTile>> getCardContent(String cardId);

  /// return Folder if one is found by its [folderUID]
  Folder? getFolderById(String folderUID);

  /// get list of every children for a given [parentId]
  List<String> getChildrenList(String parentId);

  /// get list of children ids one level below
  List<String> getChildrenDirectlyBelow(String parentId);

  /// get parent id to a given child id
  String getParentIdFromChildId(String id);

  /// get parent ids to a given child id
  List<String> getParentIdsFromChildId(String id);

  /// folder, subject or card from id
  Object? objectFromId(String id);

  /// dispose notifier to free up memory
  void disposeNotifier(String id);
}

/// Error when a [Card] with given id is not found
class CardNotFoundException implements Exception {}

/// Error when a [Subject] with given id is not found
class SubjectNotFoundException implements Exception {}

/// Error when a [Folder] with given id is not found
class FolderNotFoundException implements Exception {}

/// Error when a parent ([Folder] or [Card]) doesn't exist
class ParentNotFoundException implements Exception {}

/// Error when a stream for a given parentId wasn't found
class StreamNotFoundException implements Exception {}

/// when given input doesn't work
class WrongInput implements Exception {}
