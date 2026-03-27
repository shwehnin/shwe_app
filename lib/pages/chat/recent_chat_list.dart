import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../admob/ad_helper.dart';
import '../../config/routes/route_locations.dart';
import '../../data/api/chat_api_service.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/user_model.dart';
import '../../provider/chat_room_provider.dart';
import '../../utils/global.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/network_imge_view.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class RecentChatList extends StatefulWidget {
  const RecentChatList({super.key});

  @override
  State<RecentChatList> createState() => _RecentChatListState();
}

class _RecentChatListState extends State<RecentChatList> {
  late ChatRoomProvider chatRoomProvider;
  bool isLoading = true;

  @override
  void initState() {
    chatRoomProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  _getData() async {
    var response = await ChatApiService.getChatList();
    if (response.status) {
      chatRoomProvider.assign(response.data);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat List')),
      body: isLoading
          ? LoadingView()
          : Consumer<ChatRoomProvider>(
              builder: (ctx, pd, _) {
                return pd.chatRooms.isEmpty
                    ? Center(child: Text("Empty Chat List!!"))
                    : ListView.builder(
                        itemCount: pd.chatRooms.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoom = pd.chatRooms[index];
                          UserModel otherUser = chatRoom.members!.firstWhere(
                            (member) => member.id != Global.user!.id,
                          );

                          return Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    AdHelper.showInterstitialAd(
                                      onComplete: () {
                                        context.pushNamed(
                                          RouteLocation.privateChat,
                                          extra: chatRoom,
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        NetworkImageView(
                                          url: otherUser.cover ?? '',
                                          width: 50,
                                          height: 50,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    otherUser.name ??
                                                        'Unknown User',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatTime(
                                                      chatRoom
                                                          .lastMessage
                                                          ?.createdAt,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textMuted,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      chatRoom
                                                              .lastMessage
                                                              ?.content ??
                                                          "No messages",
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF8E8E93,
                                                        ),
                                                        fontSize: 15,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.chevron_right,
                                                    color: AppColors.textMuted,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 78),
                                height: 0.5,
                                color: AppColors.chatBubble,
                              ),
                            ],
                          );
                        },
                      );
              },
            ),
    );
  }

  // Helper function for time formatting
  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    DateTime? timestamp = DateTime.parse(createdAt);

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
