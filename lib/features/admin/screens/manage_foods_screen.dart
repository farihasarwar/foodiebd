import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/home/providers/food_provider.dart';
import 'package:foodiebd/shared/models/food_model.dart';
import 'package:uuid/uuid.dart';

class ManageFoodsScreen extends ConsumerWidget {
  const ManageFoodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = ref.watch(foodsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Foods'),
      ),
      body: foods.when(
        data: (foodList) {
          if (foodList.isEmpty) {
            return const Center(
              child: Text('No foods added yet'),
            );
          }

          return ListView.builder(
            itemCount: foodList.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final food = foodList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    if (food.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          food.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      food.category,
                                      style:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${food.price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  if (food.discountedPrice != null)
                                    Text(
                                      '\$${food.discountedPrice!.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            food.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (food.isFeatured)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Featured',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              if (food.isHot) ...[
                                if (food.isFeatured)
                                  const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Hot',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showEditFoodDialog(context, ref, food),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: AppTheme.errorColor,
                                onPressed: () =>
                                    _showDeleteConfirmation(context, ref, food),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFoodDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddFoodDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final discountedPriceController = TextEditingController();
    final imageUrlController = TextEditingController();
    String? selectedCategory;
    bool isFeatured = false;
    bool isHot = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Food'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter food name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter food description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter food price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: discountedPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Discounted Price (Optional)',
                    hintText: 'Enter discounted price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'Enter food image URL',
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: ref.read(categoriesProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final categories = snapshot.data as List<String>;
                      return DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'Select category',
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Featured'),
                  value: isFeatured,
                  onChanged: (value) {
                    setState(() => isFeatured = value ?? false);
                  },
                ),
                CheckboxListTile(
                  title: const Text('Hot'),
                  value: isHot,
                  onChanged: (value) {
                    setState(() => isHot = value ?? false);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    imageUrlController.text.isEmpty ||
                    selectedCategory == null) {
                  return;
                }

                final food = FoodModel(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  imageUrl: imageUrlController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                  discountedPrice: discountedPriceController.text.isNotEmpty
                      ? double.parse(discountedPriceController.text.trim())
                      : null,
                  category: selectedCategory!,
                  isFeatured: isFeatured,
                  isHot: isHot,
                  createdAt: DateTime.now(),
                );

                ref.read(foodServiceProvider).addFood(food);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditFoodDialog(
    BuildContext context,
    WidgetRef ref,
    FoodModel food,
  ) async {
    final nameController = TextEditingController(text: food.name);
    final descriptionController = TextEditingController(text: food.description);
    final priceController =
        TextEditingController(text: food.price.toStringAsFixed(2));
    final discountedPriceController = TextEditingController(
        text: food.discountedPrice?.toStringAsFixed(2) ?? '');
    final imageUrlController = TextEditingController(text: food.imageUrl);
    String? selectedCategory = food.category;
    bool isFeatured = food.isFeatured;
    bool isHot = food.isHot;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Food'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter food name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter food description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter food price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: discountedPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Discounted Price (Optional)',
                    hintText: 'Enter discounted price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'Enter food image URL',
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: ref.read(categoriesProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final categories = snapshot.data as List<String>;
                      return DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'Select category',
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Featured'),
                  value: isFeatured,
                  onChanged: (value) {
                    setState(() => isFeatured = value ?? false);
                  },
                ),
                CheckboxListTile(
                  title: const Text('Hot'),
                  value: isHot,
                  onChanged: (value) {
                    setState(() => isHot = value ?? false);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    imageUrlController.text.isEmpty ||
                    selectedCategory == null) {
                  return;
                }

                final updatedFood = food.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  imageUrl: imageUrlController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                  discountedPrice: discountedPriceController.text.isNotEmpty
                      ? double.parse(discountedPriceController.text.trim())
                      : null,
                  category: selectedCategory,
                  isFeatured: isFeatured,
                  isHot: isHot,
                );

                ref.read(foodServiceProvider).updateFood(updatedFood);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    FoodModel food,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food'),
        content: Text('Are you sure you want to delete "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(foodServiceProvider).deleteFood(food.id);
    }
  }
} 