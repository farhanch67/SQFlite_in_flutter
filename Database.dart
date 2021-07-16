import 'package:flutter/cupertino.dart';
import 'package:millionmart/FullApp/MillionMart%20App/ModelClasses/productDetailModel.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBcartManager {
  Database _datebase;

  Future openDB() async {
    if (_datebase == null) {
      _datebase = await openDatabase(
          join(await getDatabasesPath(), "CartDB.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE carts (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price TEXT, image TEXT,Rating TEXT,previous_price TEXT)");
      });
    }
  }

  Future<int> insertStudent(Cart cart) async {
    await openDB();
    return await _datebase.insert('carts', cart.toMap());
  }

  Future<List<Cart>> getStudentList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('carts');

    return List.generate(maps.length, (index) {
      return Cart(
        id: maps[index]['id'],
        name: maps[index]['name'],
        price: maps[index]['price'],
        image: maps[index]['image'],
        rating: maps[index]['rating'],
        previous_price: maps[index]['previous_price'],
      );
    });
  }

  Future<int> updateStudent(Cart cart) async {
    await openDB();
    return await _datebase
        .update('carts', cart.toMap(), where: 'id=?', whereArgs: [cart.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDB();
    await _datebase.delete("carts", where: "id = ? ", whereArgs: [id]);
  }

  void findFvrtDua(String name, String image) async {
    await openDB();
    final res = await _datebase.rawQuery(
        """SELECT * FROM carts WHERE duaclassName LIKE '$name' AND indexNumber == '$image'; """);

    print("Thi is Resss Brother::::::::::::::::::::::::::::::::::::::::::::");
    print(res);
  }
}

class Cart {
  int id;
  String name, price, image, rating, previous_price;

  Cart({
    @required this.name,
    @required this.image,
    @required this.price,
    @required this.rating,
    @required this.previous_price,
    this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'previous_price': previous_price,
      'image': image,
      'rating': rating,
    };
  }
}
