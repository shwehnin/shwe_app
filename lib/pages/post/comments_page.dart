import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes/route_locations.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/images.dart';
import '../../widgets/banned_container.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/api/post_api.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/network_imge_view.dart';

class CommentsPage extends StatefulWidget {
  final PostModel post;

  const CommentsPage({super.key, required this.post});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<CommentModel> comments = [];
  bool _loadMoreRunning = false;
  bool _isInitLoading = true;
  bool hasNextPage = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComments();
    });
  }

  void _loadComments() async {
    page = 1;
    hasNextPage = true;
    var resp = await PostApi.getComments(post: widget.post.id!, page: 1);
    if (resp.status) {
      List<CommentModel> cmts = resp.data;
      if (cmts.length < 20) {
        hasNextPage = false;
      }
      comments = cmts;
    }
    _isInitLoading = false;
    setState(() {});
  }

  Future<void> _loadMoreComments() async {
    if (_loadMoreRunning && hasNextPage) return;

    setState(() => _loadMoreRunning = true);
    page++;
    var resp = await PostApi.getComments(post: widget.post.id!, page: page);
    _loadMoreRunning = false;
    if (resp.status) {
      List<CommentModel> cmts = resp.data;
      if (cmts.length < 20) {
        hasNextPage = false;
      }
      setState(() => comments.addAll(cmts));
    }
  }

  void _postComment() async {
    var cmt = _commentController.text.trim();
    if (cmt.isEmpty) return;

    var resp = await PostApi.addComments(post: widget.post.id!, content: cmt);

    if (resp.status) {
      setState(() {
        comments.insert(0, resp.data);
      });
    }

    _commentController.clear();
    try {
      // Scroll to top to show new comment
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      ///can't scroll right now
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SafeArea(
        child: Column(
          children: [
            // Comments section
            Expanded(
              child: _isInitLoading
                  ? LoadingView()
                  : comments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Imgs.comment,
                            color: Colors.grey,
                            width: 50,
                          ),
                          SizedBox(height: 10),
                          Text("Be the first to comment!"),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        _loadComments();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount:
                            comments.length +
                            (hasNextPage && !_isInitLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= comments.length) {
                            return _buildLoadMoreIndicator();
                          }

                          return _buildCommentItem(comments[index]);
                        },
                      ),
                    ),
            ),
            // Comment input
            _buildCommentInput(false),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    var theme = AdaptiveTheme.of(context).mode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          NetworkImageView(
            width: 36,
            height: 36,
            url: comment.user?.cover,
            borderRadius: BorderRadius.circular(18),
          ),
          SizedBox(width: 4),
          // Comment content
          IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
              ),
              decoration: BoxDecoration(
                color: !theme.isDark
                    ? Colors.grey.shade300
                    : context.colors.primaryFixed,
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.user!.id == Global.config.user!.profile?.id
                            ? "You"
                            : comment.user?.name ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        timeago.format(DateTime.parse(comment.createdAt!)),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    comment.content ?? "",
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         // Handle comment like
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  //         child: Text(
                  //           'Like',
                  //           style: TextStyle(
                  //             color: Colors.grey[600],
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         // Handle reply - could pre-fill text field with @username
                  //         _commentController.text = '@${comment.userName} ';
                  //         _focusNode.requestFocus();
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  //         child: Text(
                  //           'Reply',
                  //           style: TextStyle(
                  //             color: Colors.grey[600],
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),

          //  Spacer()
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: _loadMoreRunning
            ? Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Loading more comments...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              )
            : TextButton(
                onPressed: _loadMoreComments,
                child: Text(
                  'Load more comments',
                  style: TextStyle(
                    //color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCommentInput(bool banStatus) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: context.colors.primaryFixed,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User avatar
            GestureDetector(
              onTap: () {
                context.pushNamed(RouteLocation.updateProfile);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600], size: 18),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Text input
            Expanded(
              child: banStatus
                  ? const BannedContainerCard()
                  : Container(
                      constraints: BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: TextField(
                        controller: _commentController,
                        maxLength: 180,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          counter: Offstage(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
                        // textCapitalization: TextCapitalization.sentences,
                        // textInputAction: TextInputAction.send,
                        // onSubmitted: (_) => _postComment(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
            ),
            SizedBox(width: 8),
            // Send button
            Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _postComment,
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
