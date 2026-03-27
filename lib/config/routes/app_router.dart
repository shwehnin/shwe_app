import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/pages/layout/layout.dart';
import 'package:new_lion/pages/lucky_scratcher/lucky_scratcher_detail.dart';
import 'package:new_lion/pages/settings/more.dart';
import 'package:new_lion/pages/settings/setting.dart';
import 'route_locations.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/gift_type_model.dart';
import '../../data/models/lotto_thai_model.dart';
import '../../data/models/post_model.dart';
import '../../pages/block_list/block_list.dart';
import '../../pages/chat/private_chat.dart';
import '../../pages/chat/public_chat.dart';
import '../../pages/chat/user_detail.dart';
import '../../pages/set_holidays/set_holidays.dart';
import '../../pages/analysis/analysis.dart';
import '../../pages/auth/login.dart';
import '../../pages/chat/recent_chat_list.dart';
import '../../pages/dreams/dream.dart';
import '../../pages/gift/gift.dart';
import '../../pages/gift/gift_detail.dart';
import '../../pages/home/home.dart';
import '../../pages/language/language.dart';
import '../../pages/lotto_thai/lotto_thai.dart';
import '../../pages/lotto_thai/widgets/loto_search.dart';
import '../../pages/notifications/notifications.dart';
import '../../pages/post/post.dart';
import '../../pages/post/post_detail.dart';
import '../../pages/privacy/privacy_policy.dart';
import '../../pages/profile/update_profile.dart';
import '../../pages/splash/splash.dart';
import '../../pages/threed_calendar/threed_calendar.dart';
import '../../pages/twod_calendar/twod_calendar.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';

class AppRouter {
  AppRouter._();
  static GoRouter get config {
    var router = GoRouter(
      routes: _appRoutes,
      navigatorKey: navigatorKey,
      initialLocation: RouteLocation.splash,
    );
    return router;
  }

  static final _appRoutes = [
    GoRoute(
      path: RouteLocation.splash,
      name: RouteLocation.splash,
      builder: _builder(page: const Splash()),
    ),
    GoRoute(
      path: RouteLocation.home,
      name: RouteLocation.home,
      builder: _builder(page: const Home()),
    ),

    GoRoute(
      path: RouteLocation.login,
      name: RouteLocation.login,
      builder: _builder(page: const Login()),
    ),

    GoRoute(
      path: RouteLocation.setting,
      name: RouteLocation.setting,
      builder: _builder(page: const Setting()),
    ),

      GoRoute(
      path: RouteLocation.other,
      name: RouteLocation.other,
      builder: _builder(page: const More()),
    ),

    GoRoute(
      path: RouteLocation.language,
      name: RouteLocation.language,
      builder: _builder(page: const Language()),
    ),

    GoRoute(
      path: RouteLocation.privacyPolicy,
      name: RouteLocation.privacyPolicy,
      builder: _builder(page: const PrivacyPolicy()),
    ),

    GoRoute(
      path: RouteLocation.setHolidays,
      name: RouteLocation.setHolidays,
      builder: _builder(page: const SetHolidays()),
    ),

    GoRoute(
      path: RouteLocation.noti,
      name: RouteLocation.noti,
      builder: _builder(page: const Notifications()),
    ),

    GoRoute(
      path: RouteLocation.dream,
      name: RouteLocation.dream,
      builder: _builder(page: const DreamsPage()),
    ),

    GoRoute(
      path: RouteLocation.analysis,
      name: RouteLocation.analysis,
      builder: _builder(page: const Analysis()),
    ),

    GoRoute(
      path: RouteLocation.post,
      name: RouteLocation.post,
      builder: _builder(page: const Post()),
    ),
    GoRoute(
      path: RouteLocation.layout,
      name: RouteLocation.layout,
      builder: _builder(page: const Layout()),
    ),

    GoRoute(
      path: RouteLocation.scratcherDetail,
      name: RouteLocation.scratcherDetail,
      builder: (_, state) {
        int id = state.extra as int;
        return LuckyScratcherDetail(id: id);
      },
    ),

    GoRoute(
      path: RouteLocation.postDetail,
      name: RouteLocation.postDetail,
      builder: (_, state) {
        PostModel post = state.extra as PostModel;
        return PostDetail(post: post);
      },
    ),

    GoRoute(
      path: RouteLocation.lucky,
      name: RouteLocation.lucky,
      builder: _builder(page: const Gift()),
    ),

    GoRoute(
      path: RouteLocation.userDetail,
      name: RouteLocation.userDetail,
      builder: (_, state) {
        ChatMessageModel data = state.extra as ChatMessageModel;
        return UserDetail(message: data);
      },
    ),

    GoRoute(
      path: RouteLocation.lottoThai,
      name: RouteLocation.lottoThai,
      builder: _builder(page: const LottoThai()),
    ),

    GoRoute(
      path: RouteLocation.lottoSearch,
      name: RouteLocation.lottoSearch,
      builder: (_, state) {
        LottoThaiModel data = state.extra as LottoThaiModel;
        return LotoSearch(lottoThai: data);
      },
    ),

    GoRoute(
      path: RouteLocation.recentChat,
      name: RouteLocation.recentChat,
      builder: _builder(page: const RecentChatList()),
    ),

    GoRoute(
      path: RouteLocation.privateChat,
      name: RouteLocation.privateChat,
      builder: (_, state) {
        ChatRoomModel data = state.extra as ChatRoomModel;
        return PrivateChat(chatRoom: data);
      },
    ),

    GoRoute(
      path: RouteLocation.blockList,
      name: RouteLocation.blockList,
      builder: _builder(page: const BlockList()),
    ),

    GoRoute(
      path: RouteLocation.publicChat,
      name: RouteLocation.publicChat,
      builder: _builder(page: const PublicChat()),
    ),

    GoRoute(
      path: RouteLocation.updateProfile,
      name: RouteLocation.updateProfile,
      builder: _builder(page: const UpdateProfile()),
    ),

    GoRoute(
      path: RouteLocation.twodCalendar,
      name: RouteLocation.twodCalendar,
      builder: _builder(page: const TwodCalendar()),
    ),

    GoRoute(
      path: RouteLocation.twod,
      name: RouteLocation.twod,
      builder: _builder(page: const TwodCalendar()),
    ),

    GoRoute(
      path: RouteLocation.threed,
      name: RouteLocation.threed,
      builder: _builder(page: const ThreedCalendar()),
    ),

    GoRoute(
      path: RouteLocation.luckyDetail,
      name: RouteLocation.luckyDetail,
      builder: (_, state) {
        GiftTypeModel giftTypeModel = state.extra as GiftTypeModel;
        return GiftDetail(gift: giftTypeModel);
      },
    ),
  ];

  static Widget Function(BuildContext, GoRouterState)? _builder({
    required Widget page,
  }) {
    return (context, state) => page;
  }
}
