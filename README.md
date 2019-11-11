# flutter_app

- **Dio2.0**:`Dio`是一个强大的Dart Http请求库，支持Restful API、FormData、拦截器、请求取消等操作。视频中将全面学习和使用Dio的操作。
- **Swiper**：swiper滑动插件的使用，使用Swiper插件图片的切换效果。
- **路由Fluro**：Flutter的路由机制很繁琐，如果是小型应用还勉强，但是真实开发我们都会使用企业级的路由机制，让路由清晰可用。视频中也会使用`Fluro`进行路由配置.`Fluro`也是目前最好的企业级Flutter路由。
- **屏幕适配**：手机屏幕大小不同，布局难免有所不同，在视频中将重点讲述Flutter的开发适配，一次开发适配所有屏幕，学完后可以都各种屏幕做到完美适配。
- **上拉加载**：如果稍微熟悉Flutter一点的小伙伴一定知道Flutter没有提供上拉加载这种插件，自己开发时非常麻烦的。在课程中我将带着大家制作上拉加载效果。
- **本地存储**：本地存储是一个App的必要功能，在项目中也大量用到了本地存储功能。
- **复杂页面的布局**：会讲到如何布局复杂页面，如果解决多层嵌套地狱，如何写出优雅的代码。
- **其他知识点**：还会设计到很多其他知识点，基本的Widget操作就超过50个，是目前市面教程中最多的实战课程。
- **随时增加的知识技巧**

## Dio

**配置 pubspec.yaml**

```
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^0.1.2
  dio: ^2.1.13
```

**注意：**dio的版本更新对低版本不兼容

**简单的http请求**

```
void getHttp() async {
    try{
      Response response;
      response = await Dio().get("https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=大胸美女");
      return print(response);
    }catch(e){
      return print(e);
    }
  }
```

### get请求和动态组件协作

```
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '欢迎你来到来到美好人间';
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('美好人间')),
         body: Container(
           child: Column(
             children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '美女类型',
                    helperText: '请输入你喜欢的类型'
                  ),
                  autofocus: false,
                ),
                RaisedButton(
                  onPressed:  _choiceAction,
                  child: Text('选择完毕'),
                ),
                Text(
                 showText,
                 overflow: TextOverflow.ellipsis,
                 maxLines: 1,
                )
             ],
           ),
         ),
       )
    );
  }
  void _choiceAction() {
    print('开始选择你喜欢的类型。。。。。。。。。。。。。。。');
    if(typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('美女类型不能为空'))
      );
    }else {
      getHttp(typeController.text.toString()).then((val){
        setState(() {
          showText = val['data']['name'].toString();
        });
      });
    }
  }
  Future getHttp(String typeText) async {
    try {
      Response response;
      var data = {
        'name': typeText
      };
      response = await Dio().get("https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian", queryParameters: data);
      return response.data;
    }catch(e) {
      return print(e);
    }
  }
}

```

**掌握的知识点 **

1. 对Flutter动态组件的深入了解
2. Future对象的使用
3. 改变状态和界面的setState的方法应用
4. TextField Widget的基本使用

### post请求

使用psot请求，只需要把原来的get换成post就ok

### EasyMock动态参数的实现

EasyMock在工作中我使用的也是比较多，因为要和后台同步开发，后台编写慢的时候，就需要我们先自己设置（应该说是模拟）需要的数据。那固定死的mock数据作起来很简单，我就不在这里讲了，动态数据如何处理，我在这里给出代码，视频中会有所讲解。

```
{
  success: true,
  data: {
    default: "jspang",
    _req: function({
      _req
    }) {
      return _req
    },
    name: function({
      _req,
      Mock
    }) {
      if (_req.query.name) {
        return _req.query.name + '走进了房间，来为你亲情服务';
      } else {
        return '随便来个妹子，服务就好';
      }
    }
  }
}
```

### dio基础-伪造请求头获取数据

```
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/httpHeaders.dart';
class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showText = '还没有请求数据';
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('请求远程数据'),),
         body: SingleChildScrollView(
           child: Column(
             children: <Widget>[
               RaisedButton(
                 onPressed: _jike,
                 child: Text('请求数据'),
               ),
               Text(showText)
             ],
           ),
         ),
       ),
    );
  }
  void _jike() {
    print('开始向极客时间请求数据');
    getHttp().then((val) {
      setState(() {
       showText = val['data'].toString();
      });
    });
  }

  Future getHttp() async {
    try {
      Response response;
      Dio dio = new Dio();
      dio.options.headers = HttpHeaders;
      response = await dio.get("https://time.geekbang.org/serv/v1/column/newAll");
      print(response);
      return response.data;
    }catch(e) {
      print(e);
    }
  }
}

```

**httpHeaders.dart文件**

```
const HttpHeaders = {
  'Accept': 'application/json, text/plain, */*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
  'Connection': 'keep-alive',
  'Content-Type': 'application/json',
  'Cookie': '_ga=GA1.2.1757144879.1557237555; _gid=GA1.2.794714174.1564904040; _gat=1; Hm_lvt_022f847c4e3acd44d4a2481d9187f1e6=1564904040; SERVERID=3431a294a18c59fc8f5805662e2bd51e|1564904083|1564904038; Hm_lpvt_022f847c4e3acd44d4a2481d9187f1e6=1564904085',
  'Host': 'time.geekbang.org',
  'Origin': 'https://time.geekbang.org',
  'Referer': 'https://time.geekbang.org/',
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36',
};
```

## flutter中状态管理

### 状态管理方案
**Scoped model**
**Redux**
阿里的咸鱼的团队在维护
**Bloc**
不是官方提供的
**Provide**
官方提供的
**StateFulWidget**
耦合行高，维护成本高

#### Provide状态管理流程
1. 根据json建立模型，=> model
2. 建立provide
~~~
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
class DetailsPage extends StatelessWidget {
  final String goodsId;
  // const DetailsPage({Key key}) : super(key: key);
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Container(
      child: Center(
        child: Text('商品ID:${ goodsId }'),
      ),
    );
  }
  void _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvidel>(context).getGoodsInfo(goodsId);
    print('加载完成。。。');
  }
}
~~~
1. 注入provide
~~~
void main () {
  // 混入状态管理
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvidel = DetailsInfoProvidel();
  var providers = Providers();
  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
  ..provide(Provider<DetailsInfoProvidel>.value(detailsInfoProvidel));
  runApp(ProviderNode(child:MyApp(), providers:providers));
}
~~~

## fluro建立规则
1. 引入fluro包
2. 建立子类的handler =>router_handler
3. 建立全局的handler, 并且配置路径 => routes
4. 进行路由静态化 => application
5. 全局注入route
~~~
final router = Router();
// 注入路由
Routes.configureRoutes(router);
Application.router = router;
~~~
1. 使用路由
~~~
Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
~~~

## flutter_html包的使用
flutter_webview_plugin(不好用)


## 数据持久化
- 也可以用sqflite
- shared_preferences
- file 是用流的 形式太慢了

## Flutter升级问题

1.升级命令 （请使用科学上网）

```
flutter upgrade
```

2.下载sdk进行替代sdk就ok

## 开发中避免的坑

**容器越界**

解决方法在在body中添加SingChildScrollView()包裹起来