import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../data/models/post_model.dart';
import '../../data/api/post_api.dart';
import 'post_card.dart';
import '../../widgets/loading_view.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _initLoading = false;

  List<PostModel> posts = [];
  final ScrollController controller = ScrollController();

  int page = 1;
  bool hasNextPage = true;
  bool _loadMoreRunning = false;

  _getData() async {
    setState(() => _initLoading = true);
    page = 1;
    hasNextPage = true;

    var resp = await PostApi.get(page: page);
    if (resp.status) {
      posts = resp.data;
    }

    setState(() => _initLoading = false);
  }

  void _scrollListener() {
    if (!hasNextPage || _loadMoreRunning) return;
    var curPx = controller.position.pixels;
    var maxPx = controller.position.maxScrollExtent;
    if (maxPx - curPx < 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (hasNextPage == true &&
        _initLoading == false &&
        _loadMoreRunning == false) {
      setState(() => _loadMoreRunning = true);
      page++;

      var resp = await PostApi.get(page: page);
      if (resp.status) {
        List<PostModel> postList = resp.data;
        if (postList.isNotEmpty) {
          posts.addAll(postList);
          _loadMoreRunning = false;
        } else {
          _loadMoreRunning = false;
          hasNextPage = false;
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
      appBar: AppBar(title: Text("2D News Feed")),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _getData();
              },
              child: Skeletonizer(
                enabled: _initLoading,
                child: ListView.builder(
                  controller: controller,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: _initLoading ? 3 : posts.length,
                  itemBuilder: (ctx, idx) {
                    if (_initLoading) {
                      //FAKE POST
                      return PostCard(
                        post: PostModel(
                          content:
                              "France, officially the French Republic, is a country primarily located in Western Europe. It has a population of over 68.6 million as of January 2025.France is known for its rich history, art, culture",
                          createdAt: "2025-08-03T22:28:21.988Z",
                          allowComment: true,
                          likeCount: 124,
                          thumbnail:
                              "https://avatars.githubusercontent.com/u/62373220?v=4",
                        ),
                      );
                    }
                    return PostCard(post: posts[idx]);
                  },
                ),
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
