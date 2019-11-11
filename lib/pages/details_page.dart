import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_pages/details_top_area.dart';
import './details_pages/details_explain.dart';
import './details_pages/details_tarbar.dart';
import './details_pages/details_web.dart';
import './details_pages/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  // const DetailsPage({Key key}) : super(key: key);
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    // _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailsTopArea(),
                      DetailsExplain(),
                      DetailsTarbar(),
                      DetailsWeb()
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
                )
              ],
            );

          }else {
            return Text('加载中....');
          }
        },
      ),
    );
  }
  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvidel>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
