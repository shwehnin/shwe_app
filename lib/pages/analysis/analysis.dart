import 'package:flutter/material.dart';
import '../../data/api/twod_api.dart';
import '../../data/models/analysis_model.dart';
import 'widgets/frequency_chart.dart';
import 'widgets/missed_numbers.dart';
import '../../widgets/loading_view.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<StatefulWidget> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  AnalysisModel? analysis;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  _getData() async {
    var response = await TwodApi.analysis();

    if (response.status) {
      analysis = response.data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Analysis Chart")),
      body: Center(
        child: analysis == null
            ? LoadingView()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    MinimalistMissedNumbers(miss: analysis!.miss!),
                    SizedBox(height: 10),
                    MinimalistFrequencyChart(frequency: analysis!.frequency!),
                  ],
                ),
              ),
      ),
    );
  }
}
