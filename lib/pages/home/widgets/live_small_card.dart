import 'package:flutter/material.dart';
import '../../../utils/extension.dart';
import 'live_helper.dart';
import 'set_value_helper.dart';
import '../../../provider/live_provider.dart';
import '../../../utils/const.dart';
import '../../../utils/fonts.dart';
import 'package:provider/provider.dart';
import '../../../widgets/blinker.dart';

class LiveSmallCard extends StatefulWidget {
  const LiveSmallCard({super.key});

  @override
  State<StatefulWidget> createState() => _LiveSmallCardState();
}

class _LiveSmallCardState extends State<LiveSmallCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LiveProvider>(
      builder: (ctx, state, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.primaryFixed,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        "LIVE",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        "SET",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        "VAL",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        "2D",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Blinker(
                      isActive: state.data.isRunning == true,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: SetValHelper.setPrefix(
                                    state.data.currentState == Const.round1
                                        ? state.data.round1!.set!
                                        : state.data.round2!.set!,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: Fonts.en,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: SetValHelper.setSuffix(
                                        state.data.currentState == Const.round1
                                            ? state.data.round1!.set!
                                            : state.data.round2!.set!,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: SetValHelper.valuePrefix(
                                    state.data.currentState == Const.round1
                                        ? state.data.round1!.value!
                                        : state.data.round2!.value!,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: Fonts.en,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: SetValHelper.valueMiddle(
                                        state.data.currentState == Const.round1
                                            ? state.data.round1!.value!
                                            : state.data.round2!.value!,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: SetValHelper.valueSuffix(
                                            state.data.currentState ==
                                                    Const.round1
                                                ? state.data.round1!.value!
                                                : state.data.round2!.value!,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        state.data.isRunning == true
                            ? "--"
                            : LiveHelper.getResult(
                                setNum: state.data.currentState == Const.round1
                                    ? state.data.round1!.set
                                    : state.data.round2!.set,
                                valueNum:
                                    state.data.currentState == Const.round1
                                    ? state.data.round1!.value
                                    : state.data.round2!.value,
                              ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
