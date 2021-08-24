class ObjectItemDataHolder {
  final String name;
  final String description;
  final Object object;
  ObjectItemDataHolder({
    required this.name,
    required this.description,
    required this.object,
  });
}

class InventoryItemDataHolder {
  final String medicineName;
  final String medicineDescription;
  final String price;
  final bool isStock;

  InventoryItemDataHolder({
    required this.medicineName,
    required this.medicineDescription,
    required this.price,
    required this.isStock,
  });
}
