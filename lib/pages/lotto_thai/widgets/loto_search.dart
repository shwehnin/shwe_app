import 'package:new_lion/utils/extension.dart';

import '../../../data/models/lotto_thai_model.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'found_prize.dart';
import 'prize_not_found.dart';

class LotoSearch extends StatefulWidget {
  final LottoThaiModel lottoThai;
  const LotoSearch({super.key, required this.lottoThai});

  @override
  State<LotoSearch> createState() => _LotoSearchState();
}

class _LotoSearchState extends State<LotoSearch> {
  final controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultPin = PinTheme(
      width: 48,
      height: 58,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );

    final focusedPin = defaultPin.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.primary, width: 2),
      ),
    );

    final submittedPin = defaultPin.copyWith(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: accent.withValues(alpha:0.5)),
      ),
    );

    final isReady = controller.text.length == 6;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PRIZE CHECK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big label
                const Text(
                  'Enter your\nnumber.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text('6-digit lottery number', style: TextStyle(fontSize: 14)),

                const SizedBox(height: 48),

                // Pin input
                Center(
                  child: Pinput(
                    length: 6,
                    controller: controller,
                    autofocus: true,
                    showCursor: true,
                    defaultPinTheme: defaultPin,
                    focusedPinTheme: focusedPin,
                    submittedPinTheme: submittedPin,
                    pinAnimationType: PinAnimationType.fade,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (_) => _onSearch(),
                    onChanged: (_) => setState(() {}),
                    cursor: Container(
                      width: 2,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Search button
                GestureDetector(
                  onTap: isReady && !_isSearching
                      ? () {
                          FocusScope.of(context).unfocus();
                          setState(() => _isSearching = true);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            _onSearch();
                            if (mounted) setState(() => _isSearching = false);
                          });
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isReady ? Colors.orange : context.colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: _isSearching
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isReady ? Colors.black : Colors.white,
                            ),
                          )
                        : Text(
                            isReady ? 'Search Prize' : 'Enter 6 digits',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isReady ? Colors.black : Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Auto hint
                Text(
                  'Auto-searches when all 6 digits entered',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSearch() {
    var pins = controller.text.trim();
    if (pins.length != 6) return;

    var prize = widget.lottoThai.prize;
    var nums = pins.split("");

    final checks = [
      (prize?.firstPrize == pins, 'First Prize', '6,000,000'),
      (
        (prize?.first3Digits ?? []).contains('${nums[0]}${nums[1]}${nums[2]}'),
        'First 3 Digits',
        '4,000',
      ),
      (
        (prize?.last3Digits ?? []).contains('${nums[3]}${nums[4]}${nums[5]}'),
        'Last 3 Digits',
        '4,000',
      ),
      (
        (prize?.nearFirstPrize ?? []).contains(pins),
        'Near First Prize',
        '100,000',
      ),
      ((prize?.secondPrize ?? []).contains(pins), '2nd Prize', '200,000'),
      ((prize?.thirdPrize ?? []).contains(pins), '3rd Prize', '80,000'),
      ((prize?.fourthPrize ?? []).contains(pins), '4th Prize', '40,000'),
      ((prize?.fifthPrize ?? []).contains(pins), '5th Prize', '20,000'),
      (prize?.last2Digits == '${nums[4]}${nums[5]}', 'Last 2 Digits', '2,000'),
    ];

    for (final (matched, desc, amount) in checks) {
      if (matched) {
        _showPrize(desc, amount);
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrizeNotFound(),
    );
  }

  void _showPrize(String desc, String prize) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FoundPrize(prizeDesc: desc, prize: prize),
    );
  }
}
