import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_job_assignment/api/cart_api.dart';
import 'package:flutter_job_assignment/utils/dio_service.dart';
import 'package:flutter_job_assignment/view_model/shopping_view_model.dart';

class CartViewModel with ChangeNotifier {
  CartApi cartApi = CartApi(dioInstance: DioService.getInstance());
  LinkedHashMap<String, UniqueProduct> cartOrder = LinkedHashMap();

  Future? futureCheckout;

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

  void onDelete(UniqueProduct product) {
    cartOrder.remove(product.uniqueId);
    notifyListeners();
  }

  Future<void> onCheckout({Function()? onSuccess, Function(String error)? onError}) async {
    futureCheckout = cartApi.checkout(cartOrder.entries.map((e) => e.value.id!).toList());

    notifyListeners();
    futureCheckout?.then((r) {
      if (r) {
        cartOrder.clear();
        onSuccess?.call();
      } else {
        onError?.call("Something went wrong");
      }
      notifyListeners();
    }).onError((e, s) {
      onError?.call("Something went wrong");
      return null;
    });
  }

  Map<String, double> calculateDiscount() {
    double totalPriceBeforeDiscount = 0;
    double totalPriceAfterDiscount = 0;
    double totalDiscount = 0;

    cartOrder.forEach((uniqueId, product) {
      num price = product.price ?? 0;
      int pairs = product.count ~/ 2; // Calculate how many pairs of the same product
      int remainingUnits = product.count % 2; // Remaining units after pairs

      // Total price before discount (full price for all items)
      totalPriceBeforeDiscount += product.count * price;

      // Calculate discount for the pairs
      double pairPrice = price * 2;
      double discountPerPair = pairPrice * 0.05;
      double discountedPricePerPair = pairPrice - discountPerPair;

      // Add to the total discount
      totalDiscount += discountPerPair * pairs;

      // Total price after discount (pairs at discounted price and remaining units at full price)
      totalPriceAfterDiscount += pairs * discountedPricePerPair;
      totalPriceAfterDiscount += remainingUnits * price;
    });

    return {
      'totalPriceBeforeDiscount': totalPriceBeforeDiscount,
      'totalPriceAfterDiscount': totalPriceAfterDiscount,
      'totalDiscount': totalDiscount,
    };
  }
}
