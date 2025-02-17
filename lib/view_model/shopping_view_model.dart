import 'package:flutter/foundation.dart';
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

class UniqueProduct extends Product {
  final String uniqueId;
  final int count;

  UniqueProduct({
    required this.uniqueId,
    required this.count,
    required super.id,
    required super.name,
    required super.price,
  });

  UniqueProduct copyWithUnique({
    String? uniqueId,
    int? count,
    num? id,
    String? name,
    num? price,
  }) {
    return UniqueProduct(
      uniqueId: uniqueId ?? this.uniqueId,
      count: count ?? this.count,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

class ProductSection {
  final PSection section;
  final List<UniqueProduct> products;
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
        skeletonCount: 4,
        products: createUniqueProducts(PSection.latest, result),
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
      final items = result.items;
      if (items != null) {
        productSection[PSection.latest] = ProductSection(
          section: PSection.latest,
          products: [
            ...?productSection[PSection.latest]?.products,
            ...createUniqueProducts(PSection.latest, items),
          ],
        );
      }

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

  List<UniqueProduct> createUniqueProducts(PSection section, List<Product> products) {
    return products.map((p) {
      return UniqueProduct(
        uniqueId: "$section${p.id}${p.name}", // Generate uniqueId based on product ID
        count: 0,
        id: p.id,
        name: p.name,
        price: p.price,
      );
    }).toList();
  }
}
