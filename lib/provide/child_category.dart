import 'package:flutter/material.dart';
import '../model/category.dart';


class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 子类 高亮索引
  String categoryId = '4'; // 大类的id
  String subId = ''; // 子类id

  // 商品列表上拉加载
  int page = 1; // 列表页数
  String noMoreText = '';

  getChildCategory(List<BxMallSubDto> list, String id) {
    // 切换大类的时候把page = 1；
    page = 1;
    noMoreText = '';

    childIndex = 0;
    categoryId = id;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId ='00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    // 把剩余的list的添加到childCategoryList中利用addAll 这里的list的中报错所以声明的时候要使用泛型添加<BxMallSubDto>
    childCategoryList.addAll(list);
    notifyListeners(); // 监听器去进行监听
  }
  // 改变子类的索引
  changeChildIndex(index, String subId) {
    // 切换小类的时候进行初始化
    page = 1;
    noMoreText = '';
    childIndex = index;
    subId = subId;
    notifyListeners();
  }
  // 增加page的方法
  addPage() {
    page++;
  }
  // 改变noMoreText
  changeText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
