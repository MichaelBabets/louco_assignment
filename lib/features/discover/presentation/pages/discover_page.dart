import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../ai_chat/presentation/pages/ai_chat_bottom_sheet.dart';
import '../../bloc/discover_cubit.dart';
import '../widgets/discover_header.dart';
import '../widgets/discover_search_bar.dart';
import '../widgets/event_grid.dart';
import '../widgets/filter_row.dart';
import '../widgets/results_count.dart';
import '../widgets/sort_row.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

enum _DiscoverTab { events, locations }

class _DiscoverPageState extends State<DiscoverPage> {
  String _selectedFilter = '';
  bool _isSheetOpen = false;
  _DiscoverTab _tab = _DiscoverTab.events;

  void _openAiChat() {
    setState(() => _isSheetOpen = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => AiChatBottomSheet(
        onEventTap: (event) {
          Navigator.of(context).pop();
          widget.onEventTap(event);
        },
      ),
    ).then((_) {
      if (mounted) setState(() => _isSheetOpen = false);
    });
  }

  void _onFilterTap(String filter) {
    setState(() => _selectedFilter = _selectedFilter == filter ? '' : filter);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SafeArea(
              child: BlocBuilder<DiscoverCubit, DiscoverState>(
                builder: (context, state) {
                  final events = state is DiscoverLoaded
                      ? state.events
                      : <Event>[];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: const Border(
                            bottom: BorderSide(
                              color: AppColors.divider,
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.07),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const DiscoverHeader(),
                      ),
                      DiscoverSearchBar(onAskAiTap: _openAiChat),
                      const SizedBox(height: 8),
                      FilterRow(
                        selectedFilter: _selectedFilter,
                        onFilterTap: _onFilterTap,
                      ),
                      const SortRow(),
                      const SizedBox(height: 16),
                      _TabBar(
                        selected: _tab,
                        onTap: (t) => setState(() => _tab = t),
                      ),
                      if (_tab == _DiscoverTab.events) ...[
                        if (state is DiscoverLoading)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (state is DiscoverError)
                          Expanded(
                            child: _ErrorView(
                              onRetry: () =>
                                  context.read<DiscoverCubit>().loadData(),
                            ),
                          )
                        else ...[
                          ResultsCount(count: events.length),
                          Expanded(
                            child: EventGrid(
                              events: events,
                              onEventTap: widget.onEventTap,
                            ),
                          ),
                        ],
                      ] else
                        const Expanded(child: _LocationsPlaceholder()),
                    ],
                  );
                },
              ),
            ),
            if (_isSheetOpen)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withValues(alpha: 0.35)),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selected, required this.onTap});

  final _DiscoverTab selected;
  final ValueChanged<_DiscoverTab> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            label: context.l10n.discoverTabEvents,
            isSelected: selected == _DiscoverTab.events,
            onTap: () => onTap(_DiscoverTab.events),
          ),
        ),
        Expanded(
          child: _TabItem(
            label: context.l10n.discoverTabLocations,
            isSelected: selected == _DiscoverTab.locations,
            onTap: () => onTap(_DiscoverTab.locations),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 2),
                ),
              )
            : null,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Something went wrong',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(context.l10n.homeRetry)),
        ],
      ),
    );
  }
}

class _LocationsPlaceholder extends StatelessWidget {
  const _LocationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.comingSoon,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
    );
  }
}
