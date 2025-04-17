import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/features/home/providers/food_provider.dart';
import 'package:foodiebd/features/home/providers/home_provider.dart';
import 'package:foodiebd/shared/models/food_model.dart';
import 'package:foodiebd/features/home/widgets/food_card.dart';
import 'package:foodiebd/features/home/widgets/section_title.dart';

class CategoryFoods extends ConsumerWidget {
  const CategoryFoods({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final foods = ref.watch(foodsProvider);

    return foods.when(
      data: (foodsList) {
        // Filter foods by selected category
        final filteredFoods = selectedCategory == 'All'
            ? foodsList
            : foodsList.where((food) => food.category == selectedCategory).toList();

        if (filteredFoods.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                selectedCategory == 'All'
                    ? 'No foods available'
                    : 'No foods in $selectedCategory category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: selectedCategory == 'All' ? 'All Foods' : selectedCategory,
              showViewAll: filteredFoods.length > 6,
              onSeeAll: () {
                // TODO: Navigate to category foods screen
              },
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                return FoodCard(
                  food: food,
                  onTap: () {
                    // TODO: Navigate to food details screen
                  },
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
} 