import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:import_screen_proto/constants.dart';
import 'package:import_screen_proto/widgets/full_set_list.dart';

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
  String _fileLoaded = '';

  final _commonWidgetLabelTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 15,
  );

  // For CSV files, there is a row of dropdown menus that each allow the user to select what field is actually in that column.
  // These are the different columns this program allows.
  final List<String> _supportColumnTypes = <String>[
    HEADING_SKIP,
    HEADING_QUANTITY,
    HEADING_NAME,
    HEADING_SET_CODE,
    HEADING_SET_NAME,
    HEADING_COLLECTOR_ID,
    HEADING_MULTIVERSE_ID
  ];

  // Show the user an example of what they selected, so they can do a quick visual check against what their file looks like
  final Map<String, String> _csvExampleFields = {
    HEADING_SKIP: '<skipped>',
    HEADING_QUANTITY: '5',
    HEADING_NAME: "Tranquil Cove",
    HEADING_SET_CODE: "NEO",
    HEADING_SET_NAME: "Kamigawa: Neon Dynasty",
    HEADING_COLLECTOR_ID: "280",
    HEADING_MULTIVERSE_ID: "548593",
  };

  // List of columns that the user has selected. It is initialized with the default set of values.
  final List<String> _csvColumnsSelected = <String>[
    HEADING_QUANTITY,
    HEADING_NAME,
    HEADING_SET_CODE,
    HEADING_COLLECTOR_ID
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

  void _setImportPrefsFunc(List<String> userSetPrefs) {
    _setImportPrefs = userSetPrefs;
  }

  late final Widget _mtgFullSetListScroll = FullSetList(
    setUserPrefs: _setImportPrefsFunc,
  );

  // Function that generates and returns the list of dropdown boxes that indicate all of the columns in the CSV
  List<Widget> csvColumnDropDowns() {
    var dropDownList = List<Widget>.generate(
        _csvColumnsSelected.length,
        (index) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(10)),

                // dropdown below..
                child: DropdownButton<String>(
                  value: _csvColumnsSelected[index],
                  icon: const Icon(Icons.file_copy_rounded),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
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
                ))));
    return dropDownList;
  } // end csvColumnDropDowns

  // Used to make the "enforce set selection" checkbox and label, including any formatting
  // needed for it to not look out of place or weird.
  // Why yes, all of this code is indeed required for those two little elements
  Widget fancyCheckBox() {
    // This part here will make the checkbox fancy and like "the people" would expect from a high-quality
    // thrown-together-at-random-times app like this one.
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.blue;
    }

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: _useSetImportLimits,
                  onChanged: (bool? value) {
                    setState(() {
                      _useSetImportLimits = value!;
                    });
                  },
                )),
            Text(
              "Enforce certain sets if able?",
              style: _commonWidgetLabelTextStyle,
            ),
          ],
        ));
  }

  // This is the main widget for the screen itself.
  Widget importPrefsAndData() {
    // Define all the components first so that the definition is clean
    // This dropdown menu will let the user specify what import type they
    // are looking to perform. The intent is not to support many options here.
    var fileTypeDropDown = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.black, width: 2),
        )),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(10)),

                // dropdown below..
                child: DropdownButton<String>(
                  value: _selectedFileType,
                  icon: const Icon(Icons.file_copy_rounded),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedFileType = value!;
                    });
                  },
                  items: _supportFileTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ))));

    // These are stacked buttons that will be at the front of the row of column
    // selection dropdowns for the CSV file data
    var addRemoveButtons = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Tooltip(
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
                    ))),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Tooltip(
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
                    )))
          ],
        ));

    String csvExampleText = '';
    for (var selection in _csvColumnsSelected) {
      csvExampleText += _csvExampleFields[selection] ??= '<undefined>';
      csvExampleText += ',';
    }

    if (csvExampleText.isNotEmpty) {
      csvExampleText = csvExampleText.substring(0, csvExampleText.length - 1);
    }

    // Use our handy utility function above to generate all of the necessary dropdown menus for us
    List<Widget> csvDropDownsRowWidgets = csvColumnDropDowns();
    csvDropDownsRowWidgets.insert(
        0,
        Text(
          "CSV Columns: ",
          style: _commonWidgetLabelTextStyle,
        ));
    csvDropDownsRowWidgets.add(addRemoveButtons);

    // Frame out the row of CSV buttons
    var csvDropDownRow = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.black, width: 2),
        )),
        child: Row(children: csvDropDownsRowWidgets));

    // Contains all the text and formatting for the file type options
    Widget inputFileTypeStack =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Input File Type",
        style: _commonWidgetLabelTextStyle,
      ),
      fileTypeDropDown,
    ]);

    // Contains all the text and formatting for the CSV options
    Widget csvDetailsStack = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedFileType == 'CSV') ...[
          Text(
            "CSV File Details",
            style: _commonWidgetLabelTextStyle,
          ),
          csvDropDownRow,
        ],
      ],
    );

    // Formatted text and bordering for the example file contents
    Widget exampleTextStack = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 2),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedFileType == 'CSV') ...[
              const Padding(
                  padding: EdgeInsetsDirectional.only(top: 20.0),
                  child: Text(
                    "Make sure lines in your file are arranged like this:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 20.0),
                  child: Text(csvExampleText,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
            ] else ...[
              const Padding(
                  padding: EdgeInsetsDirectional.only(top: 20.0),
                  child: Text("Lines in your file should look like this:",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 20.0),
                  child: Text(
                      "1 Tranquil Cove (NEO) 280\n1 Swiftwater Cliffs (NEO) 277\n1 Naomi, Pillar of Order (NEO) 229",
                      style: TextStyle(fontWeight: FontWeight.w600))),
            ],
          ],
        ));

    // We now have all of the major elements defined that have any sort of
    //complexity associated with them, so now we'll assemble the main page widget.
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputFileTypeStack,
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.0),
                  child: csvDetailsStack,
                ),
              ],
            ),
            exampleTextStack,
            Padding(
                padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
                child: Tooltip(
                    message: 'Pick the file from your local machine.',
                    waitDuration: const Duration(seconds: 1),
                    child: ElevatedButton.icon(
                      onPressed: () => _selectImportFile(),
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text("Select file..."),
                    ))),
            if (_importFileContents.isNotEmpty) ...[
              _importFilePreview(),
            ],
            Tooltip(
                message: _importFileContents.isEmpty
                    ? 'No file selected. Please select one using the button above me.'
                    : 'Kicks off the import process on the specified data.',
                waitDuration: const Duration(seconds: 1),
                child: ElevatedButton.icon(
                  onPressed: _importFileContents.isEmpty
                      ? null
                      : () => _processImportFile(),
                  icon: const Icon(Icons.upload, size: 18),
                  label: const Text("Import Data Go!"),
                )),
            fancyCheckBox(),
            Expanded(
                child: Visibility(
                    visible: _useSetImportLimits,
                    maintainState: true,
                    child: _mtgFullSetListScroll)),
          ],
        ));
  } // end importPrefsAndData

  Widget _importFilePreview() {
    String sampleText = "File loaded: $_fileLoaded\n";
    sampleText += "Total Entries Loaded: ${_importFileContents.length}\n";
    sampleText += "Sample line from file: ${_importFileContents[0]}";

    return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 20.0),
        child: Text(sampleText,
            style: const TextStyle(fontWeight: FontWeight.w600)));
  }

  void _processImportFile() {}

  void _selectImportFile() async {
    // Lets the user pick one file; files with any file extension can be selected
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    // The result will be null, if the user aborted the dialog
    if (result == null) return;

    PlatformFile file = result.files.first;
    String fileContent = String.fromCharCodes(file.bytes as Iterable<int>);
    setState(() {
      _importFileContents = fileContent.split('\n');
      _fileLoaded = file.name;
    });
  }
}
