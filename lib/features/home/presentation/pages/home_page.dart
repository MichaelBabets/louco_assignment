import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../bloc/home_cubit.dart';
import '../widgets/featured_section.dart';
import '../widgets/today_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: _HomeView(onEventTap: onEventTap),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() ||
            HomeLoading() => const Center(child: CircularProgressIndicator()),
            HomeError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<HomeCubit>().loadData(),
                    child: Text(context.l10n.homeRetry),
                  ),
                ],
              ),
            ),
            HomeLoaded(:final featuredEvent, :final todayEvents) =>
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FeaturedSection(
                      event: featuredEvent,
                      onTap: () => onEventTap(featuredEvent),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: TodaySection(
                      events: todayEvents,
                      onEventTap: onEventTap,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
          };
        },
      ),
    );
  }
}
