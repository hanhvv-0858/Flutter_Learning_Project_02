import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/features/onboarding/presentation/widgets/tutorial_page_data.dart';

/// Displays a single onboarding tutorial page with an icon, title, and body.
class OnboardingPageItem extends StatelessWidget {
  final TutorialPageData page;

  const OnboardingPageItem({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Push content to ~40% from top for a visually balanced layout
          const Spacer(flex: 2),
          Icon(page.icon, size: 120, color: colorScheme.primary),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
