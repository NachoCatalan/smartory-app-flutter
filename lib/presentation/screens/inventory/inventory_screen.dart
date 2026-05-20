import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smartory_app/presentation/providers/inventory/inventory_user_provider.dart';
import 'package:smartory_app/presentation/widgets/inputs/inputs.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final searchbarController = SearchController();
  final searchbarNode = FocusNode();
  Timer? debouncer;

  @override
  void dispose() {
    searchbarController.dispose();
    searchbarNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);
    final inventoryNotifier = ref.watch(inventoryProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    void searchItems(String input) async {
      debouncer?.cancel();
      debouncer = Timer(Duration(milliseconds: 500), () async {
        await inventoryNotifier.searchItemsByName(input);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomSearchBar(
          searchBarNode: searchbarNode,
          searchBarController: searchbarController,
          searchCallback: searchItems,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await inventoryNotifier.loadInventory();
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: inventoryAsync.when(
            data: (data) {
              final inventoryItems = data.inventory.items ?? [];
              final searchedItems = data.searchedItems;

              final itemsToShow = searchedItems ?? inventoryItems;
              final isSearching = searchedItems != null;
              if (itemsToShow.isEmpty) {
                return Center(
                  child: Text(
                    isSearching
                        ? 'No se encontraron items'
                        : 'Tu inventario está vacio',
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: screenSize.height * 0.23,
                ),
                itemCount: itemsToShow.length,
                itemBuilder: (context, index) {
                  final item = itemsToShow[index];
                  final product = itemsToShow[index].product;
                  final value = (item.remainingAmount! / item.totalAmount!);
                  final remainingAmount = item.remainingAmount! % 1 == 0
                      ? item.remainingAmount!.toInt()
                      : item.remainingAmount;
                  final totalAmount = item.totalAmount! % 1 == 0
                      ? item.totalAmount!.toInt()
                      : item.totalAmount;

                  final daysToExpire = item.expirationDate
                      ?.difference(DateTime.now())
                      .inDays;

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            // inventoryNotifier.removeItem(item.id!);
                            showDialog(
                              animationStyle: AnimationStyle(
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 300),
                              ),
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    width: screenSize.width * 0.7,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.product.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            child: Column(
                              children: [
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: product.images.first.url,
                                    height: screenSize.height * 0.1,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: screenSize.height * 0.1,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        height: screenSize.height * 0.1,
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    spacing: 4,
                                    children: [
                                      SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        minHeight: 6,
                                        backgroundColor: Colors.grey.shade300,
                                        value: value,
                                        color: value >= 0.7
                                            ? Colors.indigo
                                            : Colors.red,
                                      ),
                                      Text(
                                        (remainingAmount == totalAmount)
                                            ? '$totalAmount ${item.amountUnit?.name.toUpperCase()} restantes'
                                            : '$remainingAmount/$totalAmount ${item.amountUnit?.name.toUpperCase()} restantes',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          product.name,
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      if (daysToExpire != null &&
                                          daysToExpire <= 7)
                                        Text(
                                          '⚠ Vence en $daysToExpire días',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.orange.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Badge.count(
                        count: item.quantity.toInt(),
                        padding: EdgeInsets.all(5),
                        backgroundColor: Colors.indigo,
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text('$error'));
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
