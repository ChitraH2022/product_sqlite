import 'package:sqflite/sqflite.dart';
import 'package:product_sqlite/database/db_helper.dart';

class ProductRepository {
  final DBHelper _dbHelper = DBHelper();

  Future<int> addProduct(Map<String, dynamic> product) async {
    return await _dbHelper.insert(product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    return await _dbHelper.queryAll();
  }

  Future<int> updateProduct(Map<String, dynamic> product, int id) async {
    return await _dbHelper.update(product, id);
  }

  Future<int> deleteProduct(int id) async {
    return await _dbHelper.delete(id);
  }
}
