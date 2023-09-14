import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:intl/intl.dart';

class ProductThumbnail extends StatelessWidget {
  final product;
  final void Function() onTap;
  const ProductThumbnail({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FancyShimmerImage(
                imageUrl: product['images'][0],
                imageBuilder: (context, imageProvider) {
                  return Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  );
                },
                errorWidget: Image.asset(
                  "assets/images/picture_failed.png",
                ),
              ),
            ),
            Text(
              maxLines: 2,
              textAlign: TextAlign.center,
              product['name'].toString(),
              style: TextStyle(
                color: primaryColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              NumberFormat.currency(locale: 'en_US', symbol: '₹ ')
                  .format(product['price']),
              // "₹ " + product['price'].toString(),
              maxLines: 1,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
