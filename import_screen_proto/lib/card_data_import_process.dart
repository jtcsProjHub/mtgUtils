/* This file defines a class that houses all of the necessary utility functions 
for taking the data imported from a text or CSV file that's been loaded into
a String list and outputs the appropriate card data list. It does not perform
any of the actual loading from disc, data clean-up logic, or anything like that. 
It is purely back-end business logic for taking what was loaded from the file
and interacting with Scryfall to create the appropriate objects */

import "package:import_screen_proto/scryfall_singleton.dart";

class ProcessFileDataToObject {
  final _scryfallSingleton = ScryfallSingleton();

  // The MTGA format is weird, but specific. It annoyingly doesn't have a single
  // delimiter or consistent pattern, so you have to have something like a
  // bespoke RegEx or iterate through the different delimeters and reconstruct
  // the string as you peel off the tokens. Or use Python and a zip function.
  static const List _mtgaDelimeters = [" ", "(", ")"];

  // This function doesn't do a "deep" check. I'm assuming that if you have
  // the right delimeters then you're good enough to pass the "sniff test"
  bool validateMtgaCardLine(String lineToTest) {
    for (int i = 0; i < _mtgaDelimeters.length; i++) {
      try {
        int idx = lineToTest.indexOf(_mtgaDelimeters[i]);
        List parts = [
          lineToTest.substring(0, idx).trim(),
          lineToTest.substring(idx + 1).trim()
        ];

        // Make sure that we at least have a token
        if (parts[0].toString().isEmpty) return false;
        lineToTest = parts[1];
      } on RangeError {
        return false;
      }
    }
    if (lineToTest.toString().isEmpty) return false;
    return true;
  }

  // Similar to the MTGA validation function, this is mainly just a check that
  // the CSV line has the expected number of data fields. Since essentially
  // everything that we're looking for are strings, there really isn't any
  // type checking that we can reasonably do. Any Scryfall-level checking will
  // happen when we do the actual importing.
  bool validateCsvCardLine(String lineToTest, List<String> fieldsExpected) {
    return ','.allMatches(lineToTest).length == fieldsExpected.length;
  }
}
