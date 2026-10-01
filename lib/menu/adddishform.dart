import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats_admin/Authentication/utils/comon_image_picker.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/dummyMenu/CategoryItemTile.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Repo/MenuManagerRepo.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/menu/model/CategoryModel.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/menu/widgets/AddDishTextField.dart';
import 'package:spicy_eats_admin/menu/widgets/ElevatedCustomButton.dart';
import 'package:spicy_eats_admin/menu/widgets/ImageBulletPoints.dart';

class AddDishForm extends ConsumerStatefulWidget {
  final List<CategoryModel> categories;

  const AddDishForm({super.key, required this.categories});

  @override
  ConsumerState<AddDishForm> createState() => _AddDishFormState();
}

class _AddDishFormState extends ConsumerState<AddDishForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dishNameCtrl = TextEditingController();
  final TextEditingController _dishDescCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _discountCtrl = TextEditingController();
  final TextEditingController _maxSelectCtrl = TextEditingController();
  final TextEditingController _subtitleSelectCtrl = TextEditingController();
  final TextEditingController _variationTitleCtrl = TextEditingController();
  final TextEditingController _optNameCtrl = TextEditingController();
  final TextEditingController _optPriceCtrl = TextEditingController();

  final List<Map<String, dynamic>> _variations = [];
  final List<Map<String, dynamic>> _tempOptions = [];

  CategoryModel? _category;
  bool _isVeg = true;
  bool _showVariationForm = false;
  bool _variationRequired = false;
  bool _isEditing = false;
  int? _editingDishId;
  String? _editImgUrl;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEditingItem());
  }

  void _loadEditingItem() {
    final item = ref.read(editedCategoryItemProvider);
    if (item == null) return;

    _isEditing = true;
    _editingDishId = item.id;
    _editImgUrl = item.dish_imageurl;
    _dishNameCtrl.text = item.dish_name ?? '';
    _dishDescCtrl.text = item.dish_description ?? '';
    _priceCtrl.text = '${item.dish_price ?? ''}';
    _discountCtrl.text = '${item.dish_discount ?? ''}';
    _isVeg = item.isVeg ?? false;

    final match = widget.categories
        .where((c) => c.categoryId == item.category_id)
        .toList();
    if (match.isNotEmpty) _category = match.first;

    setState(() {});
  }

  @override
  void dispose() {
    _dishNameCtrl.dispose();
    _dishDescCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    _maxSelectCtrl.dispose();
    _subtitleSelectCtrl.dispose();
    _variationTitleCtrl.dispose();
    _optNameCtrl.dispose();
    _optPriceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePickImage() async {
    final Uint8List? bytes = await _pickBytes();
    if (bytes == null || !mounted) return;

    const maxSizeInBytes = 2 * 1024 * 1024;
    if (bytes.length > maxSizeInBytes) {
      showCustomSnackbar(
        context: context,
        message: 'Image too large (max 2MB)',
        backgroundColor: Colors.red,
      );
      return;
    }
    setState(() => _image = bytes);
  }

  Future<Uint8List?> _pickBytes() async {
    try {
      return await pickImage();
    } catch (e) {
      debugPrint('Image pick failed: $e');
      return null;
    }
  }

  void _addOptionToTemp() {
    final name = _optNameCtrl.text.trim();
    final priceText = _optPriceCtrl.text.trim();
    if (name.isEmpty || priceText.isEmpty) {
      _warn('Option name and price are required');
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      _warn('Invalid option price');
      return;
    }
    setState(() {
      _tempOptions.add({'name': name, 'price': price});
      _optNameCtrl.clear();
      _optPriceCtrl.clear();
    });
  }

  void _saveVariation() {
    final title = _variationTitleCtrl.text.trim();
    if (title.isEmpty ||
        _maxSelectCtrl.text.trim().isEmpty ||
        _subtitleSelectCtrl.text.trim().isEmpty) {
      _warn('Fill in every variation field');
      return;
    }
    if (_tempOptions.isEmpty) {
      _warn('Add at least one option');
      return;
    }
    setState(() {
      _variations.add({
        'title': title,
        'required': _variationRequired,
        'options': List<Map<String, dynamic>>.from(_tempOptions),
        'maxSelect': _maxSelectCtrl.text.trim(),
        'subtitleMaxSelect': _subtitleSelectCtrl.text.trim(),
      });
      _variationTitleCtrl.clear();
      _variationRequired = false;
      _tempOptions.clear();
      _showVariationForm = false;
      _maxSelectCtrl.clear();
      _subtitleSelectCtrl.clear();
    });
    showCustomSnackbar(
      context: context,
      message: 'Variation saved',
      backgroundColor: Colors.black,
    );
  }

  void _warn(String message) {
    showCustomSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  Future<void> _saveDish() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final category = _category;
    if (category == null) {
      _warn('Select a category');
      return;
    }
    if (_image == null && _editImgUrl == null) {
      _warn('Please upload a dish image');
      return;
    }
    if (_isEditing && _editingDishId != null && _image == null) {
      _warn('Re-upload the image to save changes to an existing dish');
      return;
    }

    final restUid = ref.read(restaurantProvider)?.restuid;
    if (restUid == null || restUid.isEmpty) {
      _warn('Could not resolve your restaurant');
      return;
    }

    ref.read(isloadingprovider.notifier).state = true;
    try {
      final controller = ref.read(menuManagerControllerProvider);

      if (_isEditing && _editingDishId != null) {
        await controller.updateDish(
          context: context,
          dishId: _editingDishId!,
          dishName: _dishNameCtrl.text.trim(),
          dishDisc: _dishDescCtrl.text.trim(),
          dishPrice: _priceCtrl.text.trim(),
          dishDisPrice: _discountCtrl.text.trim(),
          category: category,
          isVeg: _isVeg,
          dishImage: _image,
        );
        await _reloadCategory(category.categoryId);
      } else {
        await controller.addDish(
          context: context,
          restUid: restUid,
          dishName: _dishNameCtrl.text.trim(),
          dishDisc: _dishDescCtrl.text.trim(),
          dishPrice: _priceCtrl.text.trim(),
          dishDisPrice: _discountCtrl.text.trim(),
          dishImage: _image!,
          category: category,
          isVeg: _isVeg,
          variations: _variations,
        );
        await _reloadCategory(category.categoryId);
      }

      ref.read(editedCategoryItemProvider.notifier).state = null;
      await ref.read(menuManagerRepoProvider).preLoadDishes(context: context);
      if (!mounted) return;
      ref.read(showAddsScreenProvider.notifier).state = false;
    } catch (_) {
    } finally {
      if (mounted) ref.read(isloadingprovider.notifier).state = false;
    }
  }

  Future<void> _reloadCategory(String categoryId) async {
    final items = await ref
        .read(menuManagerControllerProvider)
        .fetchCategoriesItems(categoryId: categoryId);
    if (!mounted) return;
    ref.read(categoryItemsProvider.notifier).state = {
      ...ref.read(categoryItemsProvider),
      categoryId: items ?? const [],
    };
  }

  void _reset() {
    setState(() {
      _image = null;
      _editImgUrl = null;
      _editingDishId = null;
      _isEditing = false;
      _dishNameCtrl.clear();
      _dishDescCtrl.clear();
      _priceCtrl.clear();
      _discountCtrl.clear();
      _category = null;
      _isVeg = true;
      _variations.clear();
      _tempOptions.clear();
      _showVariationForm = false;
      _variationTitleCtrl.clear();
      _optNameCtrl.clear();
      _optPriceCtrl.clear();
      _maxSelectCtrl.clear();
      _subtitleSelectCtrl.clear();
    });
    ref.read(editedCategoryItemProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isloadingprovider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final fieldWidth = isMobile ? double.infinity : 280.0;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black26,
                color: Colors.black,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () {
                          ref.read(editedCategoryItemProvider.notifier).state =
                              null;
                          ref.read(showAddsScreenProvider.notifier).state = false;
                        },
                        icon: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit Dish' : 'Add Dish',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      elevatedCustomButton(
                        onpress: _reset,
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _field(
                        width: fieldWidth,
                        child: addDishTextField(
                          labeltext: 'Dish name',
                          controller: _dishNameCtrl,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      _field(
                        width: fieldWidth,
                        child: addDishTextField(
                          labeltext: 'Description',
                          controller: _dishDescCtrl,
                          maxLines: 2,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      _field(
                        width: fieldWidth,
                        child: addDishTextField(
                          labeltext: 'Price',
                          controller: _priceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _numberValidator,
                        ),
                      ),
                      _field(
                        width: fieldWidth,
                        child: addDishTextField(
                          labeltext: 'Discounted price',
                          controller: _discountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _numberValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _imagePicker(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<CategoryModel>(
                          isExpanded: true,
                          initialValue: _category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          items: widget.categories
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c.categoryName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _category = v),
                          validator: (v) =>
                              v == null ? 'Select a category' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Veg'),
                          Switch(
                            trackOutlineColor:
                                WidgetStateProperty.all(Colors.black),
                            inactiveTrackColor: Colors.black12,
                            activeThumbColor: Colors.black,
                            inactiveThumbColor: Colors.white,
                            activeTrackColor: Colors.black12,
                            value: _isVeg,
                            onChanged: (v) => setState(() => _isVeg = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Variations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.black),
                        inactiveTrackColor: Colors.black12,
                        activeThumbColor: Colors.black,
                        inactiveThumbColor: Colors.white,
                        activeTrackColor: Colors.black12,
                        value: _showVariationForm,
                        onChanged: (v) => setState(() => _showVariationForm = v),
                      ),
                    ],
                  ),
                  if (_showVariationForm) ...[
                    const SizedBox(height: 12),
                    _variationForm(isMobile),
                  ],
                  if (_variations.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _savedVariations(),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: elevatedCustomButton(
                      label: Text(
                        _isEditing ? 'Update Dish' : 'Save Dish',
                        style: const TextStyle(color: Colors.white),
                      ),
                      icon: Icon(_isEditing ? Icons.save : Icons.add),
                      onpress: _saveDish,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field({required double width, required Widget child}) {
    return SizedBox(width: width, child: child);
  }

  String? _numberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
    return null;
  }

  Widget _imagePicker() {
    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 2,
      dashPattern: const [10, 6],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _imagePreview(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  elevatedCustomButton(
                    onpress: _handlePickImage,
                    label: const Text(
                      'Upload image',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(Icons.upload),
                    bheight: 32,
                    bwidth: 160,
                  ),
                  const SizedBox(height: 8),
                  imageBulletPoints(
                      text: 'Upload a clear, high-quality photo.'),
                  imageBulletPoints(
                      text: 'Square format (1:1) works best.'),
                  imageBulletPoints(text: 'Maximum file size: 2MB.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePreview() {
    if (_image != null) return Image.memory(_image!, fit: BoxFit.cover);
    if (_editImgUrl != null && _editImgUrl!.isNotEmpty) {
      return Image.network(
        _editImgUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _Placeholder(),
      );
    }
    return const _Placeholder();
  }

  Widget _variationForm(bool isMobile) {
    final wide = isMobile ? double.infinity : 300.0;
    final narrow = isMobile ? double.infinity : 150.0;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  value: _variationRequired,
                  onChanged: (v) => setState(() => _variationRequired = v),
                ),
              ],
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _field(
                  width: wide,
                  child: addDishTextField(
                    labeltext: 'Variation title (e.g. Sauces)',
                    controller: _variationTitleCtrl,
                  ),
                ),
                _field(
                  width: narrow,
                  child: addDishTextField(
                    labeltext: 'Option name',
                    controller: _optNameCtrl,
                  ),
                ),
                _field(
                  width: narrow,
                  child: addDishTextField(
                    labeltext: 'Option price',
                    controller: _optPriceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numberValidator,
                  ),
                ),
                _field(
                  width: narrow,
                  child: addDishTextField(
                    labeltext: 'Max select',
                    controller: _maxSelectCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _numberValidator,
                  ),
                ),
                _field(
                  width: isMobile ? double.infinity : 260,
                  child: addDishTextField(
                    labeltext: 'Subtitle hint',
                    hintText: 'e.g. Select just one',
                    controller: _subtitleSelectCtrl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                elevatedCustomButton(
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Add Option',
                    style: TextStyle(color: Colors.white),
                  ),
                  onpress: _addOptionToTemp,
                ),
                elevatedCustomButton(
                  onpress: _saveVariation,
                  label: const Text(
                    'Save Variation',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            if (_tempOptions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Options',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              for (var i = 0; i < _tempOptions.length; i++)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${_tempOptions[i]['name']}'),
                  subtitle: Text(
                      'Price: ${(_tempOptions[i]['price'] as double).toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _tempOptions.removeAt(i)),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _savedVariations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved variations',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < _variations.length; i++)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_variations[i]['title']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _variations[i]['required'] == true
                                ? 'Required'
                                : 'Optional',
                            style: const TextStyle(fontSize: 12),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () =>
                                setState(() => _variations.removeAt(i)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  for (final option in (_variations[i]['options'] as List))
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('${option['name']}'),
                      trailing: Text(
                          '\$${(option['price'] as double).toStringAsFixed(2)}'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, color: Colors.black45),
    );
  }
}
