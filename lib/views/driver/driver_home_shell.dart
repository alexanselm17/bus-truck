import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/user_shared_pref.dart';
import '../payments/payment_history.dart';
import '../profile_page.dart';
import 'driver_school_page.dart';
import 'driver_students_page.dart';
import 'driver_trip_list.dart';

class DriverHomeShell extends StatefulWidget {
  const DriverHomeShell({super.key});

  @override
  State<DriverHomeShell> createState() => _DriverHomeShellState();
}

class _DriverHomeShellState extends State<DriverHomeShell> {
  static const _titles = <String>[
    'Payments',
    'Students',
    'Trips',
    'Schools',
    'Profile',
  ];

  int _selectedIndex = 2;
  final Map<int, Widget> _builtTabs = {};

  void _selectTab(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  Widget _buildTab(int index) {
    return _builtTabs.putIfAbsent(index, () {
      switch (index) {
        case 0:
          return const PaymentHistory(embedded: true);
        case 1:
          return DriverStudentsPage(onOpenTrips: () => _selectTab(2));
        case 2:
          return const DriverTripList(embedded: true);
        case 3:
          return const DriverSchoolPage();
        case 4:
          return const ProfilePage(embedded: true);
        default:
          return const SizedBox.shrink();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        toolbarHeight: 82,
        titleSpacing: 20,
        title: Consumer<UserPreferences>(
          builder: (context, preferences, child) {
            final rawName = preferences.appUser.name?.trim();
            final firstName = rawName == null || rawName.isEmpty
                ? 'Driver'
                : rawName.split(RegExp(r'\s+')).first;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedIndex == 2
                      ? 'Good day, $firstName'
                      : _titles[_selectedIndex],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppConstants.navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _selectedIndex == 2
                      ? DateFormat('EEEE, d MMMM').format(DateTime.now())
                      : 'Driver workspace',
                  style: const TextStyle(
                    color: Color(0xFF4F5868),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppConstants.navy,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.directions_bus_rounded,
                color: AppConstants.colorPrimary,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(
          _titles.length,
          (index) => index == _selectedIndex || _builtTabs.containsKey(index)
              ? _buildTab(index)
              : const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE8EBF0))),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Payments',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups_rounded),
                label: 'Students',
              ),
              NavigationDestination(
                icon: Icon(Icons.route_outlined),
                selectedIcon: Icon(Icons.route_rounded),
                label: 'Trips',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school_rounded),
                label: 'Schools',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
