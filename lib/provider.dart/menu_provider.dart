import 'package:flutter/material.dart';
import 'package:text_recognition/model/menu.dart';
import 'package:text_recognition/service/database.dart';

class MenuProvider extends ChangeNotifier {
  List<Menu> _menu = [];
  List<Menu> get menuModel => _menu;

  Future<void> getMenu() async {
    _menu = [];
    var result = await DBProvider.db.getMenus();
    for (var i = 0; i < result.length; i++) {
      _menu.add(Menu.fromJson(result[i]));
    }
    notifyListeners();
  }

  Future<void> add(String name) async {
    int id = 0;
    var result = await DBProvider.db.getMaxMenuId();
    if (result != [] && result != null) {
      id = result[0]['id'] ?? 0;
    }

    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    await DBProvider.db
        .insertMenu('Menu', {"name": name, "created_at": date, "id": id});
    _menu.add(Menu(name: name, createdAt: date, id: id));
    notifyListeners();
  }

  Future<void> deleteMenu(int? id) async {
    _menu = _menu.where((element) => element.id != id).toList();
    await DBProvider.db.deleteMenu(id);
    notifyListeners();
  }
}
