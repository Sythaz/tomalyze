import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomalyze/core/constants/app_icons.dart';
import 'package:tomalyze/presentation/views/home/home_page.dart';
import 'package:tomalyze/presentation/views/profile/profile_page.dart';
import 'package:tomalyze/presentation/views/scan/scan_page.dart';
import 'package:tomalyze/presentation/views/upload/upload_page.dart';

import '../../core/constants/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ScanPage(),
    UploadPage(),
    ProfilePage(),
  ];

  void _changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _pushTab(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

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
            selectedLabelStyle: const TextStyle(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
            ),
            items: _buildNavigationItems(),
            onTap: (value) {
              switch (value) {
                case 0:
                  _changeTab(value);
                case 1:
                  _pushTab(context, const ScanPage());
                  break;
                case 2:
                  _pushTab(context, const UploadPage());
                  break;
                case 3:
                  _pushTab(context, const ProfilePage());
                  break;
                default:
              }
            },
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      _buildNavSvgItem(
        icon: AppIcons.home,
        label: 'Home',
        index: 0,
        iconSize: 20,
      ),
      _buildNavSvgItem(icon: AppIcons.camera, label: 'Scan', index: 1),
      _buildNavSvgItem(icon: AppIcons.image, label: 'Upload', index: 2),
      _buildNavIconItem(icon: Icons.person, label: 'Profile', index: 3),
    ];
  }

  BottomNavigationBarItem _buildNavSvgItem({
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

  BottomNavigationBarItem _buildNavIconItem({
    required IconData icon,
    required String label,
    required int index,
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(
            icon,
            size: iconSize ?? 28,
            color: _selectedIndex == index
                ? AppColors.primaryRed
                : AppColors.textGrey,
          ),
        ],
      ),
      label: label,
    );
  }
}
