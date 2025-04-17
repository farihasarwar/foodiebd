import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodiebd/core/constants/firebase_constants.dart';
import 'package:foodiebd/core/theme/app_theme.dart';
import 'package:foodiebd/features/admin/screens/admin_dashboard_screen.dart';
import 'package:foodiebd/features/auth/screens/admin_login_screen.dart';
import 'package:foodiebd/features/auth/widgets/auth_checker.dart';
import 'package:foodiebd/features/navigation/screens/main_screen.dart';

// Provider to track if we're in an admin route
final isAdminRouteProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: FirebaseConstants.apiKey,
      authDomain: FirebaseConstants.authDomain,
      projectId: FirebaseConstants.projectId,
      storageBucket: FirebaseConstants.storageBucket,
      messagingSenderId: FirebaseConstants.messagingSenderId,
      appId: FirebaseConstants.appId,
      measurementId: FirebaseConstants.measurementId,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'FoodieBD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      navigatorObservers: [
        RouteObserver<PageRoute>(),
      ],
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const AuthChecker(
              isAdminRoute: false,
              child: MainScreen(),
            ),
        '/admin-login': (context) {
          ref.read(isAdminRouteProvider.notifier).state = true;
          return const AuthChecker(
            isAdminRoute: true,
            child: AdminLoginScreen(),
          );
        },
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    // Navigate to main screen after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AuthChecker(
              isAdminRoute: false,
              child: MainScreen(),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 100,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                'FoodieBD',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
