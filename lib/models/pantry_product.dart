class PantryProduct {
  const PantryProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiry,
  });

  final int id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime expiry;

  String get quantityLabel =>
      '${quantity == quantity.roundToDouble() ? quantity.toInt() : double.parse(quantity.toStringAsFixed(3))} $unit';
  String get expiryLabel =>
      '${expiry.day.toString().padLeft(2, '0')}/${expiry.month.toString().padLeft(2, '0')}/${expiry.year}';

  PantryProduct copyWithQuantity(double value) => PantryProduct(
    id: id,
    name: name,
    category: category,
    quantity: value,
    unit: unit,
    expiry: expiry,
  );

  static const categories = ['Fridge', 'Pantry', 'Freezer', 'Spices'];
  static const units = ['kg', 'g', 'l', 'ml', 'pcs'];

  static List<PantryProduct> demoProducts() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      PantryProduct(
        id: 1,
        name: 'Buckwheat',
        category: 'Pantry',
        quantity: 1,
        unit: 'kg',
        expiry: today.add(const Duration(days: 75)),
      ),
      PantryProduct(
        id: 2,
        name: 'Olive Oil',
        category: 'Pantry',
        quantity: 500,
        unit: 'ml',
        expiry: today.add(const Duration(days: 160)),
      ),
      PantryProduct(
        id: 3,
        name: 'Chicken Breast',
        category: 'Fridge',
        quantity: 2,
        unit: 'pcs',
        expiry: today.add(const Duration(days: 1)),
      ),
      PantryProduct(
        id: 4,
        name: 'Cinnamon',
        category: 'Spices',
        quantity: 50,
        unit: 'g',
        expiry: today.add(const Duration(days: 200)),
      ),
    ];
  }

  bool get lowStock =>
      quantity <=
      switch (unit) {
        'kg' || 'l' => 1,
        'g' || 'ml' => 100,
        _ => 2,
      };
}
