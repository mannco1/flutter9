import 'package:dio/dio.dart';
import 'package:pr_8/models/item.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Item>> getProducts() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/products');
      if (response.statusCode == 200) {
        List<Item> games = (response.data as List)
            .map((game) => Item.fromJson(game))
            .toList();

        return games;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Метод для добавления нового продукта
  Future<void> addProduct(Item item) async {
    try {
      final response = await _dio.post(
        'http://10.0.2.2:8080/products/create',
        data: item.toJson(),
      );
      print(item.toJson().toString());
      if (response.statusCode == 201) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
  // Удаление товара
  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        'http://10.0.2.2:8080/products/delete/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }
// Получение элементов в корзине
  Future<List<BasketItem>> getBasket() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/basket');
      if (response.statusCode == 200) {
        print("Basket Response: ${response.data}"); // Log the response
        List<BasketItem> basket = (response.data as List)
            .map((item) => BasketItem.fromJson(item))
            .toList();

        return basket;
      } else {
        throw Exception('Failed to load basket');
      }
    } catch (e) {
      throw Exception('Error fetching basket: $e');
    }
  }


  Future<Map<String, dynamic>> checkItemInBasket(int gameId) async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/basket/$gameId');
      return response.data;
    } catch (e) {
      print("Error checking basket item: $e");
      return {"isInBasket": false, "itemCount": 0};
    }
  }

  Future<void> addToBasket(int gameId) async {
    await _dio.post('http://10.0.2.2:8080/basket/add', data: {"gameId": gameId});
  }

  Future<void> increaseBasketItem(int gameId) async {
    await _dio.post('http://10.0.2.2:8080/basket/increase', data: {"gameId": gameId});
  }

  Future<void> decreaseBasketItem(int gameId) async {
    await _dio.post('http://10.0.2.2:8080/basket/decrease', data: {"gameId": gameId});
  }

  Future<void> removeFromBasket(int gameId) async {
    await _dio.post('http://10.0.2.2:8080/basket/remove', data: {"gameId": gameId});
  }

  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    try {
      final response = await _dio.put(
        'http://10.0.2.2:8080/products/update/$id',
        data: {"isFavorite": isFavorite},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update favorite status');
      }
    } catch (e) {
      throw Exception('Error updating favorite status: $e');
    }
  }
}