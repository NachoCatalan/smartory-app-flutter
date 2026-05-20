import 'package:flutter/material.dart';
import 'package:smartory_app/domain/entities/entities.dart';

class ActionSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<InventoryInstruction> items;

  const ActionSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...items.map((item) => _AudioResultItem(item: item)),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _AudioResultItem extends StatefulWidget {
  final InventoryInstruction item;

  const _AudioResultItem({required this.item});

  @override
  State<_AudioResultItem> createState() => _AudioResultItemState();
}

class _AudioResultItemState extends State<_AudioResultItem> {
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    if (widget.item.matches.isNotEmpty) {
      selectedProduct = widget.item.matches.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final matches = item.matches;
    final hasMultipleMatches = widget.item.matches.length > 1;

    if (hasMultipleMatches) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elige el producto para "${item.productToFind}"',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),

            const SizedBox(height: 4),

            Text(
              'Cantidad a modificar: ${item.quantity} ${item.unit}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 90,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.92),
                itemCount: matches.length,
                onPageChanged: (index) {
                  setState(() {
                    selectedProduct = matches[index];
                  });
                },
                itemBuilder: (context, index) {
                  final product = matches[index];
                  final isSelected = selectedProduct?.id == product.id;
                  final imageUrl = product.images.isNotEmpty
                      ? product.images.first.url
                      : 'https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange.shade100
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Cantidad: ${item.quantity} ${item.unit}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  isSelected
                                      ? 'Seleccionado'
                                      : 'Desliza para elegir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.orange.shade800
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.orange,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return _SingleProductResultItem(item: item);
  }
}

class _SingleProductResultItem extends StatelessWidget {
  final InventoryInstruction item;

  const _SingleProductResultItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.matches.isNotEmpty ? item.matches[0] : null;
    final imageUrl = product?.images.first.url;
    final quantity = item.quantity;
    final status = item.status;
    final unit = item.unit;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl ??
                  'https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.name ?? item.productToFind,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),

                Text('Cantidad: $quantity $unit'),

                Text(
                  'Estado: $status',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
