import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'qr_payment_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static const List<Widget> _widgetOptions = <Widget>[
    MapScreen(),
    QrPaymentScreen(),
    ChatScreen(), // 채팅 화면 추가
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _animationController.forward().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _widgetOptions.elementAt(_selectedIndex),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFF346DFF),
            unselectedItemColor: const Color(0xFF9CA3AF),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 0, // We'll use custom widgets instead
            items: [
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  Icons.map_outlined,
                  Icons.map,
                  '지도',
                  0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  Icons.qr_code_scanner_outlined,
                  Icons.qr_code_scanner,
                  'QR 결제',
                  1,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  Icons.chat_outlined,
                  Icons.chat,
                  '톡',
                  2,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(
                  Icons.person_outline,
                  Icons.person,
                  'MY',
                  3,
                ),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData inactiveIcon,
      IconData activeIcon,
      String label,
      int index,
      ) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF346DFF).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Special design for QR payment button
          if (index == 1)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? [const Color(0xFF346DFF), const Color(0xFF6B8AFF)]
                      : [const Color(0xFF9CA3AF), const Color(0xFF9CA3AF)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: const Color(0xFF346DFF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: Colors.white,
                size: 20,
              ),
            )
          else
          // Regular icons for other tabs
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? const Color(0xFF346DFF)
                    : const Color(0xFF9CA3AF),
                size: 24,
              ),
            ),

          const SizedBox(height: 4),

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF346DFF)
                  : const Color(0xFF9CA3AF),
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}