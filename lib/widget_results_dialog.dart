import 'package:flutter/material.dart';
import 'package:shadesmaster/analysis/analyze.dart';

String analysisProblemMessage(AnalysisProblem problem) {
  switch (problem) {
    case AnalysisProblem.emptyTeeth:
      return "The teeth areas don't cover any pixels of the photo";
    case AnalysisProblem.emptyShades:
      return "The shade areas don't cover any pixels of the photo";
  }
}

String matchCategoryLabel(MatchCategory category) {
  switch (category) {
    case MatchCategory.excellent:
      return 'Excellent match';
    case MatchCategory.acceptable:
      return 'Clinically acceptable';
    case MatchCategory.moderatelyUnacceptable:
      return 'Moderately unacceptable';
    case MatchCategory.clearlyUnacceptable:
      return 'Clearly unacceptable';
    case MatchCategory.extremelyUnacceptable:
      return 'Extremely unacceptable';
  }
}

Color matchCategoryColor(MatchCategory category) {
  switch (category) {
    case MatchCategory.excellent:
      return Colors.green.shade700;
    case MatchCategory.acceptable:
      return Colors.lightGreen.shade800;
    case MatchCategory.moderatelyUnacceptable:
      return Colors.orange.shade800;
    case MatchCategory.clearlyUnacceptable:
    case MatchCategory.extremelyUnacceptable:
      return Colors.red.shade700;
  }
}

Future<void> showResultsDialog(BuildContext context, AnalysisResult results) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Color Matches'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final shade in results.shades) ShadeResultTile(shade: shade),
            if (results.teeth.length > 1) ...[
              const SizedBox(height: 12),
              Text('Per tooth', style: Theme.of(context).textTheme.titleSmall),
              for (final tooth in results.teeth)
                ListTile(
                  dense: true,
                  leading: _Swatch(color: tooth.averageColor),
                  title: Text('Tooth ${tooth.index + 1} → Shade ${tooth.winner.name}'),
                  subtitle: Text(_deltaText(tooth.winner)),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

String _deltaText(ShadeResult shade) {
  if (!shade.hasPixels) return 'No pixels in this area';
  return 'ΔE00 ${shade.delta.toStringAsFixed(2)} · ${matchCategoryLabel(shade.category)}';
}

class ShadeResultTile extends StatelessWidget {
  final ShadeResult shade;
  const ShadeResultTile({super.key, required this.shade});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        selected: shade.winner,
        selectedColor: Colors.green,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Swatch(color: shade.averageColor),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward),
          ],
        ),
        title: Text('Shade ${shade.name}'),
        subtitle: Text(
          _deltaText(shade),
          style: TextStyle(color: shade.hasPixels ? matchCategoryColor(shade.category) : null),
        ),
        trailing: shade.winner ? Text("Winner") : SizedBox.shrink(),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  const _Swatch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}
