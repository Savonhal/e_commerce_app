import 'package:e_commerce_app/models/Products.dart';
import 'package:e_commerce_app/on_generate_routes.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({ Key? key, required this.product }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/product_page', arguments: product);
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover
                    )
                ),
              ),
              const SizedBox(height:10),
              Text(
                product.title,
                maxLines:2,
                style: const TextStyle( fontFamily: 'avenir', fontWeight: FontWeight.w800),
                overflow: TextOverflow.fade,
              ),
              IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal:4, vertical:2),
                  child: Row(
                    children: [
                      Text(
                        '${product.rating.toString()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white
                      )
                    ],
                  )
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${product.price}',
                style: const TextStyle(fontSize: 32, fontFamily: 'avenir'),
              )
            ],
          )
        )
      ),
    );
  }
}