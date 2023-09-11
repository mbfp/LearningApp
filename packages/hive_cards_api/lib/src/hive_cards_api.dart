// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:developer';

import 'package:cards_api/cards_api.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

/// {@template hive_cards_api}
/// A Flutter implementation of the CardsApi that uses the hive database.
/// {@endtemplate}
class HiveCardsApi extends CardsApi {
  /// {@macro hive_cards_api}
  HiveCardsApi(this._hiveBox) {
    _init();
  }

  final Box<dynamic> _hiveBox;

  static const List<String> _ASCIICHARS = [
    '!',
    '"',
    '#',
    '%',
    '&',
    "'",
    '(',
    ')',
    '*',
    '+',
    ',',
    '-',
    '.',
    '/',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    ':',
    ';',
    '<',
    '=',
    '>',
    '?',
    '@',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '[',
    ']',
    '_',
    '`',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    '{',
    '|',
    '}',
    '~',
    '¡',
    'À',
    'Á',
    'Â',
    'Ã',
    'Ä',
    'Å',
    'Æ',
    'Ç',
    'È',
    'É',
    'Ê',
    'Ë',
    'Ì',
    'Í',
    'Î',
    'Ï',
    'Ð',
    'Ñ',
    'Ò',
    'Ó',
    'Ô',
    'Õ',
    'Ö',
    '×',
    'Ø',
    'Ù',
    'Ú',
    'Û',
    'Ü',
    'Ý',
    'Þ',
    'ß',
    'à',
    'á',
    'â',
    'ã',
    'ä',
    'å',
    'æ',
    'ç',
    'è',
    'é',
    'ê',
    'ë',
    'ì',
    'í',
    'î',
    'ï',
    'ð',
    'ñ',
    'ò',
    'ó',
    'ô',
    'õ',
    'ö',
    '÷',
    'ø',
    'ù',
    'ú',
    'û',
    'ü',
    'ý',
    'þ',
    'ÿ'
  ];

  /// stream for passing all stored subjects to frontend
  final _subjectStreamController =
      BehaviorSubject<List<Subject>>.seeded(const []);

  /// all previous paths that the system knows,
  /// entries never get removed during runtime
  List<String> _indexedPaths = [];

  /// Map of <parentId, Stream>
  final Map<String, BehaviorSubject<List<Object>>> _subscribedStreams = {};
  Map<dynamic, dynamic> _storeIds = {};

  void _init() {
    // load all saved indexedPaths
    try {
      _indexedPaths = _hiveBox.get('indexed_paths') as List<String>;
    } catch (e) {
      log('\x1B[32mno paths saved\x1B[32m');
    }
    // load all saved subjects
    try {
      final subjectJson = _hiveBox.get('/subjects') as List<String>;
      _subjectStreamController.add(_subjectsFromJson(subjectJson));
    } catch (e) {
      log('\x1B[32mno subjects saved\x1B[32m');
    }
    // load all storedIds
    try {
      _storeIds = _hiveBox.get('/store_ids') as Map<dynamic, dynamic>;
    } catch (e) {
      log('\x1B[32mno storeIds saved\x1B[32m');
    }
  }

  List<String> _cardsToJson(List<Card> cards) {
    final jsonCards = <String>[];
    for (final element in cards) {
      jsonCards.add(element.toJson());
    }
    return jsonCards;
  }

  List<String> _foldersToJson(List<Folder> folders) {
    final jsonFolders = <String>[];
    for (final element in folders) {
      jsonFolders.add(element.toJson());
    }
    return jsonFolders;
  }

  List<String> _subjectsToJson(List<Subject> cards) {
    final jsonSubjects = <String>[];
    for (final element in cards) {
      jsonSubjects.add(element.toJson());
    }
    return jsonSubjects;
  }

  List<Card> _cardsFromJson(List<String> json) {
    final cards = <Card>[];
    for (final element in json) {
      cards.add(Card.fromJson(element));
    }
    return cards;
  }

  List<Folder> _foldersFromJson(List<String> json) {
    final folders = <Folder>[];
    for (final element in json) {
      folders.add(Folder.fromJson(element));
    }
    return folders;
  }

  List<Subject> _subjectsFromJson(List<String> json) {
    final subjects = List<Subject>.empty(growable: true);
    for (final element in json) {
      subjects.add(Subject.fromJson(element));
    }
    return subjects;
  }

  @override
  Future<void> deleteCard(String id, String parentId) async {
    await _deleteCards([id], [parentId]);
  }

  @override
  Future<void> deleteCards(List<String> id, List<String> parentId) async {
    await _deleteCards(id, parentId);
  }

  @override
  Future<void> deleteSubject(String id) {
    final subjects = _subjectStreamController.value;
    final subjectIndex = subjects.indexWhere((element) => element.id == id);
    if (subjectIndex == -1) {
      throw SubjectNotFoundException();
    } else {
      subjects.removeAt(subjectIndex);
      _deleteChildPaths('/subjects/$id');
      _subjectStreamController.add(subjects);
      return _hiveBox.put('/subjects', subjects);
    }
  }

  @override
  Future<void> deleteFolder(String id, String parentId) async {
    await _deleteFolder(id, parentId);
    return;
  }

  @override
  Stream<List<Subject>> getSubjects() =>
      _subjectStreamController.asBroadcastStream();

  @override
  Stream<List<Object>> getChildrenById(String id) {
    final newStream = BehaviorSubject<List<Object>>.seeded(const []);
    final path = _getPath(id);
    if (path == null) {
      throw StreamNotFoundException();
    }
    final childrenStrings =
        _hiveBox.get(_makePathStorable(path)) as List<String>?;
    final children = <Object>[];
    if (childrenStrings != null) {
      for (final element in childrenStrings) {
        try {
          children.add(Card.fromJson(element));
        } catch (e) {
          children.add(Folder.fromJson(element));
        }
      }
    }

    newStream.add(children);
    _subscribedStreams[path] = newStream;
    return newStream;
  }

  @override
  Future<void> saveSubject(Subject subject) {
    var subjects = _subjectStreamController.value;
    if (subjects.isEmpty) subjects = [];
    final subjectIndex =
        subjects.indexWhere((element) => element.id == subject.id);
    if (subjectIndex >= 0) {
      subjects[subjectIndex] = subject;
    } else {
      subjects.add(subject);
    }
    _subjectStreamController.add(subjects);
    _indexedPaths.add('/subjects/${subject.id}');
    _saveIndexedPaths();
    return _hiveBox.put('/subjects', _subjectsToJson(subjects));
  }

  @override
  Future<void> saveFolder(Folder folder) {
    final parentId = folder.parentId;

    final path = _getPath(parentId);

    if (path == null) {
      throw ParentNotFoundException();
    }
    if (!_indexedPaths.contains('$path/${folder.id}')) {
      _indexedPaths.add('$path/${folder.id}');
      _saveIndexedPaths();
    }
    var folders = _hiveBox.get(_makePathStorable(path)) as List<String>?;
    var found = false;
    if (folders != null) {
      for (var element in folders) {
        if (element.substring(7).startsWith(folder.id)) {
          element = folder.toJson();
          found = true;
          break;
        }
      }
    } else {
      folders = [];
    }

    if (!found) {
      folders.add(folder.toJson());
    }
    if (_subscribedStreams.containsKey(path)) {
      _subscribedStreams[path]!.add([folder]);
    }
    return _hiveBox.put(_makePathStorable(path), folders);
  }

  @override
  Future<void> saveCard(Card card) {
    final parentId = card.parentId;

    final path = _getPath(parentId);

    if (path == null) {
      throw ParentNotFoundException();
    }

    var cards = _hiveBox.get(_makePathStorable(path)) as List<String>?;
    var found = false;
    var indexToChange = 0;
    if (cards != null) {
      for (final element in cards) {
        // contains word
        if (element.substring(7).startsWith(card.id)) {
          indexToChange = cards.indexOf(element);
          found = true;
          break;
        }
      }
    } else {
      cards = [];
    }
    if (!found) {
      cards.add(card.toJson());
    } else {
      cards[indexToChange] = card.toJson();
    }

    if (_subscribedStreams.containsKey(path)) {
      _subscribedStreams[path]!.add([card]);
    }
    return _hiveBox.put(_makePathStorable(path), cards);
  }

  @override
  Future<void> moveFolder(Folder folder, String newParentId) async {
    await _deleteFolder(folder.id, folder.parentId, deleteChildPaths: false);
    await _moveChildPaths(folder.id, newParentId);
    final newFolder = folder.copyWith(parentId: newParentId);
    await saveFolder(newFolder);
  }

  @override
  Future<void> moveCards(List<Card> cards, String newParentId) async {
    final newPath = _getPath(newParentId);

    if (newPath == null) {
      throw ParentNotFoundException();
    }
    final updateEvents = <String, List<Object>>{};

    final cardIds = <String>[];
    final cardParentIds = <String>[];

    for (final card in cards) {
      cardIds.add(card.id);
      cardParentIds.add(card.parentId);
      final newCard = card.copyWith(parentId: newParentId);
      final currentPath = _getPath(card.parentId);
      if (currentPath == null) {
        throw ParentNotFoundException();
      }

      var loadedNewCards =
          await _hiveBox.get(_makePathStorable(newPath)) as List<String>?;
      var found = false;
      var indexToChange = 0;
      if (loadedNewCards != null) {
        for (final element in loadedNewCards) {
          // contains word
          if (element.substring(7).startsWith(newCard.id)) {
            indexToChange = loadedNewCards.indexOf(element);
            found = true;
            break;
          }
        }
      } else {
        loadedNewCards = [];
      }
      if (!found) {
        loadedNewCards.add(newCard.toJson());
      } else {
        loadedNewCards[indexToChange] = newCard.toJson();
      }

      if (updateEvents[newPath] == null) {
        updateEvents[newPath] = [newCard];
      } else {
        updateEvents[newPath]!.add(newCard);
      }

      await _hiveBox.put(_makePathStorable(newPath), loadedNewCards);
    }
    updateEvents
      ..addAll(
        await _deleteCards(cardIds, cardParentIds, notifyListeners: false),
      )
      ..forEach((key, value) {
        if (_subscribedStreams.containsKey(key)) {
          _subscribedStreams[key]!.add(value);
        }
      });
  }

  @override
  Future<void> closeStreamById(String id, {bool deleteChildren = false}) async {
    final path = _getPath(id);
    if (deleteChildren) {
      final childPaths = _getChildrenPaths(id);
      if (childPaths != null) {
        for (final element in childPaths) {
          if (_subscribedStreams[element] != null) {
            await _subscribedStreams[element]!.close();
            _subscribedStreams.remove(element);
          }
        }
      }
    }
    if (_subscribedStreams[path] != null) {
      await _subscribedStreams[path]!.close();
      _subscribedStreams.remove(path);
    }
  }

  @override
  List<Card> learnAllCards() {
    final cardsToLearn = <Card>[];
    final now = DateTime.now();
    for (final element in _indexedPaths) {
      final loadedCardStrings =
          _hiveBox.get(_makePathStorable(element)) as List<String>?;
      if (loadedCardStrings == null) continue;
      for (final loadedCardString in loadedCardStrings) {
        if (loadedCardString.substring(46).startsWith('front')) {
          final card = Card.fromJson(loadedCardString);
          try {
            if (DateTime.parse(card.dateToReview).compareTo(now) < 0) {
              cardsToLearn.add(card);
            }
          } catch (e) {
            cardsToLearn.add(card);
            final newCard =
                card.copyWith(dateToReview: DateTime.now().toIso8601String());
            saveCard(newCard);
          }
        }
      }
    }
    return cardsToLearn;
  }

  @override
  List<SearchResult> searchCard(String searchRequest, String? id) {
    final searchResults = <SearchResult>[];
    for (final indexedPath in _indexedPaths) {
      if (id != null && !indexedPath.contains(id)) continue;
      final loadedCardStrings =
          _hiveBox.get(_makePathStorable(indexedPath)) as List<String>?;
      if (loadedCardStrings == null) continue;
      for (final loadedCardString in loadedCardStrings) {
        if (loadedCardString.toLowerCase().contains(searchRequest)) {
          try {
            final card = Card.fromJson(loadedCardString);
            if (card.front
                    .toLowerCase()
                    .contains(searchRequest.toLowerCase()) ||
                card.back.toLowerCase().contains(searchRequest.toLowerCase())) {
              searchResults.add(SearchResult(
                  searchedObject: card,
                  parentObjects: _getParentNamesFromPath(indexedPath)));
            }
          } catch (e) {
            continue;
          }
        }
      }
    }
    return searchResults;
  }

  @override
  List<Subject> searchSubject(String searchRequest) {
    final foundSubjects = <Subject>[];

    final loadedCardStrings = _hiveBox.get("/subjects") as List<String>?;
    if (loadedCardStrings == null) return List.empty();
    for (final loadedCardString in loadedCardStrings) {
      if (!loadedCardString.substring(46).startsWith('front') &&
          loadedCardString
              .toLowerCase()
              .contains(searchRequest.toLowerCase())) {
        final subject = Subject.fromJson(loadedCardString);
        if (subject.name.toLowerCase().contains(searchRequest.toLowerCase())) {
          foundSubjects.add(subject);
        }
      }
    }

    return foundSubjects;
  }

  @override
  List<SearchResult> searchFolder(String searchRequest, String? id) {
    final searchResults = <SearchResult>[];
    for (final indexedPath in _indexedPaths) {
      if (id != null && !indexedPath.contains(id)) continue;

      final loadedCardStrings =
          _hiveBox.get(_makePathStorable(indexedPath)) as List<String>?;
      if (loadedCardStrings == null) continue;
      for (final loadedCardString in loadedCardStrings) {
        if (!loadedCardString.substring(46).startsWith('front') &&
            loadedCardString.toLowerCase().contains(searchRequest)) {
          try {
            final folder = Folder.fromJson(loadedCardString);
            if (folder.name
                .toLowerCase()
                .contains(searchRequest.toLowerCase())) {
              searchResults.add(SearchResult(
                  searchedObject: folder,
                  parentObjects: _getParentNamesFromPath(indexedPath)));
            }
          } catch (e) {
            continue;
          }
        }
      }
    }
    return searchResults;
  }

  List<Object> _getParentNamesFromPath(String path) {
    final parentNames = <Object>[];
    var currentPath = path;
    var idToMatch = '';

    while (true) {
      final regex = RegExp('^(.*)/');
      final match = regex.firstMatch(currentPath);
      if (match != null && match.group(1) != '') {
        final newPath = match.group(1)!;
        idToMatch = currentPath.substring(newPath.length + 1);
        currentPath = newPath;

        if (currentPath == '/subjects') {
          final subjects = _subjectStreamController.value;
          for (final element in subjects) {
            if (element.id == idToMatch) {
              parentNames.add(element);
              return parentNames.reversed.toList();
            }
          }
        }

        final elements =
            _hiveBox.get(_makePathStorable(currentPath)) as List<String>?;
        innerLoop:
        for (final element in elements!) {
          try {
            final folder = Folder.fromJson(element);
            if (folder.id == idToMatch) {
              parentNames.add(folder);
              break innerLoop;
            }
          } catch (e) {
            // element is no folder
          }
        }
      } else {
        return parentNames.reversed.toList();
      }
    }
  }

  String? _getPath(String parentId) {
    for (final element in _indexedPaths) {
      if (element.endsWith(parentId)) {
        return element;
      }
    }
    return null;
  }

  String _makePathStorable(String path) {
    final singleIds = path.split('/');
    singleIds
      ..removeAt(0)
      ..removeAt(0);
    var newPath = '/subjects';
    for (final id in singleIds) {
      if (_storeIds.containsKey(id)) {
        newPath += '/${_storeIds[id]!}';
      } else {
        var newKey = _ASCIICHARS[0];
        if (_storeIds.isNotEmpty) {
          newKey =
              (_addOneToString(_storeIds.values.last as String)).toString();
        }
        _storeIds[id] = newKey;
        newPath += '/${_storeIds[id]!}';
        _hiveBox.put('/store_ids', _storeIds);
      }
    }
    return newPath;
  }

  List<String>? _getChildrenPaths(String parentId) {
    final paths = <String>[];
    for (final element in _indexedPaths) {
      if (element.contains(parentId)) {
        paths.add(element);
      }
    }
    return paths;
  }

  Future<void> _deleteChildPaths(String id) {
    final newIndexedPaths = <String>[];
    for (final element in _indexedPaths) {
      if (element.contains(id)) {
        _hiveBox.delete(element);
      } else {
        newIndexedPaths.add(element);
      }
    }
    _indexedPaths = newIndexedPaths;
    return _saveIndexedPaths();
  }

  Future<void> _moveChildPaths(String oldId, String newId) async {
    final newPrefix = _getPath(newId);
    if (newPrefix == null) {
      throw ParentNotFoundException();
    }
    final newIndexPaths = <String>[];
    for (final element in _indexedPaths) {
      if (element.contains(oldId)) {
        final newPath =
            '$newPrefix/${element.substring(element.indexOf(oldId))}';
        newIndexPaths.add(newPath);
        final previousStoredObjects =
            _hiveBox.get(_makePathStorable(element)) as List<String>?;
        if (previousStoredObjects != null) {
          await _hiveBox.delete(element);
          await _hiveBox.put(_makePathStorable(newPath), previousStoredObjects);
        }
      } else {
        newIndexPaths.add(element);
      }
    }
    _indexedPaths = newIndexPaths;
    return _saveIndexedPaths();
  }

  Future<void> _saveIndexedPaths() async {
    final newIndexPaths = _indexedPaths.toSet().toList();
    await _hiveBox.put('indexed_paths', newIndexPaths);
  }

  String _addOneToString(String previous) {
    if (previous.isEmpty) return '';
    final currentIndex = _ASCIICHARS.indexOf(previous[previous.length - 1]);
    if (currentIndex == _ASCIICHARS.length - 1) {
      if ((previous.substring(0, previous.length - 1)).isEmpty) {
        return _ASCIICHARS[1] + _ASCIICHARS[0];
      }
      return _addOneToString(previous.substring(0, previous.length - 1)) +
          _ASCIICHARS[0];
    } else {
      return previous.substring(0, previous.length - 1) +
          _ASCIICHARS[currentIndex + 1];
    }
  }

  Future<Map<String, List<Removed>>> _deleteCards(
    List<String> ids,
    List<String> parentIds, {
    bool notifyListeners = true,
  }) async {
    if (ids.length != parentIds.length) throw WrongInput();

    final pathsToRemove = <String>[];
    final parentIdsToDeletedIds = <String, List<Removed>>{};

    for (var i = 0; i < ids.length; i++) {
      final currentPath = _getPath(parentIds[i]);
      if (currentPath == null) throw ParentNotFoundException();
      if (!pathsToRemove.contains(currentPath)) {
        pathsToRemove.add(currentPath);
      }
      parentIdsToDeletedIds[currentPath] == null
          ? parentIdsToDeletedIds[currentPath] = [Removed(id: ids[i])]
          : parentIdsToDeletedIds[currentPath]!.add(Removed(id: ids[i]));

      final loadedCards =
          await _hiveBox.get(_makePathStorable(currentPath)) as List<String>?;
      var found = false;
      if (loadedCards != null) {
        for (final card in loadedCards) {
          if (card.substring(7).startsWith(ids[i])) {
            loadedCards.remove(card);
            found = true;
            break;
          }
        }
      }
      if (!found) throw ParentNotFoundException();
      await _hiveBox.put(_makePathStorable(currentPath), loadedCards);
    }

    if (notifyListeners) {
      for (final path in pathsToRemove) {
        if (_subscribedStreams.containsKey(path)) {
          _subscribedStreams[path]!.add(parentIdsToDeletedIds[path]!);
        }
      }
    }
    return parentIdsToDeletedIds;
  }

  Future<void> _deleteFolder(
    String id,
    String parentId, {
    bool deleteChildPaths = true,
  }) async {
    final path = _getPath(parentId);
    if (path == null) {
      throw ParentNotFoundException();
    }
    final folders =
        await _hiveBox.get(_makePathStorable(path)) as List<String>?;
    var found = false;
    if (folders != null) {
      for (final element in folders) {
        if (element.substring(7).startsWith(id)) {
          folders.remove(element);
          found = true;
          break;
        }
      }
    }
    if (found == false) {
      throw ParentNotFoundException();
    }
    if (_subscribedStreams.containsKey(path)) {
      _subscribedStreams[path]!.add([Removed(id: id)]);
    }
    if (deleteChildPaths == true) {
      await _deleteChildPaths(id);
    }
    return _hiveBox.put(_makePathStorable(path), folders);
  }
}
