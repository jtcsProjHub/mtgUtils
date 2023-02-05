// Import the test package and Counter class
import 'package:import_screen_proto/card_data_import_process.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:import_screen_proto/constants.dart';

void main() {
  test('All cards should be validated true for MTGA lines', () {
    final cardProcessor = ProcessFileDataToObject();

    List<String> testCards = [
      '1 Master Biomancer (2X2) 521',
      '1 Torens, Fist of the Angels (DBL) 516',
      '1 Argoth, Sanctum of Nature (BRO) 256a'
    ];
    for (int i = 0; i < testCards.length; i++) {
      bool testResult = cardProcessor.validateMtgaCardLine(testCards[i]);
      expect(testResult, true);
    }
  });

  test('All cards should be confirmed false for MTGA lines', () {
    final cardProcessor = ProcessFileDataToObject();

    List<String> testCards = [
      '3,Dragon\'s Disciple,,,,,AFR,13,en,NM,,',
      'Green Deck,1,0,Blighted Woodland,BFZ,Battle for Zendikar,233,NearMint,Normal,English,0.35,12/26/2020',
      '1,Ambush Party,hml,Near Mint,English,,63b'
    ];
    for (int i = 0; i < testCards.length; i++) {
      bool testResult = cardProcessor.validateMtgaCardLine(testCards[i]);
      expect(testResult, false);
    }
  });

  test('All cards should be validated true for CSV lines', () {
    final cardProcessor = ProcessFileDataToObject();

    List<String> testCards = [
      '3,Dragon\'s Disciple,,,,,AFR,13,en,NM,,',
      'Green Deck,1,0,Blighted Woodland,BFZ,Battle for Zendikar,233,NearMint,Normal,English,0.35,12/26/2020',
      '1,Ambush Party,hml,Near Mint,English,,63b'
    ];

    // Contains the pattern for the test lines above as if a user specified them
    List<List<String>> expectedColumns = [
      [
        HEADING_QUANTITY,
        HEADING_NAME,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SET_CODE,
        HEADING_COLLECTOR_ID,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP
      ],
      [
        HEADING_SKIP,
        HEADING_QUANTITY,
        HEADING_SKIP,
        HEADING_NAME,
        HEADING_SET_CODE,
        HEADING_SET_NAME,
        HEADING_COLLECTOR_ID,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
      ],
      [
        HEADING_QUANTITY,
        HEADING_NAME,
        HEADING_SET_CODE,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_SKIP,
        HEADING_COLLECTOR_ID
      ]
    ];

    for (int i = 0; i < testCards.length; i++) {
      bool testResult =
          cardProcessor.validateCsvCardLine(testCards[i], expectedColumns[i]);
      expect(testResult, false);
    }
  });

  test('All cards should be validated false for CSV lines', () {
    final cardProcessor = ProcessFileDataToObject();

    List<String> testCards = [
      '1 Master Biomancer (2X2) 521',
      '1 Torens, Fist of the Angels (DBL) 516',
      '1 Argoth, Sanctum of Nature (BRO) 256a'
    ];

    // Here I'm essentially assuming that the user was trying to make the CSV
    // import work with an MTGA file. Made sure to include card names with
    // commas in them for the test data.
    List<String> expectedColumns = [
      HEADING_QUANTITY,
      HEADING_NAME,
      HEADING_SET_CODE,
      HEADING_COLLECTOR_ID
    ];

    for (int i = 0; i < testCards.length; i++) {
      bool testResult =
          cardProcessor.validateCsvCardLine(testCards[i], expectedColumns);
      expect(testResult, false);
    }
  });
}
