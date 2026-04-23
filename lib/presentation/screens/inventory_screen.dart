import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartory_app/presentation/providers/inventory_user_provider.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        actions: [
          IconButton(onPressed: () {
            ref.read(inventoryProvider.notifier).loadInventory();
          }, icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InventoryItems(),
      ),
    );
  }
}

class InventoryItems extends ConsumerStatefulWidget {
  const InventoryItems({super.key});

  @override
  ConsumerState<InventoryItems> createState() => _InventoryItemsState();
}

class _InventoryItemsState extends ConsumerState<InventoryItems> {
  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);
    return inventoryAsync.when(
      data: (inventoryState) {
        final inventory = inventoryState.inventory;
        if (inventory.items == null)
          return Center(child: Text('Inventario vacio'));
        return GridView.builder(
          itemCount: inventory.items?.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final item = inventory.items?[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item!.product.images.first.url),
                        ),
                      ),
                      Text(item.product.name),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: IconButton.filled(
                      constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(Icons.add, size: 22),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
    );
  }
}
