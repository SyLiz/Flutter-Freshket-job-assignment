import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListTile extends StatelessWidget {
  final String title;
  final Function()? onIncrement;
  final Function()? onDecrement;
  const ProductListTile({super.key, required this.title, this.onIncrement, this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,
      title: Text(title),
      leading: Skeleton.keep(child: _productImagePlaceholder()),
      subtitle: Skeleton.leaf(
        child: Row(
          children: [
            const Text('300.00'),
            const Text('/ unit'),
          ],
        ),
      ),
    );
  }

  Widget _productImagePlaceholder() {
    return Image.asset(
      'assets/images/placeholder_product_image.png',
    );
  }
}
