import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/presentation/providers/catalogue/products_provider.dart';

class ProductCarrousel extends ConsumerStatefulWidget {
  const ProductCarrousel({super.key, required this.screenSize});

  final Size screenSize;

  @override
  ConsumerState<ProductCarrousel> createState() => _ProductCarrouselState();
}

class _ProductCarrouselState extends ConsumerState<ProductCarrousel> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 26,
          child: Text(
            'Catalogo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: (widget.screenSize.height * 0.35),
          child: productsAsync.when(
            data: (productState) {
              final products = productState.products;
              if (products == null) {
                return const Center(child: Text('No hay productos'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Stack(
                    children: [
                      Container(
                        width: widget.screenSize.width * 0.82,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  product.images.first.url,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.category,
                              style: TextStyle(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton.filled(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(Icons.add, size: 30),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            loading: () {
              return CircularProgressIndicator();
            },
            error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            },
          ),
        ),
      ],
    );
  }
}
