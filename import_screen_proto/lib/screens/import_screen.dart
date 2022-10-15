import 'package:flutter/material.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  // Toggle for forcing a downselect of possible printings to only from the selected sets if possible
  bool _useSetImportLimits = false;
  // This holds the list of set codes that the user selects to enforce. Initialized empty.
  List<String> _setImportPrefs = <String>[];
  // Line-by-line import (each entry is a line) of the source data file
  List<String> _importFileContents = <String>[];
  // List of supported file types for import. Populates the dropdown.
  final List<String> _supportFileTypes = <String>['MTGA', 'CSV'];
  // Selection from the dropdown on what file type the user is importing
  String _selectedFileType = '';

  // For CSV files, there is a row of dropdown menus that each allow the user to select what field is actually in that column.
  // These are the different columns this program allows.
  final List<String> _supportColumnTypes = <String>[
    'SKIP',
    'Quantity',
    'Name',
    'Set Code',
    'Set Name',
    'Collector ID',
    'Multiverse ID'
  ];

  // Show the user an example of what they selected, so they can do a quick visual check against what their file looks like
  final Map<String, String> _csvExampleFields = {
    'SKIP': '<skipped>',
    'Quantity': '5',
    'Name': "Tranquil Cove",
    'Set Code': "NEO",
    'Set Name': "Kamigawa: Neon Dynasty",
    'Collector ID': "280",
    'Multiverse ID': "548593",
  };

  // List of columns that the user has selected. It is initialized with the default set of values.
  List<String> _csvColumnsSelected = <String>[
    'Quantity',
    'Name',
    'Set Code',
    'Collector ID'
  ];

  @override
  void initState() {
    super.initState();
    // Default to assuming that the user will import from whatever appears first in the list of file types we support.
    // Change values there to change the default. Don't change it here.
    _selectedFileType = _supportFileTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return importPrefsAndData();
  }

  // Function that generates and returns the list of dropdown boxes that indicate all of the columns in the CSV
  List<Widget> csvColumnDropDowns() {
    var dropDownList = List<Widget>.generate(
        _csvColumnsSelected.length,
        (index) => DropdownButton<String>(
              value: _csvColumnsSelected[index],
              icon: const Icon(Icons.file_copy_rounded),
              elevation: 16,
              style: const TextStyle(color: Colors.red),
              underline: Container(
                height: 2,
                color: Colors.redAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _csvColumnsSelected[index] = value!;
                });
              },
              items: _supportColumnTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ));
    return dropDownList;
  } // end csvColumnDropDowns

  // This is the main widget for the screen itself.
  Widget importPrefsAndData() {
    // Define all the components first so that the definition is clean
    // This dropdown menu will let the user specify what import type they
    // are looking to perform. The intent is not to support many options here.
    var fileTypeDropDown = DropdownButton<String>(
      value: _selectedFileType,
      icon: const Icon(Icons.file_copy_rounded),
      elevation: 16,
      style: const TextStyle(color: Colors.red),
      underline: Container(
        height: 2,
        color: Colors.redAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          _selectedFileType = value!;
        });
      },
      items: _supportFileTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    // These are stacked buttons that will be at the front of the row of column
    // selection dropdowns for the CSV file data
    var addRemoveButtons = Column(
      children: [
        Tooltip(
            message: 'Adds a column selection to the end.',
            waitDuration: const Duration(seconds: 1),
            child: ElevatedButton.icon(
              onPressed: () {
                // Adds a column selection option for a CSV file
                setState(() {
                  _csvColumnsSelected.add(_supportColumnTypes.first);
                });
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add column"),
            )),
        Tooltip(
            message: 'Removes the last column in the list.',
            waitDuration: const Duration(seconds: 1),
            child: ElevatedButton.icon(
              onPressed: () {
                // Removes the last CSV column in the list
                if (_csvColumnsSelected.isEmpty) return;
                setState(() {
                  _csvColumnsSelected.removeLast();
                });
              },
              icon: const Icon(Icons.remove, size: 18),
              label: const Text("Remove column"),
            ))
      ],
    );

    String csvExampleText = '';
    _csvColumnsSelected.forEach((selection) {
      csvExampleText += _csvExampleFields[selection] ??= '<undefined>';
      csvExampleText += ',';
    });

    if (csvExampleText.isNotEmpty) {
      csvExampleText = csvExampleText.substring(0, csvExampleText.length - 1);
    }

    // Use our handy utility function above to generate all of the necessary dropdown menus for us
    List<Widget> csvDropDownsRowWidgets = csvColumnDropDowns();
    csvDropDownsRowWidgets.insert(0, const Text("CSV Columns: "));
    csvDropDownsRowWidgets.add(addRemoveButtons);
    var csvDropDownRowRow = Row(children: csvDropDownsRowWidgets);

    // We now have all of the major elements defined that have any sort of complexity associated with them, so now
    // we'll assemble the main page widget.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("File Type"),
        fileTypeDropDown,
        if (_selectedFileType == 'CSV') ...[
          const Text("File details"),
          csvDropDownRowRow,
          const Text("Make sure lines in your file are arranged like this:"),
          Text(csvExampleText),
        ] else ...[
          const Text("Lines in your file should look like this:"),
          const Text(
              "1 Tranquil Cove (NEO) 280\n1 Swiftwater Cliffs (NEO) 277\n1 Naomi, Pillar of Order (NEO) 229"),
        ],
        Tooltip(
            message: 'Kicks off the import process on the specified data',
            waitDuration: const Duration(seconds: 1),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Code to add a CSV column
              },
              icon: const Icon(Icons.upload, size: 18),
              label: const Text("Import Data Go!"),
            )),
      ],
    );
  } // end importPrefsAndData
}
