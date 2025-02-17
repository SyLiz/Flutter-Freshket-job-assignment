import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_job_assignment/view_model/shopping_view_model.dart';

class CartViewModel with ChangeNotifier {
  LinkedHashMap<String, UniqueProduct> cartOrder = LinkedHashMap();

  void addToCart(UniqueProduct product) {
    if (cartOrder.containsKey(product.uniqueId)) {
      // Update the count if product already exists
      cartOrder[product.uniqueId] = cartOrder[product.uniqueId]!.copyWithUnique(
        count: cartOrder[product.uniqueId]!.count + 1,
      );
    } else {
      // Add new product if uniqueId is not in cart
      cartOrder[product.uniqueId] = product.copyWithUnique(count: 1);
    }
    notifyListeners();
  }

  void decrementFromCart(UniqueProduct product) {
    if (cartOrder.containsKey(product.uniqueId)) {
      final currentCount = cartOrder[product.uniqueId]!.count;

      if (currentCount > 1) {
        // Decrease the count if it's more than 1
        cartOrder[product.uniqueId] = cartOrder[product.uniqueId]!.copyWithUnique(
          count: currentCount - 1,
        );
      } else {
        // Remove product from cart if count is 1 or less
        cartOrder.remove(product.uniqueId);
      }
      notifyListeners();
    }
  }
}
