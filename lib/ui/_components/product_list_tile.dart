import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListTile extends StatelessWidget {
  final String title;
  final num price;
  final int count;
  final Function()? onIncrement;
  final Function()? onDecrement;
  const ProductListTile({
    super.key,
    required this.title,
    required this.price,
    this.onIncrement,
    this.onDecrement,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,
      leading: Skeleton.keep(child: _productImagePlaceholder()),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(color: Color(0xff21005D), fontWeight: FontWeight.w500),
      ),
      subtitle: Skeleton.leaf(
        child: Row(
          children: [
            Text(
              formatCurrency(price),
              style: TextTheme.of(context).titleSmall?.copyWith(color: Color(0xff4F378B)),
            ),
            Text(
              ' / unit',
              style: TextTheme.of(context).titleSmall?.copyWith(color: Color(0xff625B71)),
            ),
          ],
        ),
      ),
      trailing: Builder(builder: (context) {
        if (count > 0) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.333,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(color: Colors.white, onPressed: onDecrement, icon: Icon(Icons.remove)),
                Text(
                  count.toString(),
                  style: TextTheme.of(context).titleMedium,
                ),
                IconButton.filled(color: Colors.white, onPressed: onIncrement, icon: Icon(Icons.add)),
              ],
            ),
          );
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.333,
          child: FilledButton(onPressed: onIncrement, child: Text("Add to cart")),
        );
      }),
    );
  }

  Widget _productImagePlaceholder() {
    return Image.asset(
      'assets/images/placeholder_product_image.png',
    );
  }
}
