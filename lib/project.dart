import 'package:flutter/material.dart';
import 'package:myflutterapp/r.Radio.dart';
import 'package:myflutterapp/rMicroondas.dart';
import 'package:myflutterapp/rSatelite.dart';

class Project extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Flutter Second',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xff0d2e44),
        //primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: MyProjectPage(title: 'eRadio'),
    );
  }
}

class MyProjectPage extends StatefulWidget {
  MyProjectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyProjectPageState createState() => _MyProjectPageState();
}

class _MyProjectPageState extends State<MyProjectPage> with SingleTickerProviderStateMixin {

  TabController tabcontroller;
  @override
  void initState() {
    super.initState();
    tabcontroller = new TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
   
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
    //////////////////////////////////Actions Buttons:////////////////////////////////
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.map), tooltip: "Mapa del sistema radiado.",
                    onPressed: () {
                      var assetimage;
                      if(tabcontroller.index == 0)
                      { assetimage = 'images/radio.bmp';
                        imageAlertDialog(context, assetimage);
                      }
                      else if (tabcontroller.index == 1)
                      { assetimage = 'images/uondas.jpg';
                        imageAlertDialog(context, assetimage);
                      }
                      else if (tabcontroller.index == 2)
                      { assetimage = 'images/satelite.bmp';
                        imageAlertDialog(context, assetimage);
                      }
                      else{}  
                      debugPrint('Mapa del sistema radiado.');  
                    }
              ),
              new IconButton(icon: Icon(Icons.save), tooltip: "Guardar proyecto",
                    onPressed: () {debugPrint('Guardar');}
              ),
              new PopupMenuButton<String>(
                        tooltip: "Información",
                        onSelected: iUserChoice,
                        itemBuilder: (BuildContext context) {
                          return Constants.choices.map((String choice){
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                      //debugPrint('CÁLCULOS PARA UN SISTEMA DE RADIODIFUSIÓN  (Sistema de Radiación)');             
              ],
    //////////////////////////////////////////////////////////////////////////////////          
            bottom: new TabBar( controller: tabcontroller,
              indicatorSize: TabBarIndicatorSize.tab, indicatorWeight: 3,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                new Tab(icon: Icon(Icons.wifi)), //Radio
                new Tab(text: 'μONDAS' ), //Microóndas
                new Tab(text: 'SATÉLITE',), //Satélite
              ],
            ),
    //////////////////////////////////////////////////////////////////////////////////
          ),
          
          body: new TabBarView( controller: tabcontroller,
            children:<Widget>[
              Radiodifusion(),
              Microondas(),
              Satelite(),
            ] 
          ),
         
        );
  }

  Future<bool> imageAlertDialog(BuildContext context, assetimage) {
    return showDialog(context: context, builder: (context){
      return Dialog( 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container( width: 700.0, 
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),   
            child: SingleChildScrollView(child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(height: 80.0,),
                  Container(height: 80.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                      color: Color(0xff0d2e44), ),
                   // child: Center(child: Text('Resultados'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  Positioned(top: 35, left: 25.0, 
                    child: Container(height: 90, width: 90, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(45),
                        border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 4.0), 
                        image: DecorationImage(image: AssetImage(assetimage), fit: BoxFit.cover),)
                    ),
                  ),
                ],),
                Padding(padding: const EdgeInsets.only(top: 1.0)),
                //Imagen: 
                Container(child: Image(image: AssetImage(assetimage))),

                //SizedBox(height: 5.0,),
                FlatButton(child: Center(child: Text('Aceptar'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold,),), ), 
                  onPressed: (){ Navigator.of(context).pop();},
                ),  

              ], 
          ), ),
        ),
      );
    });
  }

  Future<bool> iAcercaDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return Dialog( 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container( height:455.0, width: 400.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),   
            child: SingleChildScrollView(child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(height: 125.0,),
                  Container(height: 80.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                      color: Color(0xff0d2e44), ),
                   // child: Center(child: Text('Resultados'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  Positioned(top: 35, left: 25.0, 
                    child: Container(height: 90, width: 90, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(45),
                        border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 3.0), 
                        image: DecorationImage(image: AssetImage('images/eicono.png'), fit: BoxFit.cover),)
                    ),
                  ),
                ],),

                //INICIO RESULTADOS//
                new Text(
                  'eRadio', 
                    style: TextStyle(color: Color(0xff0d2e44), fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.bold), // Theme.of(context).textTheme.display1,
                  ),

                Padding(padding: const EdgeInsets.only(top: 15.0)),

                new Text(
                  'eRadio\nVersión 1.0\nGrupo EvaApps.\n© 2018 Eva Corporation.\nTodos los derechos reservados.', 
                    style: TextStyle(color: Color(0xff0d2e44), fontSize: 14, letterSpacing: 0.5, fontWeight: FontWeight.normal), // Theme.of(context).textTheme.display1,
                  ),

                Padding(padding: const EdgeInsets.only(top: 15.0)),

                new Text(
                  'Diseño y desarrollo:\nCristian A. Calderón Nieves\n\nAgradecimientos especiales:\nAnca Corporation\n© 2018 Anca Corporation.\nTodos los derechos reservados.', 
                    style: TextStyle(color: Color(0xff0d2e44), fontSize: 14, letterSpacing: 0.5, fontWeight: FontWeight.normal), // Theme.of(context).textTheme.display1,
                  ),

                Padding(padding: const EdgeInsets.only(top: 30)),   

                //Linea:
                Row(children: <Widget>[  
                  SizedBox(width: 20.0), Flexible( child: new Container(height: 1, color: Colors.blue) ), SizedBox(width: 20.0),
                ]),
                
                SizedBox(height: 5.0,),

                FlatButton(
                  child: Center(child: Text('Aceptar'.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),),), 
                  onPressed: (){ Navigator.of(context).pop();},
                ),
  
                SizedBox(height: 5.0,),

              ], 
            ), ),
          ),
        );
      }
    );
  }

  void iUserChoice(String choice){
    if (choice == Constants.Acerca)
    {
        iAcercaDialog(context);
    }
    else{}

  }
}
//clase para utilizar con el PopupMenu
class Constants{

  static const String Ayuda = "Ayuda";
  static const String Acerca = "Acerca";

  static const List<String> choices = <String>[
    Ayuda,
    Acerca,

  ];

}