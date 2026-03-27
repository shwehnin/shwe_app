import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_lion/pages/home/widgets/marquee_text.dart';
import 'package:new_lion/utils/extension.dart';
import 'package:new_lion/utils/global.dart';
import 'package:new_lion/utils/images.dart';
import '../../admob/ad_units.dart';
import 'widgets/live_helper.dart';
import 'widgets/main_number_card.dart';
import 'widgets/monet.dart';
import '../../utils/const.dart';
import '../../widgets/blinker.dart';
import '../../provider/live_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd? _bannerAd;
  final ValueNotifier<bool> _isBannerLoaded = ValueNotifier<bool>(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBanner();
    });
    super.initState();
  }

  _loadBanner() async {
    if (Global.offAds) return;
    _bannerAd = BannerAd(
      adUnitId: AdUnits.banner,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _isBannerLoaded.value = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<LiveProvider>(
          builder: (ctx, state, _) {
            return Column(
              children: [
                MarqueeTxt(),

                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.sizeOf(context).height / 5,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.colors.primary,

                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: .15,
                        child: RotatedBox(
                          quarterTurns: -3,
                          child: Image.asset(
                            Imgs.bg,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 90,
                              height: 90,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Blinker(
                                isActive: state.data.isRunning == true,
                                child: Text(
                                  LiveHelper.getResult(
                                    setNum:
                                        state.data.currentState == Const.round1
                                        ? state.data.round1!.set
                                        : state.data.round2!.set,
                                    valueNum:
                                        state.data.currentState == Const.round1
                                        ? state.data.round1!.value
                                        : state.data.round2!.value,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  state.data.isRunning == true
                                      ? Icons.update_rounded
                                      : Icons.check_circle_rounded,
                                  size: 20,
                                  color: state.data.isRunning == true
                                      ? Colors.deepOrange
                                      : Colors.green,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  textAlign: TextAlign.center,
                                  "${state.data.updateDesc}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      MainNumberCard(twod: state.data),
                      ValueListenableBuilder(
                        valueListenable: _isBannerLoaded,
                        builder: (ctx, loaded, _) {
                          return loaded
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                )
                              : const SizedBox(height: 10);
                        },
                      ),

                      Monet(twod: state.data),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
