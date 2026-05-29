import 'package:flutter/material.dart';

void main() => runApp(const AppPocketStudioApp());

const _screenshotMode = String.fromEnvironment(
  'APP_SCREENSHOT_MODE',
  defaultValue: 'home',
);

class AppPocketStudioApp extends StatelessWidget {
  const AppPocketStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF2298C3);
    return MaterialApp(
      title: 'App Pocket Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          primary: seed,
          secondary: const Color(0xFFD22C53),
          surface: const Color(0xFF1D2325),
        ),
        scaffoldBackgroundColor: const Color(0xFF111517),
        fontFamily: 'SF Pro Display',
        cardTheme: CardThemeData(
          color: const Color(0xFF1D2325),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      home: const StudioShell(),
    );
  }
}

class StudioShell extends StatefulWidget {
  const StudioShell({super.key});

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  int _index = _initialIndex();

  static int _initialIndex() {
    switch (_screenshotMode) {
      case 'quick_add':
        return 1;
      case 'detail_review':
        return 2;
      case 'insights':
        return 3;
      case 'export_settings':
        return 4;
      default:
        return 0;
    }
  }

  static final _pages = <_PageSpec>[
    _PageSpec('Home', Icons.dashboard_rounded, HomePage.new),
    _PageSpec('Capture', Icons.add_circle_rounded, QuickAddPage.new),
    _PageSpec('Review', Icons.timeline_rounded, DetailReviewPage.new),
    _PageSpec('Insights', Icons.query_stats_rounded, InsightsPage.new),
    _PageSpec('Export', Icons.ios_share_rounded, ExportSettingsPage.new),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: _pages[_index].builder(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: const Color(0xFF151A1C),
        indicatorColor: const Color(0xFF2298C3).withValues(alpha: .22),
        destinations: [
          for (final p in _pages)
            NavigationDestination(icon: Icon(p.icon), label: p.label),
        ],
      ),
    );
  }
}

class _PageSpec {
  const _PageSpec(this.label, this.icon, this.builder);
  final String label;
  final IconData icon;
  final Widget Function() builder;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioPage(
      title: 'App Pocket Studio',
      subtitle: 'On-site work captured in under 10 seconds.',
      hero: const MetricHero(
        label: 'Today\'s completion',
        value: '78%',
        caption: '12 capture cards • 3 need review',
        icon: Icons.bolt_rounded,
      ),
      imageSlot: const VisualSlot(
        assetPath: 'assets/visual_slots/home.png',
        eyebrow: 'FIELD OPS',
        title: 'Photo-backed overview',
        caption: 'Hero image position for the daily status card.',
      ),
      children: [
        const SectionHeader('Next action'),
        ActionCard(
          title: 'Upload boiler room photos',
          body:
              'Missing evidence for Site Visit #A14. Add three photos and mark safety risk.',
          chip: '2 min',
          icon: Icons.photo_camera_rounded,
          color: const Color(0xFFD22C53),
        ),
        const SizedBox(height: 12),
        const SectionHeader('Live queue'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            StatusPill('Snags', '5', Color(0xFFF29E0C)),
            StatusPill('Photos', '28', Color(0xFF2298C3)),
            StatusPill('Done', '14', Color(0xFF25B05F)),
          ],
        ),
      ],
    );
  }
}

class QuickAddPage extends StatelessWidget {
  const QuickAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioPage(
      title: 'Quick Add',
      subtitle: 'Capture a field note before the detail gets lost.',
      hero: const BrandedHero(
        icon: Icons.add_task_rounded,
        title: '10-second capture',
        body:
            'Voice-style prompts, category chips, and one save CTA — local first.',
      ),
      imageSlot: const VisualSlot(
        assetPath: 'assets/visual_slots/quick_add.png',
        eyebrow: 'CAPTURE',
        title: 'Evidence image slot',
        caption: 'Shows where attached photos or scene previews land.',
      ),
      children: [
        const SectionHeader('Primary input'),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _panelDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Leak near west stairwell, photo attached, risk medium',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  CategoryChip('Safety'),
                  CategoryChip('Photo'),
                  CategoryChip('Follow-up'),
                  CategoryChip('Medium risk'),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save capture card'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailReviewPage extends StatelessWidget {
  const DetailReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioPage(
      title: 'Detail Review',
      subtitle: 'Audit one item with notes, state, and history visible.',
      hero: const TimelineHero(),
      imageSlot: const VisualSlot(
        assetPath: 'assets/visual_slots/detail_review.png',
        eyebrow: 'REVIEW',
        title: 'Review visual proof',
        caption: 'Before/after or evidence photos stay visible during audit.',
      ),
      children: [
        const SectionHeader('Review card'),
        ActionCard(
          title: 'West stairwell leak',
          body: 'State: Needs contractor • Last edited 14:20 • Owner: Mei',
          chip: 'Open',
          icon: Icons.water_drop_rounded,
          color: const Color(0xFF3B8CDC),
        ),
        const SizedBox(height: 12),
        ActionCard(
          title: 'History',
          body:
              'Photo added → Risk set to medium → Export queued for weekly report.',
          chip: '3 events',
          icon: Icons.history_rounded,
          color: const Color(0xFF25B05F),
        ),
      ],
    );
  }
}

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioPage(
      title: 'Insights',
      subtitle: 'Counts, completion, and risk flags for small teams.',
      hero: const MetricHero(
        label: 'Risk flags cleared',
        value: '9 / 12',
        caption: 'Three high-priority cards remain before export.',
        icon: Icons.query_stats_rounded,
      ),
      imageSlot: const VisualSlot(
        assetPath: 'assets/visual_slots/insights.png',
        eyebrow: 'INSIGHTS',
        title: 'Trend visual panel',
        caption: 'Chart/snapshot position for quick readback.',
      ),
      children: const [
        SectionHeader('Trend readback'),
        InsightRow('Capture velocity', '32 cards/week', .82, Color(0xFF2298C3)),
        InsightRow('Review completion', '78%', .78, Color(0xFF25B05F)),
        InsightRow('Risk backlog', '3 high', .28, Color(0xFFD22C53)),
      ],
    );
  }
}

class ExportSettingsPage extends StatelessWidget {
  const ExportSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioPage(
      title: 'Export & Privacy',
      subtitle: 'Handoff clean reports without creating a backend dependency.',
      hero: const BrandedHero(
        icon: Icons.lock_rounded,
        title: 'Local-first by default',
        body:
            'No account, no tracking, no regulated claims. Export CSV/PDF when the operator asks.',
      ),
      imageSlot: const VisualSlot(
        assetPath: 'assets/visual_slots/export_settings.png',
        eyebrow: 'EXPORT',
        title: 'Report preview image',
        caption: 'Visual slot for generated packet covers and exports.',
      ),
      children: [
        const SectionHeader('Export options'),
        ActionCard(
          title: 'Weekly site packet',
          body: 'CSV summary + photo checklist + unresolved risk appendix.',
          chip: 'Ready',
          icon: Icons.picture_as_pdf_rounded,
          color: const Color(0xFF2298C3),
        ),
        const SizedBox(height: 12),
        ActionCard(
          title: 'Privacy note',
          body: 'All capture cards stay on device until manually exported.',
          chip: 'Local',
          icon: Icons.privacy_tip_rounded,
          color: const Color(0xFF25B05F),
        ),
      ],
    );
  }
}

class StudioPage extends StatelessWidget {
  const StudioPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hero,
    required this.imageSlot,
    required this.children,
  });
  final String title;
  final String subtitle;
  final Widget hero;
  final Widget imageSlot;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .68),
            fontSize: 15,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 20),
        hero,
        const SizedBox(height: 14),
        imageSlot,
        const SizedBox(height: 22),
        ...children,
      ],
    );
  }
}

class VisualSlot extends StatelessWidget {
  const VisualSlot({
    super.key,
    required this.assetPath,
    required this.eyebrow,
    required this.title,
    required this.caption,
  });

  final String assetPath;
  final String eyebrow;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .62),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: const TextStyle(
                      color: Color(0xFF70BEDB),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    caption,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .78),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricHero extends StatelessWidget {
  const MetricHero({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });
  final String label;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF136785), Color(0xFF2298C3), Color(0xFFD22C53)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2298C3).withValues(alpha: .24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 28),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .78),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .82),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class BrandedHero extends StatelessWidget {
  const BrandedHero({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2325),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF70BEDB).withValues(alpha: .24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2298C3),
            ),
            child: Icon(icon, size: 34, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineHero extends StatelessWidget {
  const TimelineHero({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _panelDecoration(radius: 28),
      child: Column(
        children: const [
          TimelineStep('Captured', '14:08', true),
          TimelineStep('Risk labeled', '14:11', true),
          TimelineStep('Contractor assigned', 'Pending', false),
        ],
      ),
    );
  }
}

class TimelineStep extends StatelessWidget {
  const TimelineStep(this.title, this.time, this.done, {super.key});
  final String title;
  final String time;
  final bool done;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: done ? const Color(0xFF25B05F) : const Color(0xFFF29E0C),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.white.withValues(alpha: .62)),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: .62),
        fontWeight: FontWeight.w800,
        letterSpacing: .7,
      ),
    ),
  );
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.body,
    required this.chip,
    required this.icon,
    required this.color,
  });
  final String title;
  final String body;
  final String chip;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _panelDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    CategoryChip(chip),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .68),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFF293032),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
    ),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, this.value, this.color, {super.key});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 104,
    padding: const EdgeInsets.all(14),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .68),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class InsightRow extends StatelessWidget {
  const InsightRow(
    this.label,
    this.value,
    this.progress,
    this.color, {
    super.key,
  });
  final String label;
  final String value;
  final double progress;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            color: color,
            backgroundColor: const Color(0xFF293032),
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _panelDecoration({double radius = 22}) => BoxDecoration(
  color: const Color(0xFF1D2325),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: Colors.white.withValues(alpha: .06)),
);
