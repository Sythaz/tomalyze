import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tomalyze/core/constants/app_text_styles.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/history_classification_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryClassificationModel history;

  const HistoryCard({super.key, required this.history});

  String _labelText(String label) {
    switch (label) {
      case 'ripe':
        return 'Ripe';
      case 'half-ripe':
        return 'Half-ripe';
      case 'unripe':
        return 'Unripe';
      default:
        return 'Unknown';
    }
  }

  Color _labelColor(String label) {
    switch (label) {
      case 'ripe':
        return Colors.red;
      case 'half-ripe':
        return Colors.orange;
      case 'unripe':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _maxProbability(List<double> probs) {
    return probs.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final color = _labelColor(history.svmPrediction);
    final confidence = (_maxProbability(history.svmProbability) * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.05)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: history.imagePath != null
                ? Image.file(
                    File(history.imagePath!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelText(history.svmPrediction),
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 12,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  history.createdAt != null
                      ? timeago.format(history.createdAt!)
                      : '-',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 12,
                    color: AppColors.blackGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$confidence%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
