import 'package:flutter/material.dart';
import 'package:pr_8/models/item.dart';
import 'package:pr_8/pages/info_page.dart';
import 'package:pr_8/components/item_list.dart';
import 'package:pr_8/server_api/server_api.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Item> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    loadFavorites(); // Load favorites on page initialization
  }

  Future<void> loadFavorites() async {
    try {
      final allItems = await ApiService().getProducts();
      setState(() {
        favoriteItems = allItems.where((item) => item.isFavorite).toList();
      });
    } catch (error) {
      print("Ошибка загрузки избранных товаров: $error");
    }
  }

  void updateFavoriteStatus(Item item, bool isFavorite) {
    setState(() {
      item.isFavorite = isFavorite;
      if (isFavorite) {
        favoriteItems.add(item);
      } else {
        favoriteItems.remove(item);
      }
    });
    ApiService().updateFavoriteStatus(item.id, isFavorite); // Обновление на сервере
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Избранное',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.only(
            right: 20.0,
            left: 20.0,
          ),
          child: Text(
            'У Вас нет избранных товаров',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(76, 23, 0, 1.0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 15.0,
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            childAspectRatio: 161 / 205,
          ),
          itemCount: favoriteItems.length,
          itemBuilder: (BuildContext context, int index) {
            final item = favoriteItems[index];
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InfoPage(game: item),
                  ),
                );
                if (result is Item) {
                  setState(() {
                    favoriteItems[index] = result;
                  });
                }
              },
              child: ItemList(
                key: Key(item.title),
                game: item,
              ),
            );
          },
        ),
      ),
    );
  }
}
