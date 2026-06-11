import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_spinner.dart';

class HomeCuisineList extends StatelessWidget {
  final List<String>? areas;
  final bool loading;

  const HomeCuisineList({
    super.key,
    required this.areas,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading || areas == null) return const AppSpinner();

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
        itemCount: areas!.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (ctx, i) => AppChip(
          label: areas![i],
          icon: Icons.public,
          onTap: () => Navigator.pushNamed(
            ctx,
            '/list',
            arguments: {'title': areas![i], 'type': 'area'},
          ),
        ),
      ),
    );
  }
}
