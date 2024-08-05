import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

class EditorInputFormatter extends TextInputFormatter {
  EditorTextFieldManager em;
  EditorInputFormatter({required this.em});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    _compareStrings(
      oldValue.text,
      newValue.text,
      newValue.selection,
    );
    return newValue;
  }

  void _compareStrings(
    String oldText,
    String newText,
    TextSelection selection, [
    TextStyle? style,
  ]) {
    final dmp = DiffMatchPatch();
    // compares two strings and returns insertions and deletions
    List<Diff> diffs = dmp.diff(oldText, newText);
    int globalIndex = 0;
    int lineIndex = 0;
    int localIndex = 0;
    //! bug when using equal characters with different formatting, the dmp.diff function
    //! can't detect this, because it doesn't know the formatting
    for (Diff diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          List<String> lines = diff.text.split('\n');
          for (String line in lines) {
            if (line.characters.isNotEmpty) {
              _addSpan(
                EditorSpan(
                  span: TextSpan(text: line),
                  start: localIndex,
                  end: localIndex + line.length,
                ),
                lineIndex,
                globalIndex,
              );
            }
            globalIndex += line.length;
            lineIndex += 1;
            localIndex = 0;
          }
          break;
        case DIFF_DELETE:
          _removeSpan(localIndex, localIndex + diff.text.length, lineIndex);
          break;
        case DIFF_EQUAL:
          List<String> lines = diff.text.split('\n');
          lineIndex += lines.length - 1;
          localIndex = lines[lines.length - 1].characters.length;
          break;
      }
      if (diff.operation != DIFF_DELETE) {
        globalIndex += diff.text.length;
      }
    }
  }

  // start and end is line relative
  void _addSpan(EditorSpan span, int line, int globalStart) {
    if (em.lines.length <= line) {
      em.lines.add(
        EditorLine(
          spans: [span],
          start: globalStart,
          end: globalStart + span.span.toPlainText().length,
        ),
      );
    } else {
      // iterate over all spans in the line
      for (int i = 0; i < em.lines[line].spans.length; i++) {
        // if the span is in the bounds of the em.lines[i].spans[i]
        if ((em.lines[line].spans[i].end >= span.end &&
                em.lines[line].spans[i].start <= span.start) ||
            i == em.lines[line].spans.length - 1) {
          final before = em.lines[line].spans[i].span
              .toPlainText()
              .substring(0, span.start - em.lines[line].spans[i].start);
          final inBetween = span.span.toPlainText();
          final after = em.lines[line].spans[i].span
              .toPlainText()
              .substring(span.start - em.lines[line].spans[i].start);
          if (em.lines[line].spans[i].spanFormatType == span.spanFormatType) {
            // merge the spans
            em.lines[line].spans[i] = EditorSpan(
              span: TextSpan(
                text: before + inBetween + after,
              ),
              start: em.lines[line].spans[i].start,
              end: em.lines[line].spans[i].end + inBetween.characters.length,
            );
          } else {
            if (before.characters.isNotEmpty) {
              // split the span and insert new span in between
              em.lines[line].spans[i] = EditorSpan(
                span: TextSpan(
                  text: before,
                ),
                start: em.lines[line].spans[i].start,
                end: em.lines[line].spans[i].start + before.characters.length,
              );
            } else {
              em.lines[line].spans.removeAt(i);
              i--;
            }
            if (inBetween.characters.isNotEmpty) {
              em.lines[line].spans.insert(
                i,
                EditorSpan(
                  span: TextSpan(text: inBetween),
                  start:
                      em.lines[line].spans[i].start + before.characters.length,
                  end: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length,
                ),
              );
              i++;
            }
            if (after.characters.isNotEmpty) {
              em.lines[line].spans.insert(
                i,
                EditorSpan(
                  span: TextSpan(text: after),
                  start: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length,
                  end: em.lines[line].spans[i].start +
                      before.characters.length +
                      inBetween.characters.length +
                      after.characters.length,
                ),
              );
              i++;
            }
          }
          _updateGloablLineIndexes();
          break;
        }
      }
    }
  }

  void _updateGloablLineIndexes() {
    int previousEnd = 0;
    em.lines[0].end = previousEnd;
    for (int i = 0; i < em.lines.length; i++) {
      em.lines[i].start = previousEnd;
      em.lines[i].end = previousEnd + em.lines[i].spans.last.end;
      previousEnd = em.lines[i].end;
    }
  }

  void _removeSpan(int start, int end, int line) {}
  void _changeStyle(TextStyle style, int start, int end) {}
  void _changeStyleAccordingToSelection() {}
}
