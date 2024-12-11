class Item{
  final int id;
  final String title;
  final String image;
  final String description;
  final int price;
  final int indicator;
  bool isFavorite;

  Item(
      {required this.id,
        required this.title,
        required this.image,
        required this.description,
        required this.price,
        required this.indicator,
        required this.isFavorite
      });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ID'].toInt() ?? 0,
      title: json['Title'] ?? '',
      image: json['ImageURL'] ?? '',
      description: json['Description'] ?? '',
      price: json['Price'].toInt() ?? 0,
      indicator: json['Indicator'] ?? 1,
      isFavorite: json['IsFavorite'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Title': title,
      'ImageURL': image,
      'Description': description,
      'Price': price,
      'Indicator': indicator
    };
  }
}

class BasketItem{
  final int id;
  int counter;

  BasketItem(
    {
      required this.id,
      required this.counter
    }
  );

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json['ID'].toInt() ?? 0,
      counter: json['Counter'] ?? 0,
    );
  }
}

class User{
  String name;
  String surname;
  String patronymic;
  String email;
  String telNumber;
  String image;

  User(this.name, this.surname, this.patronymic, this.email, this.telNumber, this.image);
}

User admin = User('Михаил', 'Мудрицын', 'Евгеньевчи', 'mudritsyn.m.e@edu.mirea.ru', '+7 (666) 111-14-88', 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Evola.jpg');