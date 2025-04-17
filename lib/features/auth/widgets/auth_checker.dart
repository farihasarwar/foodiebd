import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/features/admin/screens/admin_dashboard_screen.dart';
import 'package:foodiebd/features/auth/providers/auth_provider.dart';
import 'package:foodiebd/features/auth/screens/login_screen.dart';
import 'package:foodiebd/features/navigation/screens/main_screen.dart';
import 'package:foodiebd/main.dart';

class AuthChecker extends ConsumerWidget {
  final Widget child;
  final bool isAdminRoute;

  const AuthChecker({
    super.key,
    required this.child,
    required this.isAdminRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both auth state and user data
    final authState = ref.watch(authStateProvider);
    final userState = ref.watch(currentUserProvider);

    // Handle loading states
    if (authState.isLoading || userState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle error states
    if (authState.hasError || userState.hasError) {
      return const LoginScreen();
    }

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return userState.when(
          data: (userData) {
            if (userData == null) {
              return const LoginScreen();
            }

            // If this is an admin route
            if (isAdminRoute) {
              // Only allow admin users
              return userData.isAdmin 
                ? const AdminDashboardScreen()
                : const LoginScreen();
            }

            // For non-admin routes, show the main screen for all authenticated users
            return child;
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const LoginScreen(),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}