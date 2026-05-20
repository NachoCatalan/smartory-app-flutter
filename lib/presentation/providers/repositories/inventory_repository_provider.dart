import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartory_app/domain/repositories/inventory_repository.dart';

import 'package:smartory_app/infrastructure/datasources/datasources.dart';
import 'package:smartory_app/infrastructure/repositories/inventory_repository_impl.dart';

import 'package:smartory_app/presentation/providers/providers.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final datasource = InventoryDbDatasourceImpl(
    getValidAccessToken: ref.read(authProvider.notifier).getValidAccessToken,
  );
  return InventoryRepositoryImpl(datasource: datasource);
});
