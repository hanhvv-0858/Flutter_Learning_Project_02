import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/core/router/route_constants.dart';
import 'package:example_flutter_02/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:example_flutter_02/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:example_flutter_02/features/onboarding/presentation/widgets/onboarding_page_item.dart';
import 'package:example_flutter_02/features/onboarding/presentation/widgets/tutorial_page_data.dart';

/// Full-screen onboarding tutorial with swipeable pages, indicator dots,
/// Skip and Next/Get Started buttons.
///
/// Navigation is button-driven only (PageView is not user-swipeable) so
/// the [OnboardingCubit] remains the single source of truth for current page.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = TutorialPageData.getPages(l10n);

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.go(RouteConstants.home);
        }
        // Animate PageController to follow cubit's current page.
        if (state is OnboardingActive) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        final currentPage = state is OnboardingActive ? state.currentPage : 0;
        final isLastPage = currentPage == pages.length - 1;

        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Skip button — top right corner, hidden on last page
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        onPressed: isLastPage
                            ? null
                            : () => context.read<OnboardingCubit>().skip(),
                        child: Text(l10n.onboardingSkip),
                      ),
                    ),
                  ),
                ),

                // Tutorial page content — swipe enabled
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const PageScrollPhysics(),
                    onPageChanged: (index) =>
                        context.read<OnboardingCubit>().syncPage(index),
                    itemCount: pages.length,
                    itemBuilder: (context, index) =>
                        OnboardingPageItem(page: pages[index]),
                  ),
                ),

                // Page indicator dots
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => _PageDot(isActive: index == currentPage),
                    ),
                  ),
                ),

                // Next / Get Started button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => context.read<OnboardingCubit>().nextPage(
                        pages.length,
                      ),
                      child: Text(
                        isLastPage
                            ? l10n.onboardingGetStarted
                            : l10n.onboardingNext,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Small animated dot for page position indicator.
class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
