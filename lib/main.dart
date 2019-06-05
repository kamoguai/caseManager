import 'dart:async';

import 'package:case_manager/common/event/HttpErrorEvent.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/net/Code.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/page/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ///創建Store，引用 SysState中的appReducer 實現 Reducer 方法
  ///initialState 初始化 State
  final store = Store<SysState>(
    appReducer,
    ///初始化數據
    initialState: SysState(
      userInfo: UserInfo.empty(),
      themeData: ThemeData(primaryColor: Colors.blue),
    )
  );

  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ///設定手機畫面固定直立上方
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return StoreProvider(
      store: store,
      child: StoreBuilder<SysState>(builder: (context, store) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
  
            primarySwatch: Colors.blue,
          ),
          routes: {
            ///設定route path, app一開始先進入welcome頁
            WelcomePage.sName: (context) {
              return WelcomePage();
            }
          },
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.child}) : super(key: key);

  final String title;
  final Widget child;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {

    return StoreBuilder<SysState>(
      builder: (context, store) {
        return Localizations.override(
          context: context,
          child: widget.child,
        );
      }
    );
  }
  @override
  void initState() {
    super.initState();
    stream = Code.eventBus.on<HttpErrorEvent>().listen((event){
      errorHandleFunction(event.code, event.message);
    });
  }
  @override
  void dispose() {
    super.dispose();
    if(stream != null) {
      stream.cancel();
      stream = null;
    }
  }
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(msg: '網路錯誤');
        break;
      case 401:
        Fluttertoast.showToast(msg: '[401錯誤可能: 未授權 \\ 授權登入失敗 \\ 登入過期]');
        break;
      case 403:
        Fluttertoast.showToast(msg: '403權限錯誤');
        break;
      case 404:
        Fluttertoast.showToast(msg: '404錯誤');
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        Fluttertoast.showToast(msg: '請求超時');
        break;
      default:
        Fluttertoast.showToast(msg: '請求異常' + " " + message);
        break;
    }
  }
}