import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provide.value<DetailsInfoProvidel>(context).goodsInfo.data.goodInfo.goodsDetail;
    return Provide<DetailsInfoProvidel>(
      builder: (context,child,val){
        var isLeft = Provide.value<DetailsInfoProvidel>(context).isLeft;
        if(isLeft){
          return  Container(
            child: Html(
              data: goodsDetails,
            ),
          );
        }else {
          return Container(
            width: ScreenUtil().setWidth(730),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text('暂无数据'),
          );
        }
      }
    );
  }
}
