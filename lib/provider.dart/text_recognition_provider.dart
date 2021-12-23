import 'package:flutter/material.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_recognition/model/sub_category.dart';
import 'package:text_recognition/service/database.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class TextRecognitionState extends ChangeNotifier {
  InputImage? _image;
  RecognizedText? ddata;
  bool _isProcessing = false;

  InputImage? get image => _image;
  RecognizedText? get data => ddata;
  String get text => ddata!.text;
  bool get isNotProcessing => !_isProcessing;
  bool get isNotEmpty => ddata != null && text.isNotEmpty;

  List<SubCategoryModel> _subCategory = [
    SubCategoryModel(
        createdOn: "342/342/34",
        id: 3,
        pin: "first",
        price: "dfaf",
        serial: "dfa"),
    SubCategoryModel(
        createdOn: "23/234/3424",
        id: 3,
        pin: "second",
        price: "dfaf",
        serial: "dfa")
  ];

  List<SubCategoryModel> get subCategoryModel => _subCategory;

  Future<void> addSubCategory(
      int? menuId, String pin, String price, String serial) async {
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    int id = 0;
    var result = await DBProvider.db.getSubCategoryId();
    if (result != [] && result != null) {
      id = result[0]['id'] ?? 0;
    }

    await DBProvider.db.insertSubCategory('SubCategory', {
      "menuId": menuId,
      "pin": pin,
      "price": price,
      "serial": serial,
      "created_on": date,
      "id": id
    });
    _subCategory.add(SubCategoryModel(
        createdOn: date,
        id: id,
        pin: pin,
        price: price,
        serial: serial,
        menuId: menuId));
    notifyListeners();
  }

  Future<void> getSubCategory(int? menuId) async {
    _subCategory = [];
    // notifyListeners();
    var result = await DBProvider.db.getSubCategory(menuId);
    // print(result);
    for (var i = 0; i < result.length; i++) {
      _subCategory.add(SubCategoryModel.fromJson(result[i]));
    }
    notifyListeners();
  }

  Future<void> deleteSubCategory(int? id) async {
    _subCategory = _subCategory.where((element) => element.id != id).toList();
    await DBProvider.db.deleteSubCategory(id);
    notifyListeners();
  }

  Future<void> export() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0]; //first worksheet

    sheet.importList([
      "PinCode",
      "SerialNumber",
      "CardType",
    ], 1, 1, false);
    for (var i = 0; i < _subCategory.length; i++) {
      sheet.importList([
        _subCategory[i].pin,
        _subCategory[i].serial,
        _subCategory[i].price,
      ], i + 2, 1, false);
    }

    // sheet.getRangeByName("A1").setText('zaid salah');
    // sheet.importList(list2, 2, 1, false);

    final List<int> bytes = workbook.saveAsStream();

    Directory tempDir = (await getApplicationSupportDirectory());
    final String tempPath = tempDir.path;
    final String fileName = '$tempPath/output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    // await OpenFile.open(fileName);
    await Share.shareFiles([fileName], text: "share excel file");
    workbook.dispose();
    // print("file name is $fileName");

    // print('let is doing export to excel');
    // for (var i = 0; i < _subCategory.length; i++) {
    //   print(
    //       "${_subCategory[i].pin} - ${_subCategory[i].serial} - ${_subCategory[i].price} - ${_subCategory[i].createdOn}");
    // }
  }

  void startProcessing() {
    ddata = null;
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    // ddata = null;
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;
    notifyListeners();
  }

  set data(RecognizedText? data) {
    ddata = data;
    notifyListeners();
  }
}
