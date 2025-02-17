import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/ui/shopping/components/product_list_tile.dart';
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
    return Consumer<ShoppingViewModel>(builder: (context, viewModel, _) {
      return Scaffold(
        body: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
              viewModel.onLoadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              for (var entry in viewModel.productSection.entries) ...[
                SliverMainAxisGroup(
                  slivers: [
                    SliverAppBar(title: Text(entry.value.section.title), pinned: true),
                    SliverToBoxAdapter(
                      child: Builder(builder: (context) {
                        final items = entry.value.products.isNotEmpty
                            ? entry.value.products
                            : List.filled(entry.value.skeletonCount, ProductListTile(title: "Item number 1 as title"));

                        if (items.isEmpty && !viewModel.isRecommendProductLoading) {
                          ///TODO show RecommendProduct isEmpty
                        }
                        if (items.isEmpty && !viewModel.isLatestProductsLoading) {
                          ///TODO show LatestProducts isEmpty
                        }

                        switch (entry.value.section) {
                          case PSection.recommend:
                            if (viewModel.recommendProductError != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Image.asset(
                                    'assets/images/error_image.png',
                                    height: 54,
                                    width: 54,
                                  ),
                                  Text(viewModel.recommendProductError!),
                                  FilledButton(
                                      onPressed: () {
                                        viewModel.fetchRecommendProducts();
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
                                itemBuilder: (c, i) => ProductListTile(
                                  title: entry.value.section.title,
                                  onIncrement: () {},
                                  onDecrement: () {},
                                ),
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
                                    itemBuilder: (c, i) => ProductListTile(
                                      title: entry.value.section.title,
                                      onIncrement: () {},
                                      onDecrement: () {},
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: viewModel.isLatestProductsLoading && entry.value.products.isNotEmpty,
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
