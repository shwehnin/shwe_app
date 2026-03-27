import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../admob/ad_units.dart';
import '../home/widgets/live_small_card.dart';
import '../../provider/block_provider.dart';
import '../../provider/chat_room_provider.dart';
import '../../utils/extension.dart';
import '../../config/routes/route_locations.dart';
import '../../data/api/private_chat_api.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/user_model.dart';
import 'widgets/chat_list_view.dart';
import 'widgets/chat_message_input.dart';
import '../../provider/private_chat_provider.dart';
import '../../utils/global.dart';
import '../../utils/reusable.dart';
import '../../utils/socket_helper.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import '../../widgets/loading_view.dart';
import 'package:provider/provider.dart';

class PrivateChat extends StatefulWidget {
  final ChatRoomModel chatRoom;
  const PrivateChat({super.key, required this.chatRoom});

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  late PrivateChatProvider _chatProvider;
  late ChatRoomProvider _chatRoomProvider;
  bool isLoading = true;
  bool isSending = false;
  Timer? _messageTimer;
  final List<ChatMessageModel> _pendingMessages = [];
  late BlockProvider _blockProvider;
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
    _blockProvider = Provider.of(context, listen: false);
    _chatProvider = Provider.of(context, listen: false);
    _chatRoomProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SocketHelper.initialize();
      SocketHelper.off(cmd: SocketCommand.privateNewMessage);
      await _getData();
      _listenSocket();
      _loadBanner();
    });
    super.initState();
  }

  void _listenSocket() {
    SocketHelper.listen(
      cmd: SocketCommand.privateNewMessage,
      callback: (message) {
        if (!mounted) return;
        var msg = ChatMessageModel.fromJson(message);

        // Check blocked user
        List<UserModel> list = Global.config.user?.blockList ?? [];
        if (list.any((e) => e.id == msg.sender!.id)) return;
        if (msg.chatRoom != widget.chatRoom.id) return;

        _pendingMessages.add(msg);
        _messageTimer?.cancel();
        _messageTimer = Timer(const Duration(milliseconds: 100), () {
          _processPendingMessages();
        });
      },
    );
  }

  void _processPendingMessages() {
    if (_pendingMessages.isEmpty) return;
    _pendingMessages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    for (var msg in _pendingMessages) {
      _chatProvider.addNew(msg);
      _chatRoomProvider.updateLastMessage(
        roomId: widget.chatRoom.id!,
        message: msg,
      );
    }
    _pendingMessages.clear();
  }

  Future<void> _getData() async {
    var response = await PrivateChatApi.loadHistory(
      chatRoomId: widget.chatRoom.id!,
    );
    if (response.status) {
      _chatProvider.assign(response.data);
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    SocketHelper.disconnect();
    messageController.dispose();
    scrollController.dispose();
    _messageTimer?.cancel();
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
                    child: Consumer<PrivateChatProvider>(
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

  void _send() async {
    if (Global.user == null) {
      context.pushNamed(RouteLocation.login);
      return;
    }

    var otherUser = widget.chatRoom.members!
        .where((usr) => usr.id != Global.user!.id!)
        .first;
    if (_blockProvider.exist(otherUser.id!)) {
      EasyOverlay.showToast(message: "Unblock first");
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

    setState(() => isSending = true);
    var response = await PrivateChatApi.sendMessage(
      content: message,
      chatRoomId: widget.chatRoom.id!,
    );
    setState(() => isSending = false);

    if (response.status) {
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
}
