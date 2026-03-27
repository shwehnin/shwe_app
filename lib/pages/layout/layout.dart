import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_lion/admob/ad_helper.dart';
import 'package:new_lion/data/models/chat_message_model.dart';
import 'package:new_lion/data/models/in_app_message.dart';
import 'package:new_lion/data/models/nav_item.dart';
import 'package:new_lion/data/models/stock_model.dart';
import 'package:new_lion/data/models/user_model.dart';
import 'package:new_lion/pages/gift/gift.dart';
import 'package:new_lion/pages/home/home.dart';
import 'package:new_lion/pages/home/widgets/in_app_dialog.dart';
import 'package:new_lion/pages/layout/widgets/app_drawer.dart';
import 'package:new_lion/pages/layout/widgets/custom_bottom_navbar.dart';
import 'package:new_lion/pages/threed_calendar/threed_calendar.dart';
import 'package:new_lion/pages/twod_calendar/twod_calendar.dart';
import 'package:new_lion/provider/block_provider.dart';
import 'package:new_lion/provider/live_provider.dart';
import 'package:new_lion/provider/public_chat_provider.dart';
import 'package:new_lion/utils/app_colors.dart';
import 'package:new_lion/utils/app_notification/fcm.dart';
import 'package:new_lion/utils/const.dart';
import 'package:new_lion/utils/global.dart';
import 'package:new_lion/utils/images.dart';
import 'package:new_lion/utils/ws_client.dart';
import 'package:new_lion/widgets/custom_appbar.dart';
import 'package:new_lion/widgets/easy_overlay/easy_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  late LiveProvider _provider;
  late PublicChatProvider _publicChatProvider;
  late BlockProvider _blockProvider;
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    Home(),
    TwodCalendar(),
    ThreedCalendar(),
    Gift(),
  ];

  final List<NavItem> _navItems = [
    NavItem(icon: Imgs.live, activeIcon: Imgs.live),
    NavItem(icon: Imgs.twod, activeIcon: Imgs.twod),
    NavItem(icon: Imgs.threed, activeIcon: Imgs.threed),
    NavItem(icon: Imgs.gift, activeIcon: Imgs.gift),
  ];

  @override
  void initState() {
    _provider = Provider.of<LiveProvider>(context, listen: false);
    _blockProvider = Provider.of<BlockProvider>(context, listen: false);
    _publicChatProvider = Provider.of<PublicChatProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyOverlay.init();
      _provider.update(Global.config.latestData!);
      if (Global.config.user?.blockList != null) {
        _blockProvider.assign(Global.config.user!.blockList!);
      }
      _initWebSocket();
      _showInAppMessage();
      FCM.config();
    });
    super.initState();
  }

  _showInAppMessage() async {
    AppMessage? msg = Global.config.appMessage;
    if (msg?.showStatus != true) return;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var isUpToDate = msg!.version == packageInfo.version;
    if (msg.isUpdate == true && isUpToDate) return;
    EasyOverlay.show(child: InAppDialog());
  }

  void _initWebSocket() {
    final uri = Uri(
      scheme: 'wss',
      host: Uri.parse(Const.workerURL).host,
      path: '/ws',
      // queryParameters: {'email': 'example@gmail.com'},
    );

    Global.webSocket = AutoReconnectWebSocket(
      url: uri.toString(),
      reconnectInterval: Duration(seconds: 3),
      maxRetries: null, // unlimited retries
      onStatusChange: (status) {
        if (!mounted) return;
        Global.liveSocket.value = status;
      },
    );

    // Messages များကို listen လုပ်ပါ
    Global.webSocket.stream.listen((message) {
      var decodedMessage = json.decode(message);
      var action = decodedMessage["action"];
      if (action == "stock_update") {
        _provider.update(StockModel.fromJson(decodedMessage['data']));
      } else if (action == "chat_message") {
        var msg = ChatMessageModel.fromJson(decodedMessage['data']);
        //Check blocked user
        List<UserModel> list = Global.config.user?.blockList ?? [];
        if (list.any((e) => e.id == msg.sender!.id)) return;
        _publicChatProvider.addNew(msg);
      } else if (action == "user_update") {
        var user = UserModel.fromJson(decodedMessage['data']);
        if (Global.user?.id == user.id) {
          Global.isBanned.value = user.isBanned ?? false;
        }
      }
    });

    // Connect လုပ်ပါ
    Global.webSocket.connect();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    if (index == 1 || index == 2) {
      AdHelper.showInterstitialAd(
        onComplete: () => setState(() => _selectedIndex = index),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      drawer: AppDrawer(),
      appBar: CustomAppbar(title: "Shwe 2D"),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedIndex,
        items: _navItems,
        onTap: _onNavTap,
      ),
    );
  }
}
