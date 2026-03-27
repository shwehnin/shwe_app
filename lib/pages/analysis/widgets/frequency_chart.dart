import 'package:flutter/material.dart';
import '../../../data/models/frequency_model.dart';

class MinimalistFrequencyChart extends StatelessWidget {
  final FrequencyModel frequency;
  const MinimalistFrequencyChart({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    final frequencyData = frequency.result ?? {};
    final labels = frequencyData.keys.toList();
    final values = frequencyData.values.cast<int>().toList();
    final total = values.isNotEmpty ? values.reduce((a, b) => a + b) : 0;
    final maxValue = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b)
        : 1;

    // Sort by value descending for ranked display
    final sorted = List.generate(
      labels.length,
      (i) => _Entry(labels[i], values[i]),
    )..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                frequency.title ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── Bars ─────────────────────────────────────────────
          labels.isEmpty
              ? _EmptyState()
              : Column(
                  children: List.generate(
                    labels.length.clamp(0, 10),
                    (i) => _HorizontalBar(
                      label: labels[i],
                      value: values[i],
                      maxValue: maxValue,
                      isMax: values[i] == maxValue,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Entry helper ──────────────────────────────────────────────────────────────

class _Entry {
  final String label;
  final int value;
  _Entry(this.label, this.value);
}

// ── Horizontal Bar ────────────────────────────────────────────────────────────

class _HorizontalBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final bool isMax;

  const _HorizontalBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.isMax,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue > 0 ? value / maxValue : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: 26,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isMax ? FontWeight.w700 : FontWeight.w500,
                color: isMax
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Track + fill
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  // Track
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Fill
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    widthFactor: ratio.clamp(0.03, 1.0),
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: isMax
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF3B82F6).withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Value
          SizedBox(
            width: 120,
            child: Text(
              '$value ကြိမ်',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isMax ? FontWeight.w600 : FontWeight.w400,
                color: isMax
                    ? const Color(0xFF93C5FD)
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
