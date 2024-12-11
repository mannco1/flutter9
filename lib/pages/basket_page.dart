import 'package:flutter/material.dart';
import 'package:pr_8/components/basket_element_ui.dart';
import 'package:pr_8/models/item.dart';
import 'package:pr_8/server_api/server_api.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late Future<List<Item>> _products;
  late Future<List<BasketItem>> _basket;
  late Future<int> totalPrice; // Change to late Future<int>

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _basket = ApiService().getBasket();
    totalPrice = _calculateTotalPrice(); // Initialize the total price
  }

  Future<int> _calculateTotalPrice() async {
    final basketItems = await _basket; // Get the latest basket items
    final products = await _products; // Get the latest products

    int total = 0;
    for (var basketItem in basketItems) {
      final product = products.firstWhere((p) => p.id == basketItem.id); // Default Item if not found
      total += product.price * basketItem.counter; // Calculate total price
    }

    return total; // Return the total price as an integer
  }

  Future<void> _deleteGame(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text('Удалить игру из корзины',
              style: TextStyle(
                color: Color.fromRGBO(76, 23, 0, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
        ),
        content: FutureBuilder<List<Item>>(
          future: _products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final product = snapshot.data!.firstWhere((p) => p.id == id);
              return Text(
                'Вы уверены, что хотите удалить "${product.title}"?',
                style: const TextStyle(
                  color: Color.fromRGBO(76, 23, 0, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await ApiService().removeFromBasket(id); // API call
                  setState(() {
                    // Update basket and recalculate total price
                    _basket = ApiService().getBasket();
                    totalPrice = _calculateTotalPrice(); // Recalculate total price
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Да',
                    style: TextStyle(
                      color: Color.fromRGBO(21, 78, 24, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Нет',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Корзина',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<BasketItem>>(
        future: _basket,
        builder: (context, basketSnapshot) {
          if (basketSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!basketSnapshot.hasData || basketSnapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Ваша корзина пуста',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(76, 23, 0, 1.0),
                ),
              ),
            );
          }

          return FutureBuilder<List<Item>>(
            future: _products,
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = productSnapshot.data!;
              return Column(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: basketSnapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final basketItem = basketSnapshot.data![index];
                      final product = products.firstWhere((p) => p.id == basketItem.id);

                      return Dismissible(
                        key: Key(basketItem.id.toString()),
                        confirmDismiss: (direction) async {
                          _deleteGame(basketItem.id);
                          return false; // Prevent default dismiss action
                        },
                        child: BasketElementUi(
                          key: Key(basketItem.id.toString()),
                          game: product,
                          colorName: product.indicator == 1
                              ? 'brown'
                              : product.indicator == 2
                              ? 'pink'
                              : 'blue',
                          textColor: product.indicator == 1
                              ? const Color.fromRGBO(129, 40, 0, 1.0)
                              : product.indicator == 2
                              ? const Color.fromRGBO(163, 3, 99, 1.0)
                              : const Color.fromRGBO(48, 0, 155, 1.0),
                          counter: basketItem.counter,
                          onQuantityChanged: (newCounter) {
                            // Update the total price whenever the quantity changes
                            setState(() {
                              basketItem.counter = newCounter;
                              totalPrice = _calculateTotalPrice(); // Recalculate total price
                            });
                          },
                        ),
                      );
                    },
                  ),

                  FutureBuilder<int>(
                    future: totalPrice, // Use the updated Future<int>
                    builder: (context, priceSnapshot) {
                      if (priceSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          Center(
                            child: Container(
                              width: 324,
                              height: 1, // Change height to 1 for a visible line
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromRGBO(76, 23, 0, 1.0), width: 1.5),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              right: 35.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    'Итог:',
                                    style: TextStyle(
                                      color: Color.fromRGBO(76, 23, 0, 1.0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${priceSnapshot.data ?? 0} ₽',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(76, 23, 0, 1.0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
