import 'package:flutter/material.dart';

import '../../constants.dart';
import 'absent_members_view.dart';
import 'history_view.dart';
import 'qr_scan_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> screens = [AbsentsMembersView(), QRScanView(), HistoryView()];
  int _selectedIndex = 0;
  bool tap = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: AppColors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.person_off,
                color: tap ? AppColors.primary2 : AppColors.secondary,
              ),
              onPressed: () {
                tap = true;
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            const SizedBox(width: 48), // space for FAB
            IconButton(
              icon: Icon(Icons.history,
                  color: tap ? AppColors.secondary : AppColors.primary2),
              onPressed: () {
                tap = false;
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        onPressed: () {
          tap = false;
          setState(() {
            _selectedIndex = 1;
          });
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
