import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../admob/ad_units.dart';
import '../home/widgets/live_small_card.dart';
import '../../utils/extension.dart';
import '../../config/routes/route_locations.dart';
import '../../data/api/public_chat_api.dart';
import 'widgets/chat_list_view.dart';
import 'widgets/chat_message_input.dart';
import '../../provider/public_chat_provider.dart';
import '../../utils/global.dart';
import '../../utils/reusable.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import '../../widgets/loading_view.dart';
import 'package:provider/provider.dart';

class PublicChat extends StatefulWidget {
  const PublicChat({super.key});

  @override
  State<PublicChat> createState() => _PublicChatState();
}

class _PublicChatState extends State<PublicChat> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  late PublicChatProvider _chatProvider;
  bool isLoading = true;
  bool isSending = false;

  BannerAd? _bannerAd;
  final ValueNotifier<bool> _isLoaded = ValueNotifier<bool>(false);

  _loadBanner() async {
    _bannerAd = BannerAd(
      adUnitId: AdUnits.banner,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _isLoaded.value = true;
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
  void initState() {
    _chatProvider = Provider.of<PublicChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getData();
      _loadBanner();
    });
    super.initState();
  }

  Future<void> _getData() async {
    var response = await PublicChatApi.getChatHistory();
    if (response.status) {
      _chatProvider.assign(response.data);
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: context.colors.primaryFixed),
            child: SafeArea(
              top: true,
              left: false,
              right: false,
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(child: const LiveSmallCard()),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isLoaded,
                    builder: (ctx, loaded, _) {
                      return loaded
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            )
                          : const SizedBox(height: 10);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const LoadingView()
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Consumer<PublicChatProvider>(
                      builder: (ctx, pd, _) {
                        return Column(
                          children: [
                            Expanded(
                              child: ChatListView(
                                messages: pd.messages,
                                scrollController: scrollController,
                              ),
                            ),
                            ChatMessageInput(
                              controller: messageController,
                              isSending: isSending,
                              onSend: _send,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _send() {
    if (Global.user == null) {
      context.pushNamed(RouteLocation.login);
      return;
    }

    var message = messageController.text.trim();
    if (message.isEmpty) return;

    var banedKeywords = Reusable.checkKeyword(input: message);
    if (banedKeywords.isNotEmpty) {
      EasyOverlay.showToast(
        message: "banned keywords ${banedKeywords.join(',')}",
      );
      return;
    }

    if (Global.liveSocket.value == "Connected") {
      Global.webSocket.send(
        json.encode({
          "action": "chat_message",
          "type": "text",
          "content": message,
          "sender": Global.user!.toJson(),
        }),
      );
    }

    messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
