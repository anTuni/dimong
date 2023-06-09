import 'package:cached_network_image/cached_network_image.dart';
import 'package:dimong/core/domain/dino.dart';
import 'package:flutter/material.dart';
import '../myimage.dart';
import '../data/data.dart';
import 'package:dimong/ui/widgets/connect_route.dart';

class MypageGrid extends StatefulWidget {
  final List<dynamic>? imageList;
  const MypageGrid({Key? key, required this.imageList}) : super(key: key);

  @override
  _MypageGridState createState() => _MypageGridState();
}

class _MypageGridState extends State<MypageGrid> {
  ConnectRoute _connectRoute = ConnectRoute();
  MyPageApiClient _myPageApiClient = MyPageApiClient();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.imageList!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final imageIndex = widget.imageList!.length - 1 - index;
        return GestureDetector(
          onTap:() async{
              print(widget.imageList![index].runtimeType);
              print("그림 정보: ${widget.imageList![index]}");
              final res = await _myPageApiClient.sendDrawing(widget.imageList![imageIndex]['drawingId']);
              print("그림 상세: ${res.runtimeType}");
              print("그림 상세 url: ${res.drawingImageUrl}");
              print("그림 상세 리스트: ${res.similarList.runtimeType}");
              await _connectRoute.toMyImage(context, res.drawingId!);
          },
          child:Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white
            ),
            child: CachedNetworkImage(
                imageUrl: widget.imageList![imageIndex]["myDrawingUrl"]!,
                fit: BoxFit.contain,
                //data!.userProfileImage!,
                //placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
        ),

            /*Text(
              '그림 $index',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),*/
        ),
        );
      },
    );
  }
}
