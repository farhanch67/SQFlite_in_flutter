import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class CdataBase{

 // Private Constructor which allow only one instance of our BD Class
 CdataBase._privateConstructor();
 static final dBInstance = CdataBase._privateConstructor();

 // DB Package Instance
 static  Database _dataBase;

 //DB Version and Name
 static final _databaseVersion = 1;
 static final _databaseName = "FavItemDB.db";

 //Table Columns Name
 static final _tableName = "favItems";
 static final _columnID = "id";
 static final _prodcutName = "name";
 static final _productRating = "rating";
 static final _productPrice = "price";
 static final _productDiscount = "discount";
 static final _productImage = "image";

 //Method to call/create a DataBase

 Future<Database> get openDb async{
   if(_dataBase!=null) return _dataBase;
   
   _dataBase = await _initDataBase();
   return _dataBase;

 }

  //Method to initialize a Data Base
  _initDataBase() async {

      //Data Base Path

      Directory dbDirectory = await getApplicationDocumentsDirectory();
      //Join is called and stored in a string
      String path = join(dbDirectory.path,_databaseName);

      //This Function Return OpenDaraBase Function of SQFlite Package
      //_onreate is a method to create tables in a DB
      return await openDatabase(path,version: _databaseVersion,onCreate: _onCreate);

  }

 // Method To Create a Tables in a DB
 Future _onCreate(Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE $_tableName(
      $_columnID INTEGER PRIMARY KEY,
      $_prodcutName TEXT NOT NULL,
      $_productPrice INT ,
      $_productRating TEXT ,
      $_productDiscount INT ,
      $_productImage TEXT,
      )
      '''
    );
 }


// CRUD operations Functions
//Insert Data in DataBase

  Future<int> insertItems (FavoriteItemsModel insertData) async {
     Database db = await dBInstance.openDb;
     return await db.insert(_tableName, insertData.toMap());
  }

  Future<List<FavoriteItemsModel>> getStudentList() async {

    final List<Map<String, dynamic>> maps = await _datebase.query('carts');
    Database db = await dBInstance.openDb;
    return List.generate(maps.length, (index) {
      return FavoriteItemsModel(
        name: maps[index]['name'],
        price: maps[index]['price'],
        image: maps[index]['image'],
        rating: maps[index]['rating'],
        previousPrice: maps[index]['previous_price'],
      );
    });
  }
}

class FavoriteItemsModel{
  String name, price, image, rating, previousPrice;

  FavoriteItemsModel({
    @required this.name,
    @required this.image,
    @required this.price,
    @required this.rating,
    @required this.previousPrice,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'discount': previousPrice,
      'image': image,
      'rating': rating,
    };
  }
}

