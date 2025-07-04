import 'package:flutter/material.dart';
import 'package:flutter_multi_store/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ShippingPriceScreen extends StatefulWidget {
  @override
  State<ShippingPriceScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingPriceScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(
      context,
    );
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Charge Shipping',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value;
              _productProvider.getFormData(chargeShipping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Shipping Charge';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                String cleaned = value.trim();
                int? shipping = int.tryParse(cleaned);

                if (shipping != null) {
                  _productProvider.getFormData(shippingCharge: shipping);
                } else {
                  print('Invalid: $value');
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Shipping Charge'),
            ),
          ),
      ],
    );
  }
}
