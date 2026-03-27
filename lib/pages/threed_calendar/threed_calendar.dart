import 'package:flutter/material.dart';
import 'package:new_lion/config/localization/localization.dart';
import '../../data/api/threed_api.dart';
import '../../data/models/three_d_model.dart';
import '../../widgets/loading_view.dart';
import 'threed_helper.dart';
import 'widgets/threed_card.dart';

class ThreedCalendar extends StatefulWidget {
  const ThreedCalendar({super.key});

  @override
  State<ThreedCalendar> createState() => _ThreedCalendarState();
}

class _ThreedCalendarState extends State<ThreedCalendar> {
  bool _initLoading = false;
  final ScrollController controller = ScrollController();

  bool _loadMoreRunning = false;

  _getData() async {
    // if (ThreedHelper().threeDList.isNotEmpty) return;

    setState(() {
      _initLoading = true;
    });
    ThreedHelper().page = 1;
    ThreedHelper().hasNextPage = true;

    var resp = await ThreedApi.get(page: ThreedHelper().page);
    if (resp.status) {
      ThreedHelper().threeDList = resp.data;
    }

    setState(() {
      _initLoading = false;
    });
  }

  void _scrollListener() {
    if (!ThreedHelper().hasNextPage || _loadMoreRunning) return;
    var curPx = controller.position.pixels;
    var maxPx = controller.position.maxScrollExtent;
    if (maxPx - curPx < 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (ThreedHelper().hasNextPage == true &&
        _initLoading == false &&
        _loadMoreRunning == false) {
      setState(() {
        _loadMoreRunning = true;
      });
      ThreedHelper().page += 1;

      var resp = await ThreedApi.get(page: ThreedHelper().page);
      if (resp.status) {
        List<ThreeDModel> threed = resp.data;
        if (threed.isNotEmpty) {
          ThreedHelper().threeDList.addAll(threed);
          _loadMoreRunning = false;
        } else {
          _loadMoreRunning = false;
          ThreedHelper().hasNextPage = false;
        }
      }

      setState(() {});
    } else {
      ///normal scroll
    }
    return;
  }

  @override
  void initState() {
    controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.threed.tr())),
      body: Column(
        children: [
          Expanded(
            child: _initLoading
                ? const Center(child: LoadingView())
                : RefreshIndicator(
                    onRefresh: () async {
                      ThreedHelper().reset();
                      await _getData();
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: controller,
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      itemCount: ThreedHelper().threeDList.length,
                      itemBuilder: (ctx, idx) {
                        return ThreedCard(
                          threeD: ThreedHelper().threeDList[idx],
                        );
                      },
                    ),
                  ),
          ),
          if (_loadMoreRunning)
            const Padding(padding: EdgeInsets.all(8.0), child: LoadingView()),
        ],
      ),
    );
  }
}
