import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/extensions/build_context_ext.dart';
import 'core/models/event.dart';
import 'core/theme/app_theme.dart';
import 'features/event_details/presentation/pages/event_details_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/discover/presentation/pages/discover_page.dart';
import 'l10n/app_localizations.dart';

class LoucoApp extends StatelessWidget {
  const LoucoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Louco',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _MainShell(),
    );
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _selectedIndex = 0;

  void _onEventTap(Event event) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EventDetailsPage(event: event)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onEventTap: _onEventTap),
          DiscoverPage(onEventTap: _onEventTap),
          const _ProfilePlaceholder(),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomNav,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: context.l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            label: context.l10n.navSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: context.l10n.navProfile,
          ),
        ],
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_outline,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.navProfile,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.profileComingSoon,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
