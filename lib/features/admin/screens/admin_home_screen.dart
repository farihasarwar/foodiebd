import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/admin/screens/manage_categories_screen.dart';
import 'package:foodiebd/features/admin/screens/manage_foods_screen.dart';
import 'package:foodiebd/features/admin/screens/manage_users_screen.dart';
import 'package:foodiebd/features/admin/screens/manage_orders_screen.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            title: 'Manage Foods',
            icon: Icons.restaurant_menu,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageFoodsScreen(),
              ),
            ),
          ),
          _buildDashboardCard(
            context,
            title: 'Manage Categories',
            icon: Icons.category,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageCategoriesScreen(),
              ),
            ),
          ),
          _buildDashboardCard(
            context,
            title: 'Manage Users',
            icon: Icons.people,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageUsersScreen(),
              ),
            ),
          ),
          _buildDashboardCard(
            context,
            title: 'Manage Orders',
            icon: Icons.receipt_long,
            color: AppTheme.primaryColor,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageOrdersScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 