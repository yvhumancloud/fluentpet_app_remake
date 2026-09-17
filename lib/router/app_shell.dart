import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../dev/widget_gallery_screen.dart';
import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import '../theme/theme_mode.dart';
import '../widgets/widgets.dart';
import 'screens.g.dart';
import 'tabs.dart';

/// The three-tab chrome the tabbed screens live inside.
///
/// The bar itself is [FpTabBar], built to the specification. The shell's job is
/// only to hand it the branch index and take one back: [FpTab] states the order
/// once and both the branches and the bar read it from there, so the index the
/// bar reports is always the branch `goBranch` wants.
///
/// It also feeds the bar its attention dot. That is the shell's job and not a
/// screen's, because the whole point of the dot is that a Base dropping off is
/// visible from **any** tab — a Hardware screen that drew it would only be
/// telling people who had already gone to look. What counts as needing
/// attention is [DeviceHealthPill.needsAttention]'s to decide, so the dot and
/// the header pill can never disagree.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final bases = ref.watch(basesProvider);
    // While the list is still loading there is nothing to be alarmed about
    // yet, and an error is not a Base's health — neither draws the dot.
    final alert = switch (bases) {
      AsyncData<List<Base>>(:final value)
          when DeviceHealthPill.needsAttention(value) =>
        FpTab.hardware,
      _ => null,
    };
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      drawer: const AppDrawer(),
      body: navigationShell,
      bottomNavigationBar: FpTabBar(
        currentIndex: navigationShell.currentIndex,
        alert: alert,
        onSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// The drawer. In the RN app the Tools screen is drawer-presented off the home
/// navigator, so it is reachable the same way here.
///
/// It also carries the full route index and the scheme override, both of which
/// are development affordances rather than product surface — see [_RouteIndex].
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final mode = ref.watch(themeModeProvider);
    return Drawer(
      backgroundColor: c.surfaceRaised,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FpSpace.s5,
                FpSpace.s6,
                FpSpace.s5,
                FpSpace.s4,
              ),
              child: Text(
                'FluentPet',
                style: FpType.displaySm.copyWith(color: c.textPrimary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.tune, color: c.textSecondary),
              title: Text(
                FpScreen.settings.title ?? 'Tools',
                style: FpType.bodyMd.copyWith(color: c.textPrimary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push(FpScreen.settings.path);
              },
            ),
            ListTile(
              leading: Icon(Icons.widgets_outlined, color: c.textSecondary),
              title: Text(
                'Widget gallery',
                style: FpType.bodyMd.copyWith(color: c.textPrimary),
              ),
              subtitle: Text(
                'Dev only · every component and every button, every state',
                style: FpType.bodySm.copyWith(color: c.textSecondary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Pushed on the root navigator rather than routed: the route
                // table is generated from the screen map and the gallery is
                // not a screen in it. Keeping it out means it cannot be
                // deep-linked and cannot be mistaken for product surface.
                Navigator.of(context, rootNavigator: true).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const WidgetGalleryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: c.textSecondary),
              title: Text(
                'Scheme',
                style: FpType.bodyMd.copyWith(color: c.textPrimary),
              ),
              subtitle: Text(
                switch (mode) {
                  ThemeMode.system => 'System',
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                },
                style: FpType.bodySm.copyWith(color: c.textSecondary),
              ),
              onTap: () => ref.read(themeModeProvider.notifier).cycle(),
            ),
            Divider(color: c.borderSubtle, height: FpSpace.s7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.s5),
              child: Text(
                'ALL ROUTES',
                style: FpType.labelSm.copyWith(color: c.textTertiary),
              ),
            ),
            const SizedBox(height: FpSpace.s3),
            const Expanded(child: _RouteIndex()),
          ],
        ),
      ),
    );
  }
}

/// Every in-scope screen, tappable.
///
/// Not product surface. It is here so the route table can be walked without a
/// screen existing to navigate from — which, with twenty-four of thirty-six
/// screens unbuilt, is otherwise impossible.
class _RouteIndex extends StatelessWidget {
  const _RouteIndex();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: FpSpace.s7),
      itemCount: FpScreen.values.length,
      itemBuilder: (context, i) {
        final screen = FpScreen.values[i];
        return ListTile(
          dense: true,
          title: Text(
            screen.key,
            style: FpType.labelMd.copyWith(color: c.textPrimary),
          ),
          subtitle: Text(
            '${screen.presentation.name} · ${screen.path}',
            style: FpType.monoSm.copyWith(color: c.textTertiary),
          ),
          onTap: () {
            Navigator.of(context).pop();
            if (FpTab.rootOf(screen) != null) {
              context.go(screen.path);
            } else {
              context.push(screen.path);
            }
          },
        );
      },
    );
  }
}
