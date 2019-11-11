import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList()
        ],
      )
    );
  }

  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200.0),
            height: ScreenUtil().setHeight(200.0),
            margin: EdgeInsets.only(top:30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage('http://b-ssl.duitang.com/uploads/item/201807/31/20180731152127_fctgj.jpg'),
                fit: BoxFit.cover
              )
            ),
            // child: Image.network(
            //   'http://b-ssl.duitang.com/uploads/item/201807/31/20180731152127_fctgj.jpg',
            //   fit: BoxFit.cover,
            //   scale: 200.0,
            // ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '苏凡',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color:  Colors.black54
              ),
            ),
          )
        ],
      ),
    );
  }

  // 我的 订单

  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.white)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(720),
      height: ScreenUtil().setHeight(200),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(180),
            child: Column(
              children: <Widget>[
                Icon(Icons.party_mode, size: 30),
                Text('待付款')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(180),
            child: Column(
              children: <Widget>[
                Icon(Icons.query_builder, size: 30),
                Text('待发货')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(180),
            child: Column(
              children: <Widget>[
                Icon(Icons.directions_car, size: 30),
                Text('待收货')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(180),
            child: Column(
              children: <Widget>[
                Icon(Icons.content_paste, size: 30),
                Text('待评价')
              ],
            ),
          ),
        ],
      )
    );
  }

  // 通用ListTile
  Widget _myListTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text('${title}'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券'),
          _myListTile('以领取优惠券'),
          _myListTile('地址管理'),
          _myListTile('客服电话'),
          _myListTile('联系我们'),
        ],
      ),
    );
  }
}
