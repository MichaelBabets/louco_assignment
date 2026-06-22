import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/event_detail_bottom_bar.dart';
import '../widgets/event_hero_app_bar.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key, required this.event});

  final Event event;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          EventHeroAppBar(
            event: widget.event,
            isFavorited: _isFavorited,
            onFavoriteTap: () => setState(() => _isFavorited = !_isFavorited),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _BodyPlaceholder(),
          ),
        ],
      ),
      bottomNavigationBar: const EventDetailBottomBar(),
    );
  }
}

class _BodyPlaceholder extends StatelessWidget {
  const _BodyPlaceholder();

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
