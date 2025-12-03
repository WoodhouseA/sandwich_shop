import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.cart,
        builder: (context, child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  if (widget.cart.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Your cart is empty',
                        style: heading2,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                      _CartItemRow(
                        sandwich: entry.key,
                        quantity: entry.value,
                        cart: widget.cart,
                        itemPrice: _getItemPrice(entry.key, entry.value),
                        sizeText: _getSizeText(entry.key.isFootlong),
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  StyledButton(
                    onPressed: _goBack,
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final Sandwich sandwich;
  final int quantity;
  final Cart cart;
  final double itemPrice;
  final String sizeText;

  const _CartItemRow({
    required this.sandwich,
    required this.quantity,
    required this.cart,
    required this.itemPrice,
    required this.sizeText,
  });

  void _increment() {
    if (quantity < 99) {
      cart.updateItemQuantity(sandwich, quantity + 1);
    }
  }

  void _decrement(BuildContext context) {
    if (quantity > 1) {
      cart.updateItemQuantity(sandwich, quantity - 1);
    } else {
      _confirmRemove(context);
    }
  }

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item?'),
        content: Text('Do you want to remove the ${sandwich.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeItem(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _removeItem(BuildContext context) {
    cart.removeItem(sandwich);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${sandwich.name} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            cart.restoreRemovedItem(sandwich, quantity);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _editQuantity(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: quantity.toString());
        return AlertDialog(
          title: const Text('Set Quantity'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newQty = int.tryParse(controller.text);
                Navigator.pop(context);
                if (newQty != null) {
                  if (newQty <= 0) {
                    _confirmRemove(context);
                  } else if (newQty > 99) {
                     cart.updateItemQuantity(sandwich, 99);
                  } else {
                    cart.updateItemQuantity(sandwich, newQty);
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditItemSheet(
        sandwich: sandwich,
        onSave: (updatedSandwich) {
          cart.replaceItem(sandwich, updatedSandwich);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(
                    sandwich.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                  ),
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sandwich.name, style: heading2.copyWith(fontSize: 18)),
                      Text('$sizeText on ${sandwich.breadType.name} bread'),
                      Text(
                        '£${itemPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Actions
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editOptions(context),
                      tooltip: 'Edit Options',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmRemove(context),
                      tooltip: 'Remove Item',
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _decrement(context),
                  tooltip: 'Decrease Quantity',
                ),
                InkWell(
                  onTap: () => _editQuantity(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      '$quantity',
                      style: heading2,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: quantity < 99 ? _increment : null,
                  tooltip: 'Increase Quantity',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditItemSheet extends StatefulWidget {
  final Sandwich sandwich;
  final ValueChanged<Sandwich> onSave;

  const _EditItemSheet({required this.sandwich, required this.onSave});

  @override
  State<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends State<_EditItemSheet> {
  late bool _isFootlong;
  late BreadType _breadType;
  late SandwichType _type;

  @override
  void initState() {
    super.initState();
    _isFootlong = widget.sandwich.isFootlong;
    _breadType = widget.sandwich.breadType;
    _type = widget.sandwich.type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Edit Sandwich', style: heading2),
          const SizedBox(height: 16),
          DropdownButtonFormField<SandwichType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: SandwichType.values.map((t) {
              // Create temp sandwich to get name
              final temp = Sandwich(type: t, isFootlong: true, breadType: BreadType.white);
              return DropdownMenuItem(value: t, child: Text(temp.name));
            }).toList(),
            onChanged: (val) => setState(() => _type = val!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BreadType>(
            initialValue: _breadType,
            decoration: const InputDecoration(labelText: 'Bread'),
            items: BreadType.values.map((b) {
              return DropdownMenuItem(value: b, child: Text(b.name));
            }).toList(),
            onChanged: (val) => setState(() => _breadType = val!),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Footlong?'),
            value: _isFootlong,
            onChanged: (val) => setState(() => _isFootlong = val),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final updated = widget.sandwich.copyWith(
                type: _type,
                breadType: _breadType,
                isFootlong: _isFootlong,
              );
              widget.onSave(updated);
            },
            child: const Text('Save Changes'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
