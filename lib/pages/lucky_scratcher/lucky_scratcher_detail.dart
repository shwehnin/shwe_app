import 'package:flutter/material.dart';
import 'package:new_lion/utils/extension.dart';
import 'package:new_lion/utils/fonts.dart';
import 'package:new_lion/utils/images.dart';
import '/admob/ad_helper.dart';
import '/data/models/scratch_model.dart';
import './scratcher_helper.dart';
import '/widgets/loading_view.dart';
import 'package:scratcher/widgets.dart';

class LuckyScratcherDetail extends StatefulWidget {
  final int id;
  const LuckyScratcherDetail({super.key, required this.id});

  @override
  State<LuckyScratcherDetail> createState() => _LuckyScratcherDetailState();
}

class _LuckyScratcherDetailState extends State<LuckyScratcherDetail> {
  double _opacity = 0;
  ScratchCards? card;
  bool isLoading = true;
  String luckyNumber = "${RandomInt.generate()}${RandomInt.generate()}";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AdHelper.showInterstitialAd(onComplete: () {});
      card = await ScratcherHelper.checkScratchedById(id: widget.id);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ခဲခြစ်ကဒ်")),
      body: Stack(
        children: [
          Center(
            child: isLoading
                ? const LoadingView()
                : Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'တစ်ရက်လျှင်တစ်ကြိမ်သာ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            height: 2,
                            fontFamily: Fonts.umoe,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: card == null
                              ? Scratcher(
                                  brushSize: 20,
                                  threshold: 50,
                                  color: const Color(0xffBCC6CC),
                                  onChange: (value) {
                                    if (value >= 40) {
                                      _opacity = 1;
                                      setState(() {});
                                      ScratcherHelper.saveNewCard(
                                        id: widget.id,
                                        nums: luckyNumber,
                                      );
                                    }
                                  },
                                  image: Image.asset(
                                    Imgs.goldOut,
                                    fit: BoxFit.fill,
                                  ),
                                  child: numCard(),
                                )
                              : numCard(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ခဲခြစ်ကဒ် နံပါတ် − ${widget.id + 1}\n ${card == null ? "လက်ဖြင့်ခြစ်ပါ" : ""}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.5,
                            fontFamily: Fonts.umoe,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget numCard() {
    return Container(
      height: 160,
      width: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage(Imgs.goldIn),
          fit: BoxFit.fill,
        ),
      ),
      child: AnimatedOpacity(
        opacity: card == null ? _opacity : 1,
        duration: Durations.long1,
        child: Text(
          card == null ? luckyNumber : card!.nums.toString(),
          style: const TextStyle(
            fontSize: 80,
            letterSpacing: 30,
            fontFamily: Fonts.en,
            color: Color(0xffE5B80B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
