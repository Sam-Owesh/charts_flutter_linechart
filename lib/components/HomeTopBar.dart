import 'package:flutter/material.dart';
class HomeTopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            print('123');
          },
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Text(
                  '北京市',
                  style: TextStyle(
                    color: Color.fromRGBO(51,51,51,1)
                  ),
                ),
              ),
              Image.asset(
                'images/home/home_xiala.png',
                width: 6.0,
                height: 4.0,
              )
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: ()=>{

            },
            child: Container(
              height: 48.0,
              margin: EdgeInsets.only(left: 9.0,right: 9.0),
              padding: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/home/shouye_sousuokuang.png'),
                  fit: BoxFit.fill
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/home/home_sousuo.png',
                    width: 15.0,
                    height: 15.0,                    
                  ),
                  Container(
                    padding: EdgeInsets.only(left:5.0),
                    child: Text(
                      '输入品名/店铺名称',
                      style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontSize: 14.0
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            child: Image.asset(
              'images/home/home_saoma.png',
              width: 22.0,
              height: 22.0,
            ),
          ),
        )
      ],
    );
  }
}