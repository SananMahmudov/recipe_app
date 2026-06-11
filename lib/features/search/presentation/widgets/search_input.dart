import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<SearchCubit>();
    final mode = cubit.state.mode;
    final t = context.t;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 19, color: colors.textDim),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(fontSize: 16, color: colors.text),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: mode == SearchMode.name
                    ? t('searchPlaceholder')
                    : t('searchIngPlaceholder'),
                hintStyle: TextStyle(fontSize: 15, color: colors.textFaint),
              ),
              cursorColor: colors.accent,
              onChanged: (v) => context.read<SearchCubit>().onQueryChanged(v),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                context.read<SearchCubit>().clear();
              },
              child: Icon(Icons.close, size: 18, color: colors.textDim),
            ),
        ],
      ),
    );
  }
}
