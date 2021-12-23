import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/screens/text_recognition_page.dart';

import '../provider.dart/text_recognition_provider.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key, this.menuId}) : super(key: key);
  final int? menuId;
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  TextEditingController divisionValue = TextEditingController();
  TextEditingController secretNumber = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  void dispose() {
    divisionValue.dispose();
    secretNumber.dispose();
    serialNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Data Information"),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextRecognitionPage()));

                  if (Provider.of<TextRecognitionState>(context, listen: false)
                          .data !=
                      null) {
                    var data = Provider.of<TextRecognitionState>(context,
                            listen: false)
                        .data!
                        .text
                        .split("\n");
                    bool first = false;
                    bool second = false;
                    for (var item in data) {
                      item = item.replaceAll(" ", '');
                      item = item.replaceAll(RegExp(r'[^0-9]'), '');
                      if (isNumeric(item) &&
                          first == false &&
                          item.length > 3) {
                        first = true;
                        divisionValue.text = item;
                        continue;
                      }
                      if (first == true && isNumeric(item) && second == false) {
                        secretNumber.text = item;
                        second = true;
                        continue;
                      }
                      if (second == true &&
                          isNumeric(item) &&
                          item.length < 12 &&
                          item.length > 5) {
                        serialNumber.text = item;
                        break;
                      }
                    }
                  }
                  Provider.of<TextRecognitionState>(context, listen: false)
                      .ddata = null;
                },
                icon: const Icon(Icons.add_a_photo)),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: divisionValue,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'division value',
                    hintText: 'Enter division value'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: secretNumber,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'secret number',
                  hintText: 'Enter secret number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: serialNumber,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Serial number',
                    hintText: 'Enter Serial number'),
              ),
            ),
            ElevatedButton(
              style: style,
              onPressed: () {
                Provider.of<TextRecognitionState>(context, listen: false)
                    .addSubCategory(widget.menuId, secretNumber.text,
                        divisionValue.text, serialNumber.text);
                secretNumber.clear();
                serialNumber.clear();
                divisionValue.clear();
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
