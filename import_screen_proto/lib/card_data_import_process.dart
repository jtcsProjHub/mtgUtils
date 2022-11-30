/* This file defines a class that houses all of the necessary utility functions 
for taking the data imported from a text for CSV file that's been loaded into
a String list and outputs the appropriate card data list. It does not perform
any of the actual loading from disc, data clean-up logic, or anything like that. 
It is purely back-end business logic for taking what was loaded from the file
and interacting with Scryfall to create the appropriate objects */

import "package:import_screen_proto/scryfall_singleton.dart";

class ProcessFileDataToObject {
  var _scryfallSingleton = new ScryfallSingleton();

  // The MTGA format is weird, but specific. It annoyingly doesn't have a single
  // delimiter or consistent pattern, so you have to have something like a
  // bespoke RegEx (like I do here in Dart) or a handy zip function like in
  // Python to iterate through the different patterns.
  //
  // For reference, some sample data and the RegEx's to use:
  // Line: "12 Shambling Goblin (JMP) 277\n"
  // Quantity RegEx = (\d*?)(?=\ )
  // Name RegEx = (?<=\d)(.*?)(?=\()
  // Set Code RegEx = (?<=\()(.*?)(?=\))
  // Set ID RegEx = (?<=\) )(\d*?)(?=\n)
  String mtgaQuantityRegEx = "(\\d*?)(?=\\ )";
  String mtgaNameRegEx = "(?<=\\d )(.*?)(?=\\()";
  String mtgaSetCodeRegEx = "(?<=\\()(.*?)(?=\\))";
  String mtgaSetIdRegEx = "(?<=\\) )(\\d*?)(?=\\n)";
  late List<String> regexStrings;

  ProcessFileDataToObject() {
    regexStrings = [
      mtgaQuantityRegEx,
      mtgaNameRegEx,
      mtgaSetCodeRegEx,
      mtgaSetIdRegEx
    ];
  }

  bool validateMtgaCardLine(String lineToTest) {
    // Check that the quantity field is a number
    RegExp exp = RegExp(mtgaQuantityRegEx);
    RegExpMatch? match = exp.firstMatch(lineToTest);
    if (match == null) return false;
    try {
      num.parse(match[0]!);
    } on FormatException catch (_) {
      return false;
    }

    // Great! We started with a number!
    exp = RegExp(mtgaSetCodeRegEx);
    match = exp.firstMatch(lineToTest);
    if (match == null || match[0]!.length != 3) return false;

    // Set code has three characters, so looking better
    exp = RegExp(mtgaSetIdRegEx);
    match = exp.firstMatch(lineToTest);
    if (match == null) return false;
    try {
      num.parse(match[0]!);
    } on FormatException catch (_) {
      return false;
    }

    // Set ID is a number, great, so finally let's check if the name gives us
    // a non-empty string
    exp = RegExp(mtgaNameRegEx);
    match = exp.firstMatch(lineToTest);
    if (match == null || match[0]!.isEmpty) return false;
    return true;
  }
}
