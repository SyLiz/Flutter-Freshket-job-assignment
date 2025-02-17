import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/ui/shopping/components/product_list_tile.dart';
import 'package:flutter_job_assignment/view_model/cart_view_model.dart';
import 'package:flutter_job_assignment/view_model/shopping_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shippingViewModel = Provider.of<ShoppingViewModel>(context, listen: false);
      shippingViewModel.fetchRecommendProducts();
      shippingViewModel.fetchLatestProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingViewModel>(builder: (context, shopping, _) {
      return Scaffold(
        body: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
              shopping.onLoadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              for (var entry in shopping.productSection.entries) ...[
                SliverMainAxisGroup(
                  slivers: [
                    SliverAppBar(title: Text(entry.value.section.title), pinned: true),
                    SliverToBoxAdapter(
                      child: Consumer<CartViewModel>(builder: (context, cart, _) {
                        final items = entry.value.products.isNotEmpty
                            ? entry.value.products
                                .map((item) => ProductListTile(
                                      title: item.name ?? '',
                                      price: item.price ?? 0.0,
                                      count: cart.cartOrder[item.uniqueId]?.count ?? 0,
                                      onIncrement: () => cart.addToCart(item),
                                      onDecrement: () => cart.decrementFromCart(item),
                                    ))
                                .toList()
                            : List.filled(
                                entry.value.skeletonCount,
                                ProductListTile(
                                  title: "Item number 1 as title",
                                  price: 0,
                                )).toList();

                        if (items.isEmpty && !shopping.isRecommendProductLoading) {
                          ///TODO show RecommendProduct isEmpty
                        }
                        if (items.isEmpty && !shopping.isLatestProductsLoading) {
                          ///TODO show LatestProducts isEmpty
                        }

                        switch (entry.value.section) {
                          case PSection.recommend:
                            if (shopping.recommendProductError != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Image.asset(
                                    'assets/images/error_image.png',
                                    height: 54,
                                    width: 54,
                                  ),
                                  Text(shopping.recommendProductError!),
                                  FilledButton(
                                      onPressed: () {
                                        shopping.fetchRecommendProducts();
                                      },
                                      child: Text("Refresh")),
                                ],
                              );
                            }
                            return Skeletonizer(
                              enabled: entry.value.products.isEmpty,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (c, i) => items[i],
                              ),
                            );
                          case PSection.latest:
                            return Column(
                              children: [
                                Skeletonizer(
                                  enabled: entry.value.products.isEmpty,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (c, i) => items[i],
                                  ),
                                ),
                                Visibility(
                                  visible: shopping.isLatestProductsLoading && entry.value.products.isNotEmpty,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          CircularProgressIndicator(),
                                          Text("Loading"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      }),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
