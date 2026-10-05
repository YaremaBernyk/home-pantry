import 'package:flutter/material.dart';

import '../core/widgets/pantry_widgets.dart';
import '../models/pantry_product.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key, required this.productId});
  final int productId;

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _expiry = TextEditingController();
  String? _category;
  String _unit = 'kg';

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _expiry.dispose();
    super.dispose();
  }

  double? get _parsedQuantity =>
      double.tryParse(_quantity.text.trim().replaceAll(',', '.'));

  DateTime? _parseDate(String value) {
    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(value.trim());
    if (match == null) return null;
    final day = int.parse(match[1]!);
    final month = int.parse(match[2]!);
    final year = int.parse(match[3]!);
    if (year < 1900 || year > 9999) return null;
    final date = DateTime(year, month, day);
    return date.year == year && date.month == month && date.day == day
        ? date
        : null;
  }

  Widget _field(String label, Widget input) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        input,
      ],
    ),
  );

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(
      context,
      PantryProduct(
        id: widget.productId,
        name: _name.text.trim(),
        category: _category!,
        quantity: _parsedQuantity!,
        unit: _unit,
        expiry: _parseDate(_expiry.text)!,
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _parseDate(_expiry.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(9999, 12, 31),
    );
    if (date != null && mounted) {
      _expiry.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add new product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _field(
                'Product Name',
                TextFormField(
                  key: const ValueKey('product-name'),
                  controller: _name,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Basmati Rice',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a product name.'
                      : null,
                ),
              ),
              _field(
                'Category',
                DropdownButtonFormField<String>(
                  key: const ValueKey('product-category'),
                  decoration: const InputDecoration(
                    hintText: 'Select category...',
                  ),
                  items: [
                    for (final category in PantryProduct.categories)
                      DropdownMenuItem(value: category, child: Text(category)),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) =>
                      value == null ? 'Select a category.' : null,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                      'Quantity',
                      TextFormField(
                        key: const ValueKey('product-quantity'),
                        controller: _quantity,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(hintText: '1'),
                        validator: (_) {
                          final value = _parsedQuantity;
                          return value == null ||
                                  !value.isFinite ||
                                  value <= 0 ||
                                  value > 1000000
                              ? 'Use a number from 0 to 1,000,000 (above 0).'
                              : null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      'Unit',
                      DropdownButtonFormField<String>(
                        key: const ValueKey('product-unit'),
                        initialValue: _unit,
                        items: [
                          for (final unit in PantryProduct.units)
                            DropdownMenuItem(value: unit, child: Text(unit)),
                        ],
                        onChanged: (value) => setState(() => _unit = value!),
                      ),
                    ),
                  ),
                ],
              ),
              _field(
                'Expiry Date',
                TextFormField(
                  key: const ValueKey('product-expiry'),
                  controller: _expiry,
                  decoration: InputDecoration(
                    hintText: 'DD/MM/YYYY',
                    suffixIcon: IconButton(
                      tooltip: 'Choose expiry date',
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  validator: (value) => _parseDate(value ?? '') == null
                      ? 'Enter a valid date as DD/MM/YYYY.'
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  PantryButton(label: 'Save', onPressed: _save),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
