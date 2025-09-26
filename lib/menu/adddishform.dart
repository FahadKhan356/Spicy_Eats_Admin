import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/utils/common_image_picker_web.dart';

import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/widgets/AddDishTextField.dart';
import 'package:spicy_eats_admin/menu/widgets/ElevatedCustomButton.dart';
import 'package:spicy_eats_admin/menu/widgets/ImageBulletPoints.dart';

class AddDishForm extends ConsumerStatefulWidget {
  static const String routename = '/add-dish';
  List<CategoryModel>? categories;
  // ignore: use_super_parameters
  AddDishForm({Key? key, required this.categories}) : super(key: key);

  @override
  ConsumerState<AddDishForm> createState() => _AddDishFormState();
}

class _AddDishFormState extends ConsumerState<AddDishForm> {
  final _formKey = GlobalKey<FormState>();

  // Dish fields
  final TextEditingController _dishNameCtrl = TextEditingController();
  final TextEditingController _dishDescCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _discountCtrl = TextEditingController();
  CategoryModel? _category;
  bool _isVeg = false;

  // Variations store (saved)
  final List<Map<String, dynamic>> _variations = [];

  // Variation being created (temp)
  bool _showVariationForm = false;
  final TextEditingController _variationTitleCtrl = TextEditingController();
  bool _variationRequired = false;

  // Temp options for current variation
  final TextEditingController _optNameCtrl = TextEditingController();
  final TextEditingController _optPriceCtrl = TextEditingController();
  final List<Map<String, dynamic>> _tempOptions = [];

  // Example categories (replace with your real list)
  final List<String> _categories = ['Burgers', 'Wraps', 'Grilled', 'Sides'];
  Uint8List? idImage;
  Future<void> handlePickImage() async {
    var result = await pickImage();

    if (result != null) {
      debugPrint("image is not empty ");
      const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
      if (result.length > maxSizeInBytes) {
        showCustomSnackbar(context: context, message: 'Image too large (max ${maxSizeInBytes ~/ (1024 * 1024)}MB)');
      
      } else {
        setState(() {
          idImage = result;
        });
      }
    }
  }

  @override
  void dispose() {
    _dishNameCtrl.dispose();
    _dishDescCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    _variationTitleCtrl.dispose();
    _optNameCtrl.dispose();
    _optPriceCtrl.dispose();
    super.dispose();
  }

  void _addOptionToTemp() {
    final name = _optNameCtrl.text.trim();
    final priceText = _optPriceCtrl.text.trim();
    if (name.isEmpty || priceText.isEmpty) {
      showCustomSnackbar(context: context, message:'Option name and price are required',backgroundColor: Colors.black);
     
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
        showCustomSnackbar(context: context, message:'Invalid option price',backgroundColor: Colors.black);
     
    
      return;
    }

    setState(() {
      _tempOptions.add({'name': name, 'price': price});
      _optNameCtrl.clear();
      _optPriceCtrl.clear();
    });
  }

  void _removeTempOption(int index) {
    setState(() => _tempOptions.removeAt(index));
  }

  void _saveVariation() {
    final title = _variationTitleCtrl.text.trim();
    if (title.isEmpty) {
      showCustomSnackbar(context: context, message:'Variation title is required',backgroundColor: Colors.black);
     
      return;
    }
    if (_tempOptions.isEmpty) {
       showCustomSnackbar(context: context, message:'Add at least one option',backgroundColor: Colors.black);
     
      return;
    }
    setState(() {
      _variations.add({
        'title': title,
        'required': _variationRequired,
        'options': List<Map<String, dynamic>>.from(_tempOptions),
      });
      // Clear temp variation
      _variationTitleCtrl.clear();
      _variationRequired = false;
      _tempOptions.clear();
      _showVariationForm = false;
    });
    showCustomSnackbar(context: context, message: 'Variation saved',backgroundColor: Colors.black);
 
  }

  Widget _responsiveField({required Widget child, required bool isMobile}) {
    return SizedBox(
      width: isMobile ? double.infinity : 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              IconButton(
                  onPressed: () {
                    ref.read(showAddsScreenProvider.notifier).state = false;
                  },
                  icon: const Icon(Icons.cancel)),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Dish',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  elevatedCustomButton(
                    onpress: () {
                      // Clear everything to start fresh
                      setState(() {
                        _dishNameCtrl.clear();
                        _dishDescCtrl.clear();
                        _priceCtrl.clear();
                        _discountCtrl.clear();
                        _category = null;
                        _isVeg = true;
                        _variations.clear();
                        _showVariationForm = false;
                        _variationTitleCtrl.clear();
                        _tempOptions.clear();
                        _optNameCtrl.clear();
                        _optPriceCtrl.clear();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dish fields (wrap to avoid overflow)
              Wrap(spacing: 16, runSpacing: 12, children: [
                _responsiveField(
                  isMobile: isMobile,
                  child: addDishTextField(
                    labeltext: 'Dish name',
                    controller: _dishNameCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                _responsiveField(
                  isMobile: isMobile,
                  child: addDishTextField(
                      labeltext: 'Discription',
                      controller: _dishDescCtrl,
                      maxLines: 2),
                ),
                _responsiveField(
                  isMobile: isMobile,
                  child: addDishTextField(
                      labeltext: 'Price',
                      controller: _priceCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                ),
                _responsiveField(
                  isMobile: isMobile,
                  child: addDishTextField(
                      labeltext: 'Discount Price',
                      controller: _discountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                ),
              ]),

              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        minHeight: 100,
                        maxWidth: double.maxFinite,
                      ),
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 3,
                        dashPattern: const [12, 8],
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    child: idImage != null
                                        ? Image.memory(idImage!)
                                        :  Image.asset('lib/assets/DishFormatPic.jpg')),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsetsGeometry.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    elevatedCustomButton(
                                        onpress: () => handlePickImage(),
                                        label: const Text(
                                          'Upload image',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        icon: const Icon(Icons.upload),
                                        bheight: 30,
                                        bwidth: 200),
                                    const SizedBox(height: 8),
                                    imageBulletPoints(
                                        text:
                                            "Upload a clear, high-quality photo (no blur)."),
                                    imageBulletPoints(
                                        text:
                                            "Use good lighting and avoid background clutter."),
                                    imageBulletPoints(
                                        text:
                                            "Square format (1:1) works best."),
                                    imageBulletPoints(
                                        text: "Maximum file size: 2MB."),
                                    imageBulletPoints(
                                        text:
                                            " Only JPG or PNG images allowed."),
                                  ],
                                ),
                              ),
                              // child: idImage!=null || idImage!.isNotEmpty? Container(child: Image.memory(idImage!,fit: BoxFit.cover,),) : Container(child: Icon(Icons.image),)   )
                            )
                          ],
                        ),
                      )),
                ],
              ),

              const SizedBox(height: 12),

              // Category and veg
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<CategoryModel>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(245, 245, 245, 1),
                        labelText: 'Category',
                        labelStyle: TextStyle(overflow: TextOverflow.ellipsis),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    initialValue: _category,
                    items: widget.categories
                        ?.map((val) => DropdownMenuItem(
                            value: val, child: Text(val.categoryName)))
                        .toList(), //_categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v),
                    validator: (v) => (v == null || v.categoryName.isEmpty)
                        ? 'Select category'
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Text('Veg'),
                  const SizedBox(width: 8),
                  Switch(
                       trackOutlineColor: WidgetStateProperty.all(Colors.black),
                      inactiveTrackColor: Colors.black12,
                      activeThumbColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: Colors.black12,
                 
                      value: _isVeg,
                      onChanged: (v) => setState(() => _isVeg = v)),
                ]),
              ]),

              const SizedBox(height: 20),
              const Divider(),

              // Variation toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Variations',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Switch(
                      trackOutlineColor: WidgetStateProperty.all(Colors.black),
                      inactiveTrackColor: Colors.black12,
                      activeThumbColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: Colors.black12,
                      value: _showVariationForm,
                      onChanged: (v) => setState(
                            () => _showVariationForm = !_showVariationForm,
                          )),
                ],
              ),
              const SizedBox(height: 12),

              // Variation form (temp)
              if (_showVariationForm)
                Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + required
                          Wrap(spacing: 12, runSpacing: 12, children: [
                            SizedBox(
                              width: isMobile ? double.infinity : 360,
                              child: addDishTextField(
                                labeltext: 'Variation Title (e.g. Sauces)',
                                controller: _variationTitleCtrl,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Required'),
                                const SizedBox(width: 8),
                                Switch(
                                  trackOutlineColor: WidgetStateProperty.all(Colors.black),
                      inactiveTrackColor: Colors.black12,
                      activeThumbColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: Colors.black12,
                      value: _showVariationForm,
                                
                                  onChanged: (v) =>
                                      setState(() => _variationRequired = v),
                                ),
                              ],
                            ),
                          ]),

                          const SizedBox(height: 12),

                          // Add Option row
                          Wrap(spacing: 12, runSpacing: 12, children: [
                            SizedBox(
                              width: isMobile ? double.infinity : 260,
                              child: addDishTextField(
                                labeltext: 'Option Name',
                                controller: _optNameCtrl,
                              ),
                            ),
                            SizedBox(
                                width: isMobile ? double.infinity : 160,
                                child: addDishTextField(
                                  labeltext: 'Option Price',
                                  controller: _optPriceCtrl,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                )),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                // ConstrainedBox(
                                // constraints: BoxConstraints.tightFor(width: isMobile ? double.infinity : 130, height: 48),
                                // child:
                                Expanded(
                                  child: elevatedCustomButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Text(
                                      'Add Option',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onpress: _addOptionToTemp,
                                  ),
                                ),
                                // ),
                                Expanded(
                                  child: elevatedCustomButton(
                                    onpress: _saveVariation,
                                    label: const Text(
                                      'Save Variation',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),

                          const SizedBox(height: 10),

                          // Show temp options
                          if (_tempOptions.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Options:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                ..._tempOptions.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final opt = entry.value;
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: double.infinity),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(opt['name']),
                                      subtitle: Text(
                                          'Price: ${opt['price'].toStringAsFixed(2)}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _removeTempOption(idx),
                                        tooltip: 'Remove option',
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),

                          const SizedBox(height: 12),

                          // Save / Cancel variation
                        ]),
                  ),
                ),

              const SizedBox(height: 18),

              // Saved variations list (cards)
              if (_variations.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saved Variations',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ..._variations.map((v) {
                      return ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(v['title'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(v['required']
                                            ? 'Required'
                                            : 'Optional'),
                                      ]),
                                  const SizedBox(height: 8),
                                  ...List<Map<String, dynamic>>.from(
                                          v['options'])
                                      .map((o) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minWidth: double.infinity),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(o['name']),
                                        trailing:
                                            Text(o['price'].toStringAsFixed(2)),
                                      ),
                                    );
                                  }),
                                ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),

              const SizedBox(height: 20),
              elevatedCustomButton(
                label: const Text(
                  'Save Dish',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.save),
                onpress: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  // Build the dish object to send to your backend
                  final dish = {
                    'name': _dishNameCtrl.text.trim(),
                    'description': _dishDescCtrl.text.trim(),
                    'price': double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
                    'discount':
                        double.tryParse(_discountCtrl.text.trim()) ?? 0.0,
                    'category': _category,
                    'isVeg': _isVeg,
                    'variations': _variations,
                  };
                  // TODO: send `dish` to backend or save locally
                showCustomSnackbar(context: context, message: 'Dish saved (mock)',backgroundColor: Colors.black);
                
                  // For dev: print(dish) or debug
                  // print(dish);
                },
              ),
              // Save dish button

              const SizedBox(height: 30),
            ]),
          ),
        );
      }),
    );
  }
}
