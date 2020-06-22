import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../common/http.dart';

class BannerSwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Myexample();
  }
}

class Myexample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyexampleState();
  }
}

class _MyexampleState extends State<Myexample> { 
  List bannerList;
  httpData()async{
    var response =  await GlgwangApis().getBanner();
    setState(() {
      bannerList = response['data'];
    });
  }
  @override
  void initState(){
    super.initState();
    httpData();
  }
 
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),
      child: bannerList == null 
      ? Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 20.0,height: 20.0),
            child: CircularProgressIndicator(),
          ),
        )
      : new Swiper(
        outer: false,
        itemCount: 4,
        autoplay: true,
        itemBuilder: (c, i) {
          return new Image.network(bannerList[i]['imageUrl'], fit: BoxFit.fill);
        },
        pagination: SwiperCustomPagination(
          builder: (context,config){
            return CustomPagination(
              itemCount:config.itemCount,
              activeIndex:config.activeIndex
            );
          }
        ),
      ),
    );
  }
}

class CustomPagination extends StatelessWidget {
  final int itemCount;
  final int activeIndex;
  final Color activeColor;
  final Color color;
  final double activeWidth;
  final double activeHeight;
  final double width;
  final double height;
  final double space;

  CustomPagination({
    Key key,
    this.itemCount,
    this.activeIndex,
    this.activeColor: Colors.white,
    this.color: Colors.white38,
    this.width: 12.0,
    this.activeWidth:12.0,
    this.height:2.0,
    this.activeHeight:2.0,
    this.space:5.0
  });
  @override
  Widget build(BuildContext context){
    List<Widget> list = [];
    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(
        _Paginatipon(
          color: active ? activeColor : color,
          width:active ? activeWidth :width,
          height: active ? activeHeight : height,
        )
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: double.infinity,height: 150.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: list,
      )
    );
  }
}
class _Paginatipon extends StatelessWidget{
  final color;
  final width;
  final height;
  _Paginatipon({
    Key key,
    this.color,
    this.width,
    this.height
  }); 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0,bottom: 5.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: width,height: height),
        child: DecoratedBox(
          // decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .5)),
          decoration: BoxDecoration(color: color),
        ),
      ),
    );
  }
}