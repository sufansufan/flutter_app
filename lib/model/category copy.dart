// json解析和复杂数据模型数据解析
class CategoryBigModel {
  String mallCategoryId; // 类别编号
  String mallCategoryName; // 类别名称
  List<dynamic> bxMallSuDto; // 动态的 list
  Null comments;
  String image;

  // 声明构造方法
  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSuDto,
    this.image,
    this.comments
  });

  // 工程模式的构造方法 次中构造方法不用在使用new关键字了 类似java面向对象的多肽
  factory CategoryBigModel.formJson(dynamic json){
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      bxMallSuDto: json['bxMallSuDto'],
      comments: json['comments'],
      image: json['image'],
    );
  }
}

class CategoryBigListModel {
  List<CategoryBigModel> data;
  CategoryBigListModel(this.data);
  factory CategoryBigListModel.formJson(List json){
    return CategoryBigListModel (
      json.map((i) => CategoryBigModel.formJson((i))).toList()
    );
  }
}
