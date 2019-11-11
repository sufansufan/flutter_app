import 'package:flutter/material.dart';
import './pages/index_page.dart';

// provide
import 'package:provide/provide.dart';
import './provide/child_category.dart';
import './provide/category_godds_list.dart';
import './provide/details_info.dart';
import './provide/cart.dart';
import './provide/current_index.dart';

// fluro路由
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';



void main () {
  // 混入状态管理
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvidel = DetailsInfoProvidel();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers = Providers();
  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
  ..provide(Provider<DetailsInfoProvidel>.value(detailsInfoProvidel))
  ..provide(Provider<CartProvide>.value(cartProvide))
  ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));
  runApp(ProviderNode(child:MyApp(), providers:providers));
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // 初始化路由
    final router = Router();
    // 注入路由
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator, // 自定义的路由
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}
