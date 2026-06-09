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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.backgroundPrimary,
          selectedItemColor: AppColors.accentNeon,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: [
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.map_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.map_outlined)),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: const Padding(padding: EdgeInsets.only(bottom: 4), child: CustomPlanetIcon(color: Colors.white)),
              activeIcon: const Padding(padding: EdgeInsets.only(bottom: 4), child: CustomPlanetIcon(color: AppColors.accentNeon)),
              label: 'Community',
            ),
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPlanetIcon extends StatelessWidget {
  final Color color;
  final double size;

  const CustomPlanetIcon({super.key, required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PlanetPainter(color: color),
    );
  }
}

class _PlanetPainter extends CustomPainter {
  final Color color;

  _PlanetPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw the planet outline
    canvas.drawCircle(center, radius, paint);

    // Draw the diagonal ring slash
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.6); // slight diagonal rotation
    
    // Draw the slash line that extends slightly beyond the circle
    final lineLength = radius * 1.5;
    canvas.drawLine(
      Offset(-lineLength, 0),
      Offset(lineLength, 0),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlanetPainter oldDelegate) => oldDelegate.color != color;
}
