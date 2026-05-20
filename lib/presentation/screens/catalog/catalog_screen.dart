import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/presentation/providers/providers.dart';
import 'package:smartory_app/presentation/widgets/widgets.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final searchBarController = TextEditingController();
  final searchBarNode = FocusNode();

  Timer? debouncer;
  @override
  void dispose() {
    searchBarController.dispose();
    searchBarNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryNotifier = ref.read(inventoryProvider.notifier);
    final productNotifier = ref.read(productsProvider.notifier);
    final productsAsync = ref.watch(productsProvider);
    final size = MediaQuery.of(context).size;

    void searchProduct(String input) async {
      debouncer?.cancel();

      debouncer = Timer(Duration(milliseconds: 500), () async {
        await productNotifier.searchProductsByName(input);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomSearchBar(
          searchCallback: searchProduct,
          searchBarNode: searchBarNode,
          searchBarController: searchBarController,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            productsAsync.when(
              data: (data) {
                final products = data.products;
                if (products == null || products.isEmpty) {
                  return Center(child: Text('Producto(s) no encontrado(s)'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        child: ListTile(
                          leading: SizedBox(
                            width: size.width * 0.15,
                            child: ClipRRect(
                              child: Image.network(
                                product.images.first.url,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          title: Text(product.name),
                          subtitle: Text(product.category),
                          onTap: () {
                            showDialog(
                              animationStyle: AnimationStyle(
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 500),
                              ),
                              context: context,
                              builder: (context) {
                                bool isLoading = false;
                                final quantityController =
                                    TextEditingController();
                                final dateController = TextEditingController();
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Align(
                                      alignment: AlignmentGeometry.topCenter,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 50),
                                          width: size.width * 0.7,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: SizedBox(
                                                    height: size.height * 0.18,
                                                    child: Image.network(
                                                      product.images.first.url,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  product.description,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    Chip(
                                                      label: Text(
                                                        product.category,
                                                      ),
                                                    ),
                                                    Chip(
                                                      label: Text(
                                                        product.producer,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      child: TextFormField(
                                                        controller:
                                                            quantityController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputDecoration(
                                                          labelText: 'Cantidad',
                                                          hintText: '2',
                                                          filled: true,
                                                          fillColor: Colors
                                                              .grey
                                                              .shade100,
                                                          prefixIcon: Icon(
                                                            Icons.numbers,
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  14,
                                                                ),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: DatepickerInput(
                                                        dateController:
                                                            dateController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 24),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: FilledButton.icon(
                                                    onPressed: isLoading
                                                        ? null
                                                        : () async {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            DateTime? date;

                                                            if (dateController
                                                                .text
                                                                .isNotEmpty) {
                                                              final parts =
                                                                  dateController
                                                                      .text
                                                                      .split(
                                                                        '/',
                                                                      );

                                                              date = DateTime(
                                                                int.parse(
                                                                  parts[2],
                                                                ),
                                                                int.parse(
                                                                  parts[1],
                                                                ),
                                                                int.parse(
                                                                  parts[0],
                                                                ),
                                                              );
                                                            }
                                                            final quantity =
                                                                double.tryParse(
                                                                  quantityController
                                                                      .text,
                                                                );
                                                            final item =
                                                                InventoryItem(
                                                                  product:
                                                                      product,
                                                                  quantity:
                                                                      quantity ??
                                                                      1.0,
                                                                  expirationDate:
                                                                      date,
                                                                );
                                                            await inventoryNotifier
                                                                .addItem(item);

                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Item agregado correctamente',
                                                                ),
                                                              ),
                                                            );

                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                    icon: isLoading
                                                        ? const SizedBox(
                                                            width: 18,
                                                            height: 18,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .add_shopping_cart,
                                                          ),
                                                    label: Text(
                                                      isLoading
                                                          ? 'Agregando...'
                                                          : 'Agregar al inventario',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text('$error'));
              },
              loading: () {
                return Center(child: LinearProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
