import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  final String code;
  final int status;
  final String statusVerbose;
  final ProductCatalogItem product;

  ProductResponse({
    required this.code,
    required this.status,
    required this.statusVerbose,
    required this.product,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      code: json['code']?.toString() ?? '',
      status: json['status'] ?? 0,
      statusVerbose: json['status_verbose'] ?? '',
      product: ProductCatalogItem.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'status_verbose': statusVerbose,
      'product': product.toJson(),
    };
  }
}

class ProductCatalogItem {
  final String id;
  final String barcode;
  final String name;
  final String? genericName;
  final String? brand;
  final String? category;
  final String? imageUrl;
  final String? quantityLabel;
  final double? quantityValue;
  final String? quantityUnit;
  final String? servingSize;
  final String? ingredientsText;
  final String? country;
  final String? store;
  final String? nutriscoreGrade;
  final String? novaGroup;
  final String? expirationDate;
  final ProductNutriments? nutriments;

  ProductCatalogItem({
    required this.id,
    required this.barcode,
    required this.name,
    this.genericName,
    this.brand,
    this.category,
    this.imageUrl,
    this.quantityLabel,
    this.quantityValue,
    this.quantityUnit,
    this.servingSize,
    this.ingredientsText,
    this.country,
    this.store,
    this.nutriscoreGrade,
    this.novaGroup,
    this.expirationDate,
    this.nutriments,
  });

  factory ProductCatalogItem.fromJson(Map<String, dynamic> json) {
    return ProductCatalogItem(
      id: json['_id']?.toString() ?? '',
      barcode: json['code']?.toString() ?? '',
      name: _pickName(json),
      genericName: _firstNonEmpty([
        json['generic_name_es'],
        json['generic_name'],
      ]),
      brand: _firstBrand(json['brands']),
      category: _firstCategory(json['categories']),
      imageUrl: _firstNonEmpty([
        json['image_front_url'],
        json['image_url'],
        json['image_front_small_url'],
      ]),
      quantityLabel: _firstNonEmpty([
        json['quantity'],
      ]),
      quantityValue: _toDouble(json['product_quantity']),
      quantityUnit: _normalizeUnit(json['product_quantity_unit']),
      servingSize: _firstNonEmpty([
        json['serving_size'],
      ]),
      ingredientsText: _firstNonEmpty([
        json['ingredients_text_es'],
        json['ingredients_text'],
      ]),
      country: _firstCountry(json['countries']),
      store: _firstStore(json['stores']),
      nutriscoreGrade: _firstNonEmpty([
        json['nutriscore_grade'],
      ]),
      novaGroup: _firstNovaGroup(json['nova_groups_tags']),
      expirationDate: _firstNonEmpty([
        json['expiration_date'],
      ]),
      nutriments: json['nutriments'] != null
          ? ProductNutriments.fromJson(json['nutriments'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'generic_name': genericName,
      'brand': brand,
      'category': category,
      'image_url': imageUrl,
      'quantity_label': quantityLabel,
      'quantity_value': quantityValue,
      'quantity_unit': quantityUnit,
      'serving_size': servingSize,
      'ingredients_text': ingredientsText,
      'country': country,
      'store': store,
      'nutriscore_grade': nutriscoreGrade,
      'nova_group': novaGroup,
      'expiration_date': expirationDate,
      'nutriments': nutriments?.toJson(),
    };
  }

  static String _pickName(Map<String, dynamic> json) {
    return _firstNonEmpty([
          json['product_name_es'],
          json['product_name'],
          json['generic_name_es'],
          json['generic_name'],
        ]) ??
        'Producto sin nombre';
  }
}

class ProductNutriments {
  final double? energyKcal100g;
  final double? proteins100g;
  final double? carbohydrates100g;
  final double? fat100g;
  final double? sugars100g;
  final double? salt100g;

  ProductNutriments({
    this.energyKcal100g,
    this.proteins100g,
    this.carbohydrates100g,
    this.fat100g,
    this.sugars100g,
    this.salt100g,
  });

  factory ProductNutriments.fromJson(Map<String, dynamic> json) {
    return ProductNutriments(
      energyKcal100g: _toDouble(json['energy-kcal_100g']),
      proteins100g: _toDouble(json['proteins_100g']),
      carbohydrates100g: _toDouble(json['carbohydrates_100g']),
      fat100g: _toDouble(json['fat_100g']),
      sugars100g: _toDouble(json['sugars_100g']),
      salt100g: _toDouble(json['salt_100g']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'energy_kcal_100g': energyKcal100g,
      'proteins_100g': proteins100g,
      'carbohydrates_100g': carbohydrates100g,
      'fat_100g': fat100g,
      'sugars_100g': sugars100g,
      'salt_100g': salt100g,
    };
  }
}

String? _firstNonEmpty(List<dynamic> values) {
  for (final value in values) {
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _firstBrand(dynamic brands) {
  if (brands == null) return null;
  final text = brands.toString().trim();
  if (text.isEmpty) return null;
  return text.split(',').first.trim();
}

String? _firstCategory(dynamic categories) {
  if (categories == null) return null;
  final text = categories.toString().trim();
  if (text.isEmpty) return null;
  return text.split(',').first.trim();
}

String? _firstCountry(dynamic countries) {
  if (countries == null) return null;
  final text = countries.toString().trim();
  if (text.isEmpty) return null;
  return text.split(',').first.trim();
}

String? _firstStore(dynamic stores) {
  if (stores == null) return null;
  final text = stores.toString().trim();
  if (text.isEmpty) return null;
  return text.split(',').first.trim();
}

String? _firstNovaGroup(dynamic novaGroupsTags) {
  if (novaGroupsTags == null || novaGroupsTags is! List || novaGroupsTags.isEmpty) {
    return null;
  }

  for (final tag in novaGroupsTags) {
    final text = tag.toString();
    if (text.contains('nova-group-')) {
      return text.split('nova-group-').last;
    }
  }

  return null;
}

String? _normalizeUnit(dynamic unit) {
  if (unit == null) return null;

  final value = unit.toString().trim().toLowerCase();

  switch (value) {
    case 'g':
    case 'gr':
    case 'gram':
    case 'grams':
      return 'g';
    case 'kg':
    case 'kilo':
    case 'kilos':
      return 'kg';
    case 'ml':
      return 'ml';
    case 'l':
    case 'lt':
    case 'liter':
    case 'litre':
      return 'l';
    case 'unit':
    case 'unidad':
    case 'un':
      return 'unidad';
    default:
      return value.isEmpty ? null : value;
  }
}