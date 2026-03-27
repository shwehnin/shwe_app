import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/config/localization/localization.dart';
import '../../admob/ad_helper.dart';
import '../../config/routes/route_locations.dart';
import '../../data/models/gift_type_model.dart';
import 'widgets/carousel.dart';
import '../../utils/global.dart';
import '../../widgets/network_imge_view.dart';

class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.giftCard.tr()),),
      body:  ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Carousel(),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: Global.config.giftType?.length ?? 0,
          itemBuilder: (ctx, idx) {
            GiftTypeModel card = Global.config.giftType![idx];
            return Stack(
              children: [
                NetworkImageView(
                  borderRadius: BorderRadius.circular(16),
                  url: card.cover,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (card.adsType == "rewarded") {
                          AdHelper.showRewardedAd(
                            onComplete: () {
                              _goDetail(context, card);
                            },
                          );
                        } else if (card.adsType == "interstitial") {
                          AdHelper.showInterstitialAd(
                            onComplete: () {
                              _goDetail(context, card);
                            },
                          );
                        } else {
                          _goDetail(context, card);
                        }
                      },
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    )
  ,
    );
  }

  _goDetail(BuildContext context, GiftTypeModel card) {
    context.pushNamed(RouteLocation.luckyDetail, extra: card);
  }
}
