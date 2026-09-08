import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/theme/app_theme.dart';
import 'constrained_width.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _tabs = ['Hero', 'Projects', 'Skills', 'Philosophy'];

  late int _previousIndex = widget.navigationShell.currentIndex;

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell.currentIndex;
    if (newIndex != oldWidget.navigationShell.currentIndex) {
      _previousIndex = oldWidget.navigationShell.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 700;
    final currentIndex = widget.navigationShell.currentIndex;
    final reverse = currentIndex < _previousIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _TopNav(
            tabs: _tabs,
            currentIndex: currentIndex,
            compact: isNarrow,
            onTabSelected: (i) => widget.navigationShell.goBranch(
              i,
              initialLocation: i == currentIndex,
            ),
          ),
          Expanded(
            // A single, never-duplicated wrapper around the shell — see
            // _ShellFadeSlideTransition below for why this replaces
            // PageTransitionSwitcher.
            child: _ShellFadeSlideTransition(
              transitionKey: currentIndex,
              reverse: reverse,
              child: widget.navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShellFadeSlideTransition extends StatefulWidget {
  const _ShellFadeSlideTransition({
    required this.transitionKey,
    required this.reverse,
    required this.child,
  });

  final int transitionKey;
  final bool reverse;
  final Widget child;

  @override
  State<_ShellFadeSlideTransition> createState() =>
      _ShellFadeSlideTransitionState();
}

class _ShellFadeSlideTransitionState extends State<_ShellFadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppTheme.motionDuration,
  )..value = 1.0; // settled on first frame — no animation on initial load

  @override
  void didUpdateWidget(covariant _ShellFadeSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transitionKey != oldWidget.transitionKey) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: AppTheme.motionCurve,
    );
    final slideDirection = widget.reverse ? -1.0 : 1.0;

    return AnimatedBuilder(
      animation: curved,
      // `child` passed through AnimatedBuilder's child param, not rebuilt
      // per frame and never duplicated — this is what keeps the shell's
      // GlobalKey appearing exactly once in the tree at all times.
      child: widget.child,
      builder: (context, child) {
        final t = curved.value; // 0 -> 1 over the transition
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(slideDirection * (1 - t) * 24, 0),
            child: child,
          ),
        );
      },
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.compact,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: ConstrainedWidth(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 24,
              vertical: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'jC',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                //const Spacer(),
                Expanded(
                  flex: 14,
                  child: Center(
                    child: _TabBar(
                      tabs: tabs,
                      currentIndex: currentIndex,
                      onTabSelected: onTabSelected,
                      compact: compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.compact,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = compact ? 72.0 : 96.0;

        return SizedBox(
          width: tabWidth * tabs.length,
          child: Stack(
            children: [
              Row(
                children: List.generate(tabs.length, (i) {
                  final selected = i == currentIndex;
                  return SizedBox(
                    width: tabWidth,
                    child: InkWell(
                      onTap: () => onTabSelected(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          tabs[i],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: selected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              AnimatedPositioned(
                duration: AppTheme.motionDuration,
                curve: AppTheme.motionCurve,
                left: tabWidth * currentIndex,
                bottom: 0,
                width: tabWidth,
                height: 2,
                child: Container(color: AppColors.accent),
              ),
            ],
          ),
        );
      },
    );
  }
}
