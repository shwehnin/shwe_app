import 'package:flutter/material.dart';
import 'package:new_lion/utils/extension.dart';
import '../../../data/models/stock_model.dart';
import 'live_helper.dart';
import '../../../utils/const.dart';
import 'set_value_text.dart';

class MainNumberCard extends StatelessWidget {
  final StockModel twod;

  const MainNumberCard({super.key, required this.twod});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _RoundCard(twod: twod, is12: true)),
        const SizedBox(width: 10),
        Expanded(child: _RoundCard(twod: twod, is12: false)),
      ],
    );
  }
}

class _RoundCard extends StatelessWidget {
  final StockModel twod;
  final bool is12;

  const _RoundCard({required this.twod, required this.is12});

  @override
  Widget build(BuildContext context) {
    final round = is12 ? twod.round1! : twod.round2!;
    final isActive = is12
        ? twod.currentState == Const.round1
        : twod.currentState != Const.round1;
    final isBlink = twod.isRunning == true && isActive;
    final isRunningThisRound = twod.isRunning == true && isActive;

    final result = isRunningThisRound
        ? '--'
        : LiveHelper.getResult(setNum: round.set, valueNum: round.value);

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
          // Time label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Text(
              is12 ? '12:01 PM' : '04:30 PM',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Result circle
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      height: 1,
                    ),
                  ),
                ),

                _InfoRow(
                  label: 'SET',
                  text: round.set ?? '--',
                  isBlink: isBlink,
                  isSET: true,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'VAL',
                  text: round.value ?? '--',
                  isBlink: isBlink,
                  isSET: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String text;
  final bool isBlink;
  final bool isSET;

  const _InfoRow({
    required this.label,
    required this.text,
    required this.isBlink,
    required this.isSET,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Fixed label pill
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Value text — no Expanded, just let it size naturally
          Expanded(
            flex: 2,
            child: SetValueText(
              isBlink: isBlink,
              text: text,
              isSET: isSET,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}