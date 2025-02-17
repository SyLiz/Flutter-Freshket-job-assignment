import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/utils/dio_service.dart';
import '../api/product_api.dart';
import '../model/products.dart';

enum PSection { recommend, latest }

extension MyPSection on PSection {
  String get title {
    switch (this) {
      case PSection.recommend:
        return "Recommend Product";
      case PSection.latest:
        return "Latest Products";
    }
  }
}

class ProductSection {
  final PSection section;
  final List<Product> products;
  final int skeletonCount;
  ProductSection({
    required this.section,
    this.products = const [],
    this.skeletonCount = 7,
  });
}

class ShoppingViewModel with ChangeNotifier {
  final ProductApi productApi = ProductApi(dioInstance: DioService.getInstance());

  Map<PSection, ProductSection> productSection = {
    PSection.recommend: ProductSection(section: PSection.recommend),
    PSection.latest: ProductSection(section: PSection.latest),
  };

  ///Action
  void onLoadMore() {
    if (isLatestProductsLoading) return;
    fetchLatestProducts();
  }

  /// API
  bool isRecommendProductLoading = true;
  String? recommendProductError;
  Future fetchRecommendProducts() async {
    // reset
    recommendProductError = null;
    isRecommendProductLoading = true;
    notifyListeners();

    try {
      final result = await productApi.fetchRecommendedProducts();
      productSection[PSection.recommend] = ProductSection(
        section: PSection.recommend,
        products: result,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      recommendProductError = "Something went wrong";
    }
    isRecommendProductLoading = true;
    notifyListeners();
  }

  String? nextCursor;
  bool isLatestProductsLoading = true;
  String? latestProductsError;
  Future fetchLatestProducts() async {
    // reset
    latestProductsError = null;
    isLatestProductsLoading = true;
    notifyListeners();

    try {
      final result = await productApi.fetchProducts(cursor: nextCursor);
      productSection[PSection.latest] = ProductSection(
        section: PSection.latest,
        products: [
          ...?productSection[PSection.latest]?.products,
          ...?result.items,
        ],
      );
      nextCursor = result.nextCursor;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      latestProductsError = "Something went wrong";
    }
    isLatestProductsLoading = false;
    notifyListeners();
  }
}
