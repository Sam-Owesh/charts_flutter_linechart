import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './routes/home_page.dart';
// import './common/global.dart';
// void main() => Global.init().then((e)=>runApp(MyApp()));
void main(){
  // debugPaintSizeEnabled = true;
  return runApp(MyApp());
}
class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        highlightColor: Color(0xffA89A60)
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/bottom/bottom_shouye.png'),
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/bottom/bottom_xianhuo.png'),
            title: Text('现货超市')
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/bottom/bottom_xiaoxi.png'),
            title: Text('消息')
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/bottom/bottom_gouwuche.png'),
            title: Text('购物车')
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/bottom/bottom_wode.png'),
            title: Text('我的')
          )
        ],
      ),
    );
  }
}
