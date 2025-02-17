import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/ui/_components/product_list_tile.dart';
import 'package:flutter_job_assignment/view_model/cart_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Consumer<CartViewModel>(builder: (context, cart, _) {
        final order = cart.cartOrder.entries.toList();
        // Calculate total price and discount
        Map<String, double> result = cart.calculateDiscount();

        // Set precision to 2 decimal places
        // Format the prices with commas and two decimal places
        String formattedTotalPriceBeforeDiscount = formatCurrency(result['totalPriceBeforeDiscount']!);
        String formattedTotalPriceAfterDiscount = formatCurrency(result['totalPriceAfterDiscount']!);
        String formattedTotalDiscount = formatCurrency(result['totalDiscount']!);

        if (isSuccess) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  "Success!",
                  style: TextTheme.of(context).headlineMedium?.copyWith(color: Colors.black),
                ),
                Text(
                  "Thank you for shopping with us!",
                  style: TextTheme.of(context).titleSmall?.copyWith(color: Colors.black),
                ),
                FilledButton(
                  onPressed: context.pop,
                  child: Text("Shop again"),
                ),
              ],
            ),
          );
        }

        if (order.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  "Empty Cart",
                  style: TextTheme.of(context).headlineMedium?.copyWith(color: Colors.black),
                ),
                FilledButton(
                  onPressed: context.pop,
                  child: Text("Go to shopping"),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: order.length,
                itemBuilder: (context, index) {
                  final item = order[index].value;
                  return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(item.uniqueId),
                      onDismissed: (direction) {
                        cart.onDelete(item);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        color: Color(0xffB3261E),
                        child: Image.asset(
                          'assets/icons/delete_ic.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                      child: ProductListTile(
                        title: item.name ?? '',
                        price: item.price ?? 0.0,
                        count: cart.cartOrder[item.uniqueId]?.count ?? 0,
                        onIncrement: () => cart.addToCart(item),
                        onDecrement: () => cart.decrementFromCart(item),
                      ));
                },
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Color(0xffe8def8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: TextTheme.of(context).titleMedium?.copyWith(color: Color(0xff4F378A)),
                        ),
                        Text(
                          formattedTotalPriceBeforeDiscount,
                          style: TextTheme.of(context).titleMedium?.copyWith(color: Color(0xff4F378A)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Promotion discount",
                          style: TextTheme.of(context).titleMedium?.copyWith(color: Color(0xff4F378A)),
                        ),
                        Text(
                          "-$formattedTotalDiscount",
                          style: TextTheme.of(context).titleMedium?.copyWith(color: Color(0xffB3261E)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 193,
                          child: Text(
                            formattedTotalPriceAfterDiscount,
                            style: TextTheme.of(context).headlineLarge?.copyWith(color: Color(0xff4F378A)),
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          flex: 177,
                          child: FutureBuilder(
                            future: cart.futureCheckout,
                            builder: (context, snapshot) {
                              final isLoading = snapshot.connectionState == ConnectionState.waiting;
                              return FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        cart.onCheckout(
                                          onSuccess: () {
                                            setState(() {
                                              isSuccess = true;
                                            });
                                          },
                                          onError: (error) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                padding: EdgeInsets.only(left: 24, right: 16),
                                                backgroundColor: Color(0xffB3261E),
                                                content: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      error,
                                                      style: TextTheme.of(context)
                                                          .bodyMedium
                                                          ?.copyWith(color: Colors.white),
                                                    ),
                                                    IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: () {
                                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                        },
                                                        icon: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                style: FilledButton.styleFrom(
                                  textStyle: TextTheme.of(context).labelLarge,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text("Checkout"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
