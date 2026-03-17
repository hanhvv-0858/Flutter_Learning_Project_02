import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_learning_project_2/core/l10n/app_localizations.dart';
import 'package:flutter_learning_project_2/core/router/route_constants.dart';
import 'package:flutter_learning_project_2/core/widgets/error_view.dart';
import 'package:flutter_learning_project_2/core/widgets/loading_view.dart';
import 'package:flutter_learning_project_2/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_learning_project_2/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_learning_project_2/features/search/presentation/bloc/search_state.dart';
import 'package:flutter_learning_project_2/features/search/presentation/widgets/search_result_item.dart';

/// Search screen with animated search bar and debounced live results.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field on open.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.searchPlaceholder,
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchQueryChanged(value));
          },
          onSubmitted: (value) {
            context.read<SearchBloc>().add(SearchSubmitted(value));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              context.read<SearchBloc>().add(const SearchQueryChanged(''));
              _focusNode.requestFocus();
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => switch (state) {
          SearchInitial() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.searchPlaceholder,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SearchLoading() => const LoadingView(),
          SearchLoaded(:final albums) => ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return SearchResultItem(
                album: album,
                onTap: () => context.push(
                  RouteConstants.detailRoute(album.id),
                  extra: album,
                ),
              );
            },
          ),
          SearchEmpty() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.searchNoResults,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SearchError(:final message) => ErrorView(
            message: message,
            onRetry: () {
              final query = _controller.text.trim();
              if (query.isNotEmpty) {
                context.read<SearchBloc>().add(SearchSubmitted(query));
              }
            },
          ),
        },
      ),
    );
  }
}
