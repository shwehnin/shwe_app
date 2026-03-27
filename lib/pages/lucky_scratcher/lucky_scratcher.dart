import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/config/routes/route_locations.dart';
import '/utils/extension.dart';
import '/utils/fonts.dart';
import '/utils/images.dart';

class LuckyScratcher extends StatefulWidget {
  const LuckyScratcher({super.key});
  @override
  State<LuckyScratcher> createState() => _LuckyScratcherState();
}

class _LuckyScratcherState extends State<LuckyScratcher> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(Imgs.luck, fit: BoxFit.contain, height: 230),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: 6,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 16 / 10,
              ),
              itemBuilder: (ctx, idx) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteLocation.scratcherDetail,
                      extra: idx,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.colors.primaryFixed,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(Imgs.goldOut),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Text(
                      "ခဲခြစ်ကဒ် ${idx + 1}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: Fonts.umoe,
                        fontSize: 23,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
