import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/community_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/community/community_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/run/run_map_screen.dart';
import 'screens/profile/profile_screen.dart';

class StravunApp extends StatelessWidget {
  const StravunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
          create: (context) => HomeProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => HomeProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CommunityProvider>(
          create: (context) => CommunityProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => CommunityProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Stravun',
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading && !auth.isLoggedIn) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.accentNeon),
            ),
          );
        }
        
        if (auth.isLoggedIn) {
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RunMapScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Run',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
