import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/auth/providers/auth_provider.dart';
import 'package:foodiebd/features/auth/screens/login_screen.dart';
import 'package:foodiebd/features/cart/providers/cart_provider.dart';
import 'package:foodiebd/features/cart/screens/cart_screen.dart';
import 'package:foodiebd/features/home/screens/home_screen.dart';
import 'package:foodiebd/features/orders/screens/orders_screen.dart';
import 'package:foodiebd/features/profile/screens/profile_screen.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final authState = ref.watch(authStateProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const HomeScreen(),
          authState.when(
            data: (user) => user != null ? const CartScreen() : const LoginScreen(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const LoginScreen(),
          ),
          authState.when(
            data: (user) =>
                user != null ? const OrdersScreen() : const LoginScreen(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const LoginScreen(),
          ),
          authState.when(
            data: (user) =>
                user != null ? const ProfileScreen() : const LoginScreen(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const LoginScreen(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            ref.read(selectedIndexProvider.notifier).state = index,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartItemCount > 0,
              label: Text(cartItemCount.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartItemCount > 0,
              label: Text(cartItemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: AppTheme.primaryColor.withOpacity(0.2),
      ),
    );
  }
} 