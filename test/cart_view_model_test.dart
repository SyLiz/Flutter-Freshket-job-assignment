import 'package:flutter_job_assignment/config/app_config.dart';
import 'package:flutter_job_assignment/utils/dio_service.dart';
import 'package:flutter_job_assignment/view_model/shopping_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_job_assignment/view_model/cart_view_model.dart';

void main() {
  AppConfig.initialize(EnvironmentConfig.development);

  group('Cart order test', () {
    late CartViewModel cartViewModel;
    setUp(() {
      DioService.getInstance(baseUrl: AppConfig.baseURL);
      cartViewModel = CartViewModel();
    });

    final dummyProductA = UniqueProduct(uniqueId: "Product A", count: 0, id: 1, name: "Product A", price: 200);
    final dummyProductB = UniqueProduct(uniqueId: "Product B", count: 0, id: 2, name: "Product B", price: 150);
    final dummyProductC = UniqueProduct(uniqueId: "Product C", count: 0, id: 3, name: "Product c", price: 100);

    test('should return same value of item that add to cart', () {
      cartViewModel.addToCart(dummyProductA);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.uniqueId, dummyProductA.uniqueId);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.name, dummyProductA.name);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.price, dummyProductA.price);
    });

    test('item count should decrement by 1 and if count = 0 should remove from cart', () {
      cartViewModel.addToCart(dummyProductA);
      cartViewModel.addToCart(dummyProductA);
      //check item count should be 2
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.count, 2);

      cartViewModel.decrementFromCart(dummyProductA);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.uniqueId, dummyProductA.uniqueId);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.count, 1);
    });

    test('in case of count = 0 then should remove from cart', () {
      cartViewModel.addToCart(dummyProductA);
      //check cart is already have dummyProductA
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.uniqueId, dummyProductA.uniqueId);

      cartViewModel.decrementFromCart(dummyProductA);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.uniqueId, isNull);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.name, isNull);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.price, isNull);
    });

    test('should not have item that remove from cart (return null)', () {
      cartViewModel.addToCart(dummyProductA);
      cartViewModel.addToCart(dummyProductA);
      cartViewModel.addToCart(dummyProductA);
      cartViewModel.addToCart(dummyProductA);
      //check cart is already have dummyProductA
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.count, 4);

      cartViewModel.onDelete(dummyProductA);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.uniqueId, isNull);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.name, isNull);
      expect(cartViewModel.cartOrder[dummyProductA.uniqueId]?.price, isNull);
    });

    test('Calculate discount based on example scenario', () {
      cartViewModel.cartOrder[dummyProductA.uniqueId] = dummyProductA.copyWithUnique(count: 3);
      cartViewModel.cartOrder[dummyProductB.uniqueId] = dummyProductB.copyWithUnique(count: 4);
      cartViewModel.cartOrder[dummyProductC.uniqueId] = dummyProductC.copyWithUnique(count: 1);

      // Perform discount calculation
      final discountResult = cartViewModel.calculateDiscount();

      // Expected values
      double expectedTotalBeforeDiscount = (3 * 200) + (4 * 150) + (1 * 100); // 600 + 600 + 100 = 1300
      double expectedDiscount = (1 * (2 * 200 * 0.05)) + (2 * (2 * 150 * 0.05)); // 20 + 30 = 50
      double expectedTotalAfterDiscount = expectedTotalBeforeDiscount - expectedDiscount; // 1250

      // Assertions
      expect(discountResult['totalPriceBeforeDiscount'], expectedTotalBeforeDiscount);
      expect(discountResult['totalPriceAfterDiscount'], expectedTotalAfterDiscount);
      expect(discountResult['totalDiscount'], expectedDiscount);
    });
  });
}
