import 'package:flutter/material.dart';

/// Reusable centered loading indicator used across all screens
/// during async data fetching.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
