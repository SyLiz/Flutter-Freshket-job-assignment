/// items : [{"id":20,"name":"Fish","price":655},{"id":21,"name":"Fish","price":1168},{"id":22,"name":"Table","price":967},{"id":23,"name":"Tuna","price":650},{"id":24,"name":"Chicken","price":798},{"id":25,"name":"Ball","price":1146},{"id":26,"name":"Bike","price":218},{"id":27,"name":"Keyboard","price":761},{"id":28,"name":"Bike","price":857},{"id":29,"name":"Soap","price":1032},{"id":30,"name":"Sausages","price":1002},{"id":31,"name":"Bike","price":1059},{"id":32,"name":"Sausages","price":661},{"id":33,"name":"Chicken","price":685},{"id":34,"name":"Sausages","price":658},{"id":35,"name":"Shoes","price":499},{"id":36,"name":"Keyboard","price":1025},{"id":37,"name":"Bacon","price":469},{"id":38,"name":"Shoes","price":42},{"id":39,"name":"Fish","price":1183}]
/// nextCursor : "Mzk="

class Products {
  Products({
    List<Product>? items,
    String? nextCursor,
  }) {
    _items = items;
    _nextCursor = nextCursor;
  }

  Products.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Product.fromJson(v));
      });
    }
    _nextCursor = json['nextCursor'];
  }
  List<Product>? _items;
  String? _nextCursor;
  Products copyWith({
    List<Product>? items,
    String? nextCursor,
  }) =>
      Products(
        items: items ?? _items,
        nextCursor: nextCursor ?? _nextCursor,
      );
  List<Product>? get items => _items;
  String? get nextCursor => _nextCursor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['nextCursor'] = _nextCursor;
    return map;
  }
}

/// id : 20
/// name : "Fish"
/// price : 655

class Product {
  Product({
    num? id,
    String? name,
    num? price,
  }) {
    _id = id;
    _name = name;
    _price = price;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
  }
  num? _id;
  String? _name;
  num? _price;
  Product copyWith({
    num? id,
    String? name,
    num? price,
  }) =>
      Product(
        id: id ?? _id,
        name: name ?? _name,
        price: price ?? _price,
      );
  num? get id => _id;
  String? get name => _name;
  num? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    return map;
  }
}
