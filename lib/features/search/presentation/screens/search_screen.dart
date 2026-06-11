import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_header.dart';
import '../widgets/search_mode_selector.dart';
import '../widgets/search_input.dart';
import '../widgets/search_results_view.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Column(
      children: [
        AppHeader(large: true, title: t('tabSearch')),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Column(
            children: const [
              SearchModeSelector(),
              SizedBox(height: 12),
              SearchInput(),
            ],
          ),
        ),
        const Expanded(child: SearchResultsView()),
      ],
    );
  }
}
