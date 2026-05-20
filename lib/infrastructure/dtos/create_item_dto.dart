class CreateItemDto {
  final String productId;
  final double? quantity;
  final double? totalAmount;
  final double? remainingAmount;
  final AmountUnit? amountUnit;
  final DateTime? expirationDate;

  CreateItemDto({
    required this.productId,
    this.quantity = 1,
    this.totalAmount,
    this.remainingAmount,
    this.amountUnit,
    this.expirationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'amountUnit': amountUnit,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }
}

enum AmountUnit { kg, gr, lt, ml, unit }
