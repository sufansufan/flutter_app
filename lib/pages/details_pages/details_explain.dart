import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsExplain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.all(10.0),
      child: Text(
        '说明：> 急速送达 > 正品保正',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }
}
