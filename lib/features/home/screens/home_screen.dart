import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/home/providers/home_provider.dart';
import 'package:foodiebd/features/home/widgets/category_list.dart';
import 'package:foodiebd/features/home/widgets/combo_deals.dart';
import 'package:foodiebd/features/home/widgets/offer_banner.dart';
import 'package:foodiebd/features/home/widgets/section_title.dart';
import 'package:foodiebd/features/home/widgets/category_foods.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHints = [
    'Search for food...',
    'Craving something?',
    'What would you like to eat?',
  ];
  int _currentHintIndex = 0;
  int _nextHintIndex = 1;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
        reverseCurve: const Interval(0.5, 1, curve: Curves.easeIn),
      ),
    );

    _searchAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentHintIndex = _nextHintIndex;
          _nextHintIndex = (_nextHintIndex + 1) % _searchHints.length;
        });
        _searchAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _searchAnimationController.forward();
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _searchAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Use current location'),
              onTap: () {
                // TODO: Implement location permission and fetching
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search location'),
              onTap: () {
                // TODO: Implement location search
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('No notifications yet'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersProvider);
    final deals = ref.watch(comboDealsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Location and Notification Row
                  Row(
                    children: [
                      InkWell(
                        onTap: _showLocationPicker,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deliver to',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  'Current Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _showNotifications,
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              if (_searchController.text.isEmpty)
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    _searchHints[_currentHintIndex],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                ),
                                onTap: () {
                                  // TODO: Implement search functionality
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Offer Banner
                    OfferBanner(banners: banners),
                    const SizedBox(height: 24),

                    // Best Combo Deals
                    SectionTitle(
                      title: 'Best Combo Deals',
                      onSeeAll: () {
                        // TODO: Navigate to all deals
                      },
                    ),
                    const SizedBox(height: 16),
                    ComboDeals(deals: deals),
                    const SizedBox(height: 24),

                    // Categories
                    SectionTitle(
                      title: 'Categories',
                      onSeeAll: () {
                        // TODO: Navigate to all categories
                      },
                    ),
                    const SizedBox(height: 16),
                    CategoryList(categories: categories),
                    const SizedBox(height: 24),

                    // Category Foods
                    const CategoryFoods(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 