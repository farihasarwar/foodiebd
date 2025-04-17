import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/orders/providers/order_provider.dart';
import 'package:foodiebd/shared/models/order_model.dart';
import 'package:intl/intl.dart';

// Stream provider for all orders (not just user-specific)
final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getAllOrders();
});

class ManageOrdersScreen extends ConsumerWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(allOrdersProvider);
    final orderStatuses = ref.watch(orderStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: orders.when(
        data: (ordersList) {
          if (ordersList.isEmpty) {
            return const Center(
              child: Text('No orders yet'),
            );
          }

          return ListView.builder(
            itemCount: ordersList.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = ordersList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id.substring(0, 8)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          _buildStatusDropdown(context, ref, order),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('MMM d, y h:mm a').format(order.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.foodName}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Delivery Address:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        order.deliveryAddress,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
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
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
  ) {
    final orderStatuses = ref.watch(orderStatusProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(order.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor(order.status),
        ),
      ),
      child: DropdownButton<String>(
        value: order.status,
        items: orderStatuses.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (newStatus) {
          if (newStatus != null) {
            ref.read(orderServiceProvider).updateOrderStatus(order.id, newStatus);
          }
        },
        style: TextStyle(
          color: _getStatusColor(order.status),
          fontWeight: FontWeight.bold,
        ),
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'on_the_way':
        return Colors.indigo;
      case 'delivered':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }
} 