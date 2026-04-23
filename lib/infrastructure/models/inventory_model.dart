

class InventoryModel {

  final int id;
  final List<Map<String,dynamic>>? items;

  InventoryModel({required this.id, this.items});

  factory InventoryModel.fromJson( Map<String,dynamic> json ) => InventoryModel(
    id: json['id'],
    items: json['items'] != null
      ? (json['items'] as List)
        .map( (item) => Map<String,dynamic>.from(item))
        .toList()
      : null,
  ); 

}