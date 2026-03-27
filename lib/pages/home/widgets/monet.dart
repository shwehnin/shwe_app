import 'package:flutter/material.dart';
import 'package:new_lion/utils/extension.dart';
import '../../../data/models/stock_model.dart';
import 'monet_text.dart';

class Monet extends StatelessWidget {
  final StockModel twod;
  const Monet({super.key, required this.twod});

  static const _headers = ['', 'Modern', 'Internet'];

  List<List<String>> get _rows => [
        ['09:30 AM', twod.of930?.modern ?? '--', twod.of930?.internet ?? '--'],
        ['02:00 PM', twod.of200?.modern ?? '--', twod.of200?.internet ?? '--'],
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: _headers
                  .map((h) => Expanded(
                        child: MoNetText(value: h, isHeader: true),
                      ))
                  .toList(),
            ),
          ),

          // Data rows
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: _rows.map((row) => _DataRow(cells: row)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final List<String> cells;
  const _DataRow({required this.cells});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: MoNetText(value: cells[0], isTime: true)),
          Expanded(child: MoNetText(value: cells[1])),
          Expanded(child: MoNetText(value: cells[2])),
        ],
      ),
    );
  }
}