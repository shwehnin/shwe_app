import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/localization/localization.dart';

final privacyPolicyStateKey = GlobalKey<PrivacyPolicyState>();

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<StatefulWidget> createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  late WebViewController controller;
  String? err;
  double webProgress = 0;

  @override
  void initState() {
    _load();
    super.initState();
  }

  _load() {
    setState(() {
      err = null;
      webProgress = 0;
    });
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              webProgress = progress / 100;
            });
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) async {
            setState(() {
              err = error.description;
            });
          },
          // onNavigationRequest: (NavigationRequest request) {
          // if (request.url.startsWith('https://www.youtube.com/')) {
          //   return NavigationDecision.prevent;
          // }
          // return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse("https://lion-2d.web.app/privacy-policy.html"));
  }

  @override
  void dispose() {
    if (mounted) super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.privacyPolicy.tr())),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: err != null
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    err!,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    onPressed: () {
                      _load();
                    },
                    child: const Text('Reload'),
                  )
                ]),
              )
            : Column(
                children: [
                  webProgress < 1
                      ? SizedBox(
                          height: 5,
                          child: LinearProgressIndicator(
                            color: Colors.blue,
                            value: webProgress,
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: WebViewWidget(
                      controller: controller,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
