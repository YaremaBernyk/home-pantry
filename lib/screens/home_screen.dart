import 'package:flutter/material.dart';

import '../core/widgets/pantry_widgets.dart';
import '../models/pantry_product.dart';
import 'add_product_dialog.dart';

typedef PantryActivity = ({
  String title,
  String detail,
  IconData icon,
  Color color,
});

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName = 'Yarema'});
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  final _products = PantryProduct.demoProducts();
  final _search = TextEditingController();
  final List<PantryActivity> _activity = [];
  int _nextId = 5;
  String _category = 'All';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  double get _freshRatio {
    if (_products.isEmpty) return 1;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _products.where((p) => !p.expiry.isBefore(today)).length /
        _products.length;
  }

  void _record(String title, String detail, IconData icon, Color color) {
    _activity.insert(0, (
      title: title,
      detail: detail,
      icon: icon,
      color: color,
    ));
    if (_activity.length > 8) _activity.removeLast();
  }

  void _changeQuantity(int id, double delta) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index < 0) return;
    final product = _products[index];
    final candidate = product.quantity + delta;
    final quantity = candidate < 0
        ? 0.0
        : candidate > 1000000
        ? 1000000.0
        : candidate;
    if (quantity == product.quantity) return;
    setState(() {
      final updated = product.copyWithQuantity(quantity);
      _products[index] = updated;
      _record(
        'Updated quantity',
        '${product.name} · ${updated.quantityLabel}',
        Icons.edit_outlined,
        PantryColors.accent,
      );
    });
  }

  void _deleteProduct(int id) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index < 0) return;
    setState(() {
      final product = _products.removeAt(index);
      _record(
        'Removed from Pantry',
        product.name,
        Icons.delete_outline,
        PantryColors.muted,
      );
    });
  }

  static const labels = ['Dashboard', 'Pantry', 'Profile'];
  static const icons = [
    Icons.dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 260,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: PantryColors.border)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PantryColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Home Pantry',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              for (var i = 0; i < labels.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selected: selected == i,
                      selectedColor: PantryColors.accent,
                      selectedTileColor: PantryColors.selected,
                      leading: Icon(icons[i], size: 21),
                      title: Text(
                        labels[i],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => setState(() => selected = i),
                    ),
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PantryColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pantry Health',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Stable',
                          style: TextStyle(
                            color: Color(0xFF519A70),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _freshRatio,
                      color: Color(0xFF519A70),
                      backgroundColor: PantryColors.border,
                      minHeight: 6,
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${(_freshRatio * 100).round()}% of your stock is fresh.',
                      style: TextStyle(fontSize: 11, color: PantryColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: selected == 2
                ? _profile(context)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected == 0
                                      ? 'Welcome, ${widget.userName}'
                                      : 'My Pantry',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selected == 0
                                      ? 'Here is what is happening in your kitchen today.'
                                      : 'Manage and track your kitchen inventory stock levels.',
                                  style: const TextStyle(
                                    color: PantryColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PantryButton(
                            label: 'Add Product',
                            icon: Icons.add,
                            onPressed: () => _addProduct(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (selected == 0)
                        DashboardContent(
                          products: _products,
                          activity: _activity,
                        )
                      else
                        PantryContent(
                          products: _products,
                          searchController: _search,
                          category: _category,
                          onSearchChanged: (_) => setState(() {}),
                          onCategoryChanged: (value) =>
                              setState(() => _category = value),
                          onQuantityChanged: _changeQuantity,
                          onDelete: _deleteProduct,
                        ),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );

  Widget _profile(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'YOUR PROFILE',
        style: TextStyle(
          color: PantryColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        widget.userName,
        style: TextStyle(fontFamily: 'Georgia', fontSize: 42),
      ),
      const SizedBox(height: 32),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: PantryCard(
              padding: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile photo',
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a photo so your pantry feels unmistakably yours.',
                    style: TextStyle(color: PantryColors.muted, height: 1.5),
                  ),
                  const SizedBox(height: 72),
                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 41,
                        backgroundColor: Color(0xFFE8D6C9),
                        child: Text(
                          widget.userName.characters.first.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            color: PantryColors.accent,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => showDemoNotice(
                          context,
                          'UI demo: photo upload is not connected.',
                        ),
                        child: const Text('Change photo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: PantryCard(
              padding: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change password',
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose a strong password you don’t use elsewhere.',
                    style: TextStyle(color: PantryColors.muted),
                  ),
                  const SizedBox(height: 24),
                  const PantryField(
                    label: 'Current password',
                    hint: 'Enter current password',
                    secret: true,
                  ),
                  const PantryField(
                    label: 'New password',
                    hint: 'At least 8 characters',
                    secret: true,
                  ),
                  PantryButton(
                    label: 'Change password',
                    onPressed: () => showDemoNotice(
                      context,
                      'UI demo: passwords are not saved.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 360),
      TextButton(
        onPressed: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
        child: const Text('Sign Out'),
      ),
    ],
  );

  Future<void> _addProduct(BuildContext context) async {
    final product = await showDialog<PantryProduct>(
      context: context,
      builder: (_) => AddProductDialog(productId: _nextId),
    );
    if (product == null || !mounted) return;
    setState(() {
      _products.add(product);
      _nextId++;
      _category = 'All';
      _search.clear();
      _record(
        'Added to Pantry',
        '${product.name} · ${product.quantityLabel}',
        Icons.add_circle_outline,
        const Color(0xFF519A70),
      );
    });
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.products,
    required this.activity,
  });
  final List<PantryProduct> products;
  final List<PantryActivity> activity;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final soon = products
        .where(
          (p) =>
              !p.expiry.isBefore(today) &&
              !p.expiry.isAfter(today.add(const Duration(days: 2))),
        )
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Items',
                value: '${products.length}',
                detail: 'Products across all categories',
                icon: Icons.inventory_2_outlined,
                color: PantryColors.ink,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                title: 'Expiring Soon',
                value: '$soon',
                detail: 'Expiring within the next 48 hours',
                icon: Icons.schedule,
                color: const Color(0xFFDD514B),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                title: 'Low Stock',
                value: '${products.where((p) => p.lowStock).length}',
                detail: 'Low amounts for their unit',
                icon: Icons.error_outline,
                color: const Color(0xFFD98A24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        PantryCard(
          child: activity.isEmpty
              ? const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No activity yet. Add a product to get started.',
                    style: TextStyle(color: PantryColors.muted),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < activity.length; i++) ...[
                      if (i > 0)
                        const Divider(color: PantryColors.border, height: 24),
                      ActivityRow(
                        title: activity[i].title,
                        detail: activity[i].detail,
                        date: 'Today',
                        icon: activity[i].icon,
                        color: activity[i].color,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String title, value, detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => PantryCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: PantryColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(icon, color: color),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          value,
          style: TextStyle(
            fontSize: 36,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail,
          style: const TextStyle(color: PantryColors.muted, fontSize: 13),
        ),
      ],
    ),
  );
}

class ActivityRow extends StatelessWidget {
  const ActivityRow({
    super.key,
    required this.title,
    required this.detail,
    required this.date,
    required this.icon,
    required this.color,
  });
  final String title, detail, date;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        backgroundColor: color.withValues(alpha: .1),
        child: Icon(icon, color: color, size: 21),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              detail,
              style: const TextStyle(color: PantryColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
      Text(
        date,
        style: const TextStyle(color: PantryColors.muted, fontSize: 13),
      ),
    ],
  );
}

class PantryContent extends StatelessWidget {
  const PantryContent({
    super.key,
    required this.products,
    required this.searchController,
    required this.category,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onQuantityChanged,
    required this.onDelete,
  });
  final List<PantryProduct> products;
  final TextEditingController searchController;
  final String category;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final void Function(int, double) onQuantityChanged;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();
    final visible = products
        .where(
          (p) =>
              (category == 'All' || p.category == category) &&
              p.name.toLowerCase().contains(query),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('pantry-search'),
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search your kitchen...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          children: [
            for (final value in ['All', ...PantryProduct.categories])
              ChoiceChip(
                key: ValueKey('category-$value'),
                label: Text(value),
                selected: category == value,
                selectedColor: PantryColors.selected,
                backgroundColor: Colors.white,
                onSelected: (_) => onCategoryChanged(value),
              ),
          ],
        ),
        const SizedBox(height: 28),
        if (visible.isEmpty)
          PantryCard(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                products.isEmpty
                    ? 'Your pantry is empty. Add your first product.'
                    : 'No products match your search.',
              ),
            ),
          ),
        for (final product in visible)
          Padding(
            key: ValueKey('product-row-${product.id}'),
            padding: const EdgeInsets.only(bottom: 16),
            child: PantryCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${product.category} · Expires: ${product.expiryLabel}',
                          style: const TextStyle(
                            color: PantryColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: ValueKey('decrease-${product.id}'),
                    tooltip: 'Decrease ${product.name}',
                    onPressed: product.quantity <= 0
                        ? null
                        : () => onQuantityChanged(product.id, -1),
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                  Text(
                    product.quantityLabel,
                    key: ValueKey('quantity-${product.id}'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    key: ValueKey('increase-${product.id}'),
                    tooltip: 'Increase ${product.name}',
                    onPressed: product.quantity >= 1000000
                        ? null
                        : () => onQuantityChanged(product.id, 1),
                    icon: const Icon(Icons.add, size: 18),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    key: ValueKey('delete-${product.id}'),
                    tooltip: 'Delete ${product.name}',
                    onPressed: () => onDelete(product.id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: PantryColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
