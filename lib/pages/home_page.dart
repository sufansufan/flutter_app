import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';  // 上拉刷新
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';  // 使用轮播图
import 'dart:convert';  // 可以使用json
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 适配屏幕包
// import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  // 保持页面的状态要满足3个条件
  // 1.使用的是StatefulWidget
  // 2.需要混入 AutomaticKeepAliveClientMixin
  // 3.重写wantKeppAlive
  @override
  bool get wantKeepAlive => true;

  // 上啦加载
  int page = 1;
  List<Map> hotGoodsList = [];
  // 上拉加载的key
  GlobalKey<RefreshIndicatorState> _footerkey = new GlobalKey<RefreshIndicatorState>();

  String homePageContent = '正在获取数据';

  @override
  void initState(){
    // 一开始获取首页数据
    // getHomePageContent().then((val) {
    //   setState(() {
    //     homePageContent = val.toString();
    //   });
    // });
    // 上拉加载就不需要获取
    // _getHotGoods();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: FutureBuilder( // 解决异步请求渲染组件，不用使用setState修改状态
        future: request('homePageContent', formData:formData),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast(); // 轮播列表
            List<Map> navigatorList = (data['data']['category'] as List).cast(); // 类别表
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];  // 广告数据
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast(); // s商品推荐
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS']; // 楼层标题图片
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS']; // 楼层标题图片
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS']; // 楼层标题图片
            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            List<Map> floor3 = (data['data']['floor3'] as List).cast();
            // 上拉刷新的必须使用ListView不能使用 SingleChildScrollView
            return EasyRefresh(
              footer: ClassicalFooter(
                key: _footerkey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                showInfo: true,
                noMoreText: '',
                infoText: '加载中',
                infoColor: Colors.pink,
                loadReadyText: '上拉加载中...'
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swpierDateList:swiper),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  FloorTitle(picture_address: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(picture_address: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(picture_address: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  _hotGoods()
                ],
              ),
              onLoad:()async {
                print('开始加载更多');
                var formData = {'page': page};
                await request('homePageBelowConten', formData: formData).then((val) {
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page ++;
                  });
                });
              }
            );


          }else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      )
    );
  }

  // 获取火爆专区数据  上拉加载的时候就不需要获取
  // void _getHotGoods() {
  //   var formData = {'page': page};
  //   request('homePageBelowConten', formData: formData).then((val) {
  //     var data = json.decode(val.toString());
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(newGoodsList);
  //       page ++;
  //     });
  //   });
  // }
  // 获取火爆专区头部
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
    padding: EdgeInsets.all(5.0),
  );

  // 获取火爆专区页面
  Widget _wrapList() {
    // 流式布局不能长度不能为 0
    if(hotGoodsList.length !=0) {
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(370),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(350)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else {
      return Text('');
    }
  }
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}

// 首页轮播控件
class SwiperDiy extends StatelessWidget {
  final List swpierDateList;
  SwiperDiy({Key key, this.swpierDateList}):super(key: key);

  @override
  Widget build(BuildContext context) {
    // 设备像素密度-高度-宽度
    // print('设备像素密度${ScreenUtil.pixelRatio}');
    // print('设备的高${ScreenUtil.screenHeight}');
    // print('设备的宽${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swpierDateList[index]['image']}", fit: BoxFit.fill,);
        },
        itemCount: swpierDateList.length,
        pagination: SwiperPagination(), //是否有导航点
        autoplay: true, //是否自动播放
      ),
    );
  }
}

//  九宫格跳转
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);
  Widget _gridViewItemUI(BuildContext context,item) {
    return  InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList()  // 这里需要转成list 这个是个坑
      ),
    );
  }
}

//  广告条制作
class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 拨打电话（店长电话）
class LeaderPhone extends StatelessWidget {
  final String leaderImage;  //  店长头像
  final String leaderPhone;  //  店长电话
  const LeaderPhone({Key key,this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        // onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  // void _launchURL() async {
  //   String url = 'tel:' + leaderPhone;
  //   print(url);
  //   if(await canLaunch(url)){
  //     await launch(url);
  //   }else {
  //     throw 'url不能进行访问,异常';
  //   }
  // }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(
          color: Colors.pink
        ),
      ),
    );
  }

  // 商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left:BorderSide(width: 0.5, color:Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(370),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return _item(index);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(440),
      margin: EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _titleWidget(),
            _recommedList()
          ],
        ),
      )
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2])
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4])
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击商品的楼层');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}