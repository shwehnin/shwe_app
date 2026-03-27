import 'package:flutter/material.dart';
import '../post/post_image.dart';
import '../../widgets/loading_view.dart';
import '../../data/api/gift_api.dart';
import '../../data/models/gift_type_model.dart';

class GiftDetail extends StatefulWidget {
  final GiftTypeModel gift;
  const GiftDetail({super.key, required this.gift});

  @override
  State<GiftDetail> createState() => _GiftDetailState();
}

class _GiftDetailState extends State<GiftDetail> {
  bool isLoading = true;
  List<String> images = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  _getData() async {
    var response = await GiftApi.get(giftType: widget.gift.id!);
    if (response.status) {
      images = List<String>.from(response.data);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gift.name ?? "")),
      body: isLoading ? LoadingView() : buildBody(),
    );
  }

  Widget buildBody() {
    if (images.isEmpty) {
      return Center(child: Text("Empty Card!"));
    } else if (images.length == 1) {
      return Center(child: PostImage(url: images));
    } else {
      return GridView.builder(
        itemCount: images.length,
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: .6,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, idx) {
          return ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10),
            child: PostImage(
              url: images,
              selectedIndx: idx,
              margin: EdgeInsets.all(0),
            ),
          );
        },
      );
    }
  }
}
