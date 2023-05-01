import "package:flutter/material.dart";

/// constants for text fields, especially text styles for header1 or normal etc.
class TextFieldConstants {
  /// normal standard text style
  static const TextStyle normal =
      TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  /// text style for h1
  static const TextStyle header1 =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w900);

  /// text style for h2
  static const TextStyle header2 =
      TextStyle(fontSize: 21, fontWeight: FontWeight.w900);

  /// text style for h3
  static const TextStyle header3 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w900);

  /// text style for quotes
  static const TextStyle quote =
      TextStyle(fontSize: 15, fontStyle: FontStyle.italic);

  // TODO colors terror
  /// text for index of orderedListTile
  static const TextStyle orderedListIndex = TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white);

  /// text style for the front textfield of the callout_tile
  /// which should get used for smileys
  static const TextStyle calloutStart = TextStyle(fontSize:20);
}
