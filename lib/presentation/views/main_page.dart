import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomalyze/core/constants/app_icons.dart';
import 'package:tomalyze/presentation/views/home/home_page.dart';

import '../../core/constants/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    Text('Scan'),
    Text('Upload'),
    Text('Profile'),
    // ScanPage(),
    // UploadPage()
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.blackGrey.withValues(alpha: 0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            useLegacyColorScheme: false,
            currentIndex: _selectedIndex,
            onTap: (value) => setState(() => _selectedIndex = value),
            selectedLabelStyle: const TextStyle(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
            ),
            items: _buildNavigationItems(),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      _buildNavItem(icon: AppIcons.home, label: 'Home', index: 0, iconSize: 20),
      _buildNavItem(icon: AppIcons.camera, label: 'Scan', index: 1),
      _buildNavItem(icon: AppIcons.image, label: 'Upload', index: 2),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            Icon(
              Icons.person,
              size: 28,
              color: _selectedIndex == 3
                  ? AppColors.primaryRed
                  : AppColors.textGrey,
            ),
          ],
        ),
        label: 'Profile',
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String label,
    required int index,
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          SvgPicture.asset(
            icon,
            height: iconSize ?? 24,
            colorFilter: ColorFilter.mode(
              _selectedIndex == index
                  ? AppColors.primaryRed
                  : AppColors.textGrey,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
