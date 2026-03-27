import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/utils/extension.dart';
import '../../widgets/loading_view.dart';
import '../../config/localization/locale_keys.g.dart';
import '../../config/routes/route_locations.dart';
import '../../data/api/loto_thai_api.dart';
import '../../data/models/lotto_thai_model.dart';
import '../../utils/app_colors.dart';

class LottoThai extends StatefulWidget {
  const LottoThai({super.key});

  @override
  State<StatefulWidget> createState() => _LottoThaiState();
}

class _LottoThaiState extends State<LottoThai> {
  bool isLoading = true;
  LottoThaiModel? lotoData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getLotoData());
  }

  _getLotoData() async {
    setState(() => isLoading = true);
    var response = await LotoThaiApi.get();
    if (response.status) lotoData = response.data;
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          LocaleKeys.thaiLotto.tr(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),

        actions: lotoData?.date == null
            ? []
            : [
                Text(
                  lotoData!.date!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (lotoData == null) return;
                    context.pushNamed(
                      RouteLocation.lottoSearch,
                      extra: lotoData,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Check',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
      ),
      body: isLoading && lotoData == null
          ? const LoadingView()
          : lotoData != null
          ? _buildResults(lotoData!)
          : _buildEmpty(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No data',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _getLotoData,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(LottoThaiModel result) {
    final prize = result.prize;
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: AppColors.darkCard,
      onRefresh: () async => _getLotoData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        child: Column(
          children: [
            _FirstPrizeCard(number: prize?.firstPrize ?? ''),
            const SizedBox(height: 12),
            if (prize?.nearFirstPrize?.isNotEmpty == true)
              _PrizeSection(
                label: 'NEAR 1ST',
                amount: '฿100,000',
                numbers: prize!.nearFirstPrize!,
                accent: AppColors.warning,
              ),
            if (prize?.last2Digits != null)
              _SingleRow(
                label: 'LAST 2 DIGITS',
                amount: '฿2,000',
                number: prize!.last2Digits!,
                accent: AppColors.success,
              ),
            if (prize?.first3Digits?.isNotEmpty == true)
              _PrizeSection(
                label: 'FIRST 3',
                amount: '฿4,000',
                numbers: prize!.first3Digits!,
                accent: Colors.limeAccent,
              ),
            if (prize?.last3Digits?.isNotEmpty == true)
              _PrizeSection(
                label: 'LAST 3',
                amount: '฿4,000',
                numbers: prize!.last3Digits!,
                accent: AppColors.cyan,
              ),
            if (prize?.secondPrize?.isNotEmpty == true)
              _PrizeSection(
                label: '2ND PRIZE',
                amount: '฿200,000',
                numbers: prize!.secondPrize!,
                accent: AppColors.error,
              ),
            if (prize?.thirdPrize?.isNotEmpty == true)
              _PrizeSection(
                label: '3RD PRIZE',
                amount: '฿80,000',
                numbers: prize!.thirdPrize!,
                accent: AppColors.orange,
              ),
            if (prize?.fourthPrize?.isNotEmpty == true)
              _PrizeSection(
                label: '4TH PRIZE',
                amount: '฿40,000',
                numbers: prize!.fourthPrize!,
                accent: AppColors.lime,
              ),
            if (prize?.fifthPrize?.isNotEmpty == true)
              _PrizeSection(
                label: '5TH PRIZE',
                amount: '฿20,000',
                numbers: prize!.fifthPrize!,
                accent: AppColors.indigo,
              ),
          ],
        ),
      ),
    );
  }
}

// ── First Prize ──────────────────────────────
class _FirstPrizeCard extends StatelessWidget {
  final String number;
  const _FirstPrizeCard({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1ST PRIZE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                '฿6,000,000',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: number.split('').map((digit) {
              return Container(
                width: 44,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  digit,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Multi-number section ──────────────────────
class _PrizeSection extends StatelessWidget {
  final String label;
  final String amount;
  final List<String> numbers;
  final Color accent;

  const _PrizeSection({
    required this.label,
    required this.amount,
    required this.numbers,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final cols = numbers.first.length <= 3 ? 5 : 3;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: numbers.first.length <= 3 ? 2.0 : 2.5,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: numbers.length,
            itemBuilder: (_, i) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                numbers[i],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single number row ─────────────────────────
class _SingleRow extends StatelessWidget {
  final String label;
  final String amount;
  final String number;
  final Color accent;

  const _SingleRow({
    required this.label,
    required this.amount,
    required this.number,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            number.isEmpty ? '--' : number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}
