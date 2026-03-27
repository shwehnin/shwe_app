import 'package:flutter/material.dart';
import '../../data/api/twod_api.dart';
import '../../data/models/stock_model.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import 'calendar/select_m_y.dart';
import '../../widgets/loading_view.dart';
import 'calendar/calendar_header.dart';
import 'calendar_helper.dart';

class TwodCalendar extends StatefulWidget {
  const TwodCalendar({super.key});

  @override
  State<StatefulWidget> createState() => _ThreedCustomCalendarState();
}

class _ThreedCustomCalendarState extends State<TwodCalendar> {
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData(isInit: true);
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  _getData({bool isInit = false}) async {
    if (isInit && CalendarHelper.list.isNotEmpty) return;

    if (isInit) setState(() => isLoading = true);
    if (!isInit) EasyOverlay.show();

    var resp = await TwodApi.byYear(
      month: CalendarHelper.current.month,
      year: CalendarHelper.current.year,
    );

    if (resp.status) {
      CalendarHelper.list = resp.data as List<StockModel>;
      if (!isInit) EasyOverlay.dismiss();
      if (isInit) isLoading = false;
      setState(() {});
    }
  }

  _onSelect() async {
    var dt = await EasyOverlay.show(
      child: SelectMY(dateTime: CalendarHelper.current),
    );
    if (dt is DateTime) {
      CalendarHelper.current = dt;
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("2D Calendar"),),
      body: isLoading
          ? const LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Calendar2D(
                month: CalendarHelper.current,
                list: CalendarHelper.list,
                onSelect: _onSelect,
                pre: () {
                  CalendarHelper.current =
                      CalendarHelper.subtractMonth(CalendarHelper.current, 1);
                  _getData();
                },
                next: () {
                  CalendarHelper.current =
                      CalendarHelper.addMonth(CalendarHelper.current, 1);
                  _getData();
                },
              ),
            ),
    );
  }
}
