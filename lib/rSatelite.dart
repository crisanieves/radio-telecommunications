import 'dart:math';
import 'package:flutter/material.dart';

class Satelite extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Satelite',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MySatelitePage(),
    );
  }
}

class MySatelitePage extends StatefulWidget {
  MySatelitePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MySatelitePageState createState() => _MySatelitePageState();
}

class _MySatelitePageState extends State<MySatelitePage> with AutomaticKeepAliveClientMixin<MySatelitePage> {
  //Definir propiedad para mantener datos en el Tab de la página = true:
  bool get wantKeepAlive => true;

  //Definición de constantes:
  double r  = 6378;                   // ES EL RADIO DE LA TIERRA EN KILOMETROS.
  double pi = 3.14159265359;          // Constante PI
  //Definición de variables matemáticas:
  double h, fuplink, lonsat, latgtx, latmtx, latstx, longtx, lonmtx, lonstx, fdownlink; 
  double lattx, lontx, lfs, d, qdtx, x, azimuth, elevacion, wo, qdrad;
  
  //Definición de variables controladoras de edición de texto:
  final TextEditingController hText             = new TextEditingController();
  final TextEditingController fuplinkText       = new TextEditingController();
  final TextEditingController lonsatText        = new TextEditingController();
  final TextEditingController latgtxText        = new TextEditingController();
  final TextEditingController latmtxText        = new TextEditingController();
  final TextEditingController latstxText        = new TextEditingController();
  final TextEditingController longtxText        = new TextEditingController();
  final TextEditingController lonmtxText        = new TextEditingController();
  final TextEditingController lonstxText        = new TextEditingController(); 

  //Variables para DropDownButton:
  var _oesat = ['Oeste','Este'];
  var _oesatItem = 'Oeste';

  var _latitud = ['Norte','Sur'];
  var _latitudItemSelected ='Norte';

  var _longitud = ['Oeste','Este'];
  var _longitudItemSelected = 'Oeste';


  /*Variable GlobalKey<ScaffoldState: Generate unique key for a widget:
  normalmente es necesario para el funcionamiento del Snackbar:*/
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); 
  //Variable SnackBar ("Similar to Toast"):
  SnackBar snackBar = SnackBar(content: Text(""));
  
  //TextStyle para aplicar estilos a las PopUp:
  TextStyle          textTextstyle      = TextStyle(fontSize: 14);
  BoxDecoration      boxdecoration      = BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 3.0), 
                                          borderRadius: BorderRadius.all(Radius.circular(20.0)));  
  //Gráficos ventanas PopUp:
  Container          linea              = new Container(height: 1, color: Colors.blue);                                         
  Padding            padding            = Padding(padding: const EdgeInsets.only(top: 15.0));
  double             heightRes          = 40.0;

  void _onDropDownItemSelected(String latitudValueSelected, String longitudValueSelected) {
    setState(() {
      _longitudItemSelected = longitudValueSelected;                      
      _latitudItemSelected  = latitudValueSelected;
            
        try{ 
              longtx = (double.parse(longtxText.text)).abs(); 
              longtxText.text = longtx.toString();                
        }catch(e){}   

        try{ 
              latgtx = (double.parse(latgtxText.text)).abs();
              latgtxText.text = latgtx.toString();                
        }catch(e){}   
          
    });

  }
  
  void _oeItemSatelite(String oeSatValueSelected) {
    setState(() {
      _oesatItem = oeSatValueSelected;  

      try{
          lonsat = (double.parse(lonsatText.text)).abs();
          lonsatText.text = lonsat.toString();       
      }catch (e){}             
    });

  }
  
  //Subrutina (Botón para analizar (Cálcular)):
  void _calcular() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      try{                                 
        //Si existen comas (,) o espacios los reemplaza sobre los TextField:
          fuplinkText.text = fuplinkText.text.replaceAll(",",".").replaceAll(" ","");
          lonsatText.text  = lonsatText.text.replaceAll(",",".").replaceAll(" ","");   
          latgtxText.text  = latgtxText.text.replaceAll(",",".").replaceAll(" ",""); 
          latmtxText.text  = latmtxText.text.replaceAll(",",".").replaceAll(" ","");
          latstxText.text  = latstxText.text.replaceAll(",",".").replaceAll(" ","");
          longtxText.text  = longtxText.text.replaceAll(",",".").replaceAll(" ","");
          lonmtxText.text  = lonmtxText.text.replaceAll(",",".").replaceAll(" ","");
          lonstxText.text  = lonstxText.text.replaceAll(",",".").replaceAll(" ","");
              
        //ALMACENAR VARIABLES DE ENTRADA (SISTEMA RADIADO) COMO NÚMEROS///Obtiene el texto del TextField y lo convierte en número:       
          h         = double.parse(hText.text);           fuplink = double.parse(fuplinkText.text);     
          lonsat    = double.parse(lonsatText.text);
          latgtx    = double.parse(latgtxText.text);      latmtx  = double.parse(latmtxText.text);        
          latstx    = double.parse(latstxText.text);  
          longtx    = double.parse(longtxText.text);      lonmtx  = double.parse(lonmtxText.text);
          lonstx    = double.parse(lonstxText.text);            

        // Condiciones de altura y frecuencias:
          if(h <= 0)
          {  hText.text = "35768"; h = 35768; }
          if(fuplink <= 0)
          {  fuplinkText.text = "6.095"; fuplink = 6.095; }
          /* 
          if(fdownlink <= 0){   
             fdownlinkText.text = "4.01"; fdownlink = 4.01;  
          }*/

        /* ****Condiciones de Grados(°) de latitud y longitud: ******/
          if(latgtx < 0){       
            latgtx = (latgtx*-1);
            latgtxText.text = latgtx.toString();
            _latitudItemSelected = "Sur";
          }
        
          if(longtx < 0){
            longtx = longtx.abs();
            longtxText.text = longtx.toString();
            _longitudItemSelected = "Oeste";
          }
        /* ************************************************************* */
        
        //Coordenadas de la estación de transmisión: Grados, min, seg ---> Grados.
          lattx = ((latgtx) + (latmtx / 60) + (latstx / 3600));
          lontx = ((longtx) + (lonmtx / 60) + (lonstx / 3600));

        //CUANDO ES LATITUD SUR en el sitio de TX
          if (_latitudItemSelected  == 'Sur') 
          { lattx = lattx * -1;}
          
        //CUANDO ES LONGITUD ESTE en el sitio de TX
          if(_longitudItemSelected  == "Este")
          { 
            //lontx = lontx*-1;
            //Grados Este a- Oeste:
            lontx  = (360 - lontx);
            
            //Toma sólo los grados.
            longtx = double.parse(lontx.toStringAsFixed(0));
            //Convierte grados a minutos:
            lonmtx = (lontx - longtx)*(60);           
            //Convierte de minutos a segundos:
            lonstx = (lonmtx - double.parse(lonmtx.toStringAsFixed(0)))*(60);
            //Guardo los minutos como double:
            lonmtx = double.parse(lonmtx.toStringAsFixed(0));

          }
      
        /*******************************MÁS CONDICIONES**************************************/
        //Condiciones para la Latitud = 0 de las estaciones terrenas
          if (lattx == 0)
          {lattx = 0.0000000000001;}
        
        //CONDICIONES DE UBICACIÓN DEL SATELITE (LONGITUD OESTE )
        //O (LATITUD)
        //Q (LONGITUD)
    
          lonsat = lonsat.abs(); 
          lonsatText.text = lonsat.toString();
                    
          if(_oesatItem == "Este"){
            //lonsat(Qs) — 360 = (— Ubicación del satélite) ((—) = (OESTE)): Convierte a grados oeste.
            lonsat = (360 - (lonsat));    
            lonsatText.text = lonsat.toString();
            _oesatItem  = "Oeste"; 
          } 
          else{}
        /* ********************************************************************************** */
      
        // LA DIFERENCIA DE LONGITUD ENTRE EL SATÉLITE Y LA ESTACIÓN TERRENA [º]:  puede ser negativa
          qdtx = lonsat - lontx;  //OESTE longitud (TX (estudio de TV) - Satélite)
          
        // Azimuth (0° es igual al foco (centro de la Antena)
        // apuntando hacia el norte y luego en el sentido
        // de la manecillas del reloj sube en grados 0º, 0.1º, 2º...

        //En grados sexagesimales (DEG):
        //Az = tan-1((tan(yd)/sen(Or))))+180
        qdrad = ((qdtx * pi) / (180));   // de grados a RADIANES
                    wo = ((lattx * pi) / (180));
                        azimuth = atan((tan(qdrad)) / (sin(wo)));
                            azimuth = ((azimuth * 180) / (pi)) + (180);    //(Azimuth * 180/pi) PASA de Radianes A GRADOS

        // VARIABLE ANGULO DE ELEVACIÓN [º] X
        // x = cos-1((cos(Or))*(cos(Qd)));
        var acosx, xrad;
          x = (cos(wo)) * (cos(qdrad));
            acosx = atan((-x) / (sqrt(-x * x + 1))) + (2 * (atan(1)));
              xrad = acosx;
                  x = (xrad * 180) / pi ;     // DE RADIANES A GRADOS

        // ELEVACIÓN
        // Elv = tan-1(cotX-(r/r+h)*cscX)
        // Elv = tan-1((1/tanX)-(r/r+h)*(1/senX)
        var elv;
                elv = (r / (r + h));
                  elv = (elv * (1 / sin(xrad)));
                    elevacion = (1 / (tan(xrad))) - elv;
                      elv = (atan(elevacion));
                        elevacion = elv * 180 / pi;

        // DISTANCIA REAL [Kmts], DISTANCIA (d) entre la estación y el satélite
        // en grados sexagesimales (DEG)
        // DISTANCIA REAL ENTRE LA ESTACIÓN TERRENA Y EL SATELITE [Kmts]
                d = (1 - (cos(wo) * cos(qdrad)));
                    d = (0.42 * (d));
                        d = sqrt((1 + d));
                            d = (h * (d));
        //ATENUACIÓN UPLINK en el espacio libre (Losing free Space) [dB]

        lfs = 92.44 + (20 * (log(d) / log(10))) + (20 * (log(fuplink) / log(10)));
            
                  
        //Redondear —después de todos los cálculos—:
        elevacion = double.parse(elevacion.toStringAsFixed(12));

        //llama el método (PopUp) para mostrar los detalles del resultado:
        createAlertDialog(context); stylishDialog(context);
      }      
      catch (e){ errorAlertDialog(context); }
    });    
  }

  @override
  Widget build(BuildContext context) {

  /////////////////////////Variables-Parámetros para los TextField//////////////////////////////////////////////////////////
    OutlineInputBorder enabledborder      = OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey, width: 2.0), borderRadius: BorderRadius.all(Radius.circular(30.0)));
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30.0)));
    TextStyle          textstyle          = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
    TextStyle          hintstyle          = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold); 
    TextStyle          suffixstyle        = const TextStyle(color: Colors.green);
    //Variables-Parámetos SizedBox para separar TextField del borde de pantalla: 
    SizedBox           sizedbox           = SizedBox(width: 10.0);
    //Padding para distanciar verticalmente los diferentes objetos:
    Padding            padding            = Padding(padding: const EdgeInsets.only(top: 15.0));
    //TextStyle para aplicar stilos a los textos de Text:
    TextStyle          textTextstyle      = TextStyle(fontSize: 19);
    
    BoxDecoration      bandadecoration    = BoxDecoration(border: Border.all(color: Colors.grey, width: 2.0), 
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)));  
    //Graficos
    Container          linea              = new Container(height: 2, color: Colors.blue); 
    Color              iSnackBackground   = new Color(0xff0d2e44);
    //Imagen:
    AssetImage         assetImage         = AssetImage('images/satelite.bmp');
    Image              image              = Image(image: assetImage);
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
   
        return Scaffold(  
          key: _scaffoldKey, resizeToAvoidBottomPadding: false, //resize elimina espacio sobre el teclado por doble Scaffold.
         //backgroundColor: Colors.black,
        /*  appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
    
    //////////////////////////////////Actions Buttons:////////////////////////////////
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.map), tooltip: "Mapa del sistema radiado.",
                    onPressed: () {debugPrint('Mapa del sistema radiado.');}
              ),
              new IconButton(icon: Icon(Icons.save), tooltip: "Guardar proyecto",
                    onPressed: () {debugPrint('Guardar');}
              ),
              new IconButton(icon: Icon(Icons.info), tooltip: "Ayuda",
                    onPressed: () {debugPrint('CÁLCULOS PARA UN SISTEMA DE RADIODIFUSIÓN  (Sistema de Radiación)');}
              ),
            ],
            
    //////////////////////////////////////////////////////////////////////////////////
          ),    */
          
          body: SingleChildScrollView ( //Container
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column (
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
    
              Padding(padding: const EdgeInsets.only(top: 20.0)),
                //Text(            
                Tooltip(
                  child: new Text(
                      'Azimuth'.toUpperCase(), 
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                  ), 
                    message: "Azimuth de la antena de transmisión (si está en la estación transmisora)/antena de recepción (si está en la estación receptora) en grados: movimiento alrededor de la antena (movimiento horizontal).",
                ),
    
                Text( 
                  //IMPRIMIR SOLUCIÓN:
                  '$azimuth°'.replaceAll("null", '0.0'), style: textTextstyle // Theme.of(context).textTheme.display1,
                ),

              Padding(padding: const EdgeInsets.only(top: 20.0)),

                  //Text(            
                Tooltip(
                  child: new Text(
                      'Elevación'.toUpperCase(), 
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                  ), 
                    message: "Elevación de la antena de transmisión (si está en la estación transmisora)/antena de recepción (si está en la estación receptora) en grados: movimiento de abajo (0°) a arriba (movimiento vertical).",
                ),
    
                Text( 
                  //IMPRIMIR SOLUCIÓN:
                  '$elevacion°'.replaceAll("null", '0.0'), style: textTextstyle // Theme.of(context).textTheme.display1,
                ),

              Padding(padding: const EdgeInsets.only(top: 20.0)),
              //Imagen: 
             // Container(child: image,),

              linea,
              padding,
                new Text(
                  'Datos'.toUpperCase(), 
                    style: TextStyle(color: Color(0xff0d2e44), fontSize: 19, fontWeight: FontWeight.bold), // Theme.of(context).textTheme.display1,
                  ),

            Padding(padding: const EdgeInsets.only(top: 26.0)),

            new Row(
              children: <Widget>[ sizedbox,

                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Altura del satélite: distancia desde el punto del lanzamiento en la Tierra (fabricante), h [Kmts].", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: hText,
                      keyboardType: TextInputType.number,                  
                      //obscureText: true,
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'h', labelStyle: textstyle,
                        hintText: 'Distancia desde el punto de lanzamiento.', hintStyle: hintstyle,
                        suffixText: 'Km', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),      

                SizedBox(width: 5.0),    
             
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Enlace de subida o bajada (Uplink/Downlink Frecuency): la frecuencia de subida/bajada depende de la banda y el canal del satélite. Ejemplo:\nFuplink      → Banda C (5.925GHz - 6.425GHz), Banda Ku...\nFdownlink → Banda C (3.760GHz - 4.200GHz), Banda Ku...", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 5), backgroundColor: iSnackBackground,
                        //action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: fuplinkText,
                      keyboardType: TextInputType.number,                  
                      //obscureText: true,
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'F.link', labelStyle: textstyle, 
                        hintText: 'Fuplink o Fdownlink', hintStyle: hintstyle,
                        suffixText: 'GHz', suffixStyle: suffixstyle,
                      ),
                    ),
                  ) 
                ),
                
sizedbox,     ]
            ),
            padding,

            new Row(
              children: <Widget>[ sizedbox, 

                Flexible(                                     
                    child: SizedBox(width: 226),                   
                ),

                SizedBox(width: 5.0),         

                Flexible(                                    
                    child: SizedBox(width: 226),                  
                ),

                SizedBox(width: 5.0),

                new Flexible(
                  child: GestureDetector( 
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Posición del satélite: longitud (λ) del satélite geoestacionario en el espacio en grados (°). Tener en cuenta la banda, el canal, la polarización, el EIRP y la huella del satélite.", textAlign: TextAlign.justify),
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: lonsatText,
                      keyboardType: TextInputType.number, 
                      autofocus: true,     
                      //obscureText: true,
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        //prefixIcon: const Icon(Icons.settings_input_antenna, color: Colors.green,),              
                        labelText: 'Sat', labelStyle: textstyle, 
                        hintText: 'Satélite', hintStyle: hintstyle, 
                        suffixText: '°', suffixStyle: suffixstyle,                
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 5.0),
                //Padding(padding: const EdgeInsets.only(top: 15.0)),

                Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Longitud (λ) Oeste/Este ($lonsat $_oesatItem): Nota: la longitud final debe ser oeste para los cálculos en Colombia.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: DropdownButton( value: _oesatItem,
                      items: _oesat.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        ); 
                      }).toList(), 
                      onChanged: (String newValueSelected){
                        _oeItemSatelite(newValueSelected);
                      }, underline: padding, isExpanded: true,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                    ),
                  )),
                ),  
                
sizedbox,     ]
            ),
            padding,

            new Row(
              children: <Widget>[ sizedbox,
                               
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Latitud (φ) del sitio de transmisión/recepción: grados.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: latgtxText,
                      keyboardType: TextInputType.number,                  
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lat[°]', labelStyle: textstyle, 
                        hintText: 'Grados', hintStyle: hintstyle,
                        suffixText: '°', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),

                SizedBox(width: 5.0),

                Flexible(
                  child: GestureDetector(
                      onDoubleTap: (){
                        snackBar = SnackBar(content: Text("Latitud (φ) del sitio de transmisión/recepción: minutos.", textAlign: TextAlign.justify),  
                          duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                          action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      },
                    child: TextField(
                      controller: latmtxText,
                      keyboardType: TextInputType.number,                  
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lat[m]', labelStyle: textstyle, 
                        hintText: 'Minutos', hintStyle: hintstyle,
                        suffixText: '´', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ) ,

                SizedBox(width: 5.0),

                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Latitud (φ) del sitio de transmisión/recepción: segundos.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      },
                    child: TextField(
                      controller: latstxText,
                      keyboardType: TextInputType.number,                  
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lat[seg]', labelStyle: textstyle,
                        hintText: 'Segundos', hintStyle: hintstyle,
                        suffixText: '´´', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),

                SizedBox(width: 5.0), 

                Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Latitud (φ) de la estación terrena (norte/sur): ($lattx $_latitudItemSelected).", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: DropdownButton( value: _latitudItemSelected,
                      items: _latitud.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        ); 
                      }).toList(), 
                      onChanged: (String newValueSelected){
                        _onDropDownItemSelected(newValueSelected, _longitudItemSelected);
                      }, underline: padding, isExpanded: true,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                    ),
                  )),
                ),                     

sizedbox,     ]
            ),
            padding,

            new Row(
              children: <Widget>[ sizedbox,

              new Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Longitud (λ) del sitio de transmisión/recepción: grados.", textAlign: TextAlign.justify,),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){ debugPrint("aceptar"); }),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: longtxText,
                      keyboardType: TextInputType.number,       
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lon[°]', labelStyle: textstyle,
                        hintText: 'Grados', hintStyle: hintstyle,
                        suffixText: '°', suffixStyle: suffixstyle,                  
                      ),
                    ),
                  )
                ),

                 SizedBox(width: 5.0),

                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Longitud (λ) del sitio de transmisión/recepción: minutos.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: lonmtxText,
                      keyboardType: TextInputType.number,                  
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lon[m]', labelStyle: textstyle,
                        hintText: 'Minutos', hintStyle: hintstyle,
                        suffixText: '´', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),

                 SizedBox(width: 5.0),

                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Longitud (λ) del sitio de transmisión/recepción: segundos.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: lonstxText,
                      keyboardType: TextInputType.number,                  
                      //obscureText: true,
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Lon[seg]', labelStyle: textstyle,
                        hintText: 'Segundos', hintStyle: hintstyle,
                        suffixText: '´´', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),                

                 SizedBox(width: 5.0),

                  Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Longitud (λ) de la estación terrena (oeste/este): $lontx $_longitudItemSelected). Ej: En Colombia es oeste.", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: DropdownButton( value: _longitudItemSelected,
                      items: _longitud.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        ); 
                      }).toList(), 
                      onChanged: (String newValueSelected){
                        _onDropDownItemSelected(_latitudItemSelected, newValueSelected);                        
                      }, underline: padding, isExpanded: true,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                    ),
                  )),
                ),  

               
sizedbox,    ]
            ),
            padding,

/*
            new Row(
              children: <Widget>[ sizedbox,

                Flexible(
                  child: GestureDetector(
                    onDoubleTap: (){
                      snackBar = SnackBar(content: Text("Enlace de bajada (Downlink Frecuency): la frecuencia de bajada depende de la banda y el canal del satélite. Banda C (3.76GHz - 4.2GHz), Banda Ku...", textAlign: TextAlign.justify),  
                        duration: Duration(seconds: 3), backgroundColor: iSnackBackground,
                        action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                      );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                    child: TextField(
                      controller: fdownlinkText,
                      keyboardType: TextInputType.number,                  
                      //obscureText: true,
                      decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                        labelText: 'Fdownlink', labelStyle: textstyle,
                        hintText: 'Frecuencia', hintStyle: hintstyle,
                        suffixText: 'GHz', suffixStyle: suffixstyle,
                      ),
                    ), 
                  )
                ),
                
sizedbox,     ]
            ),   
                       */ 

            Padding(padding: const EdgeInsets.only(top: 45.0)),

            linea,

            Padding(padding: const EdgeInsets.only(top: 45.0)),

          ],
        ),
      ),

     ////////////////Cálcular////////////////////////:
      floatingActionButton: FloatingActionButton(
        onPressed: _calcular,
          tooltip: 'Analizar',
            child: Icon(Icons.satellite), backgroundColor: Color(0xff0d2e44),

      ),
    );
  }

  Future<bool> createAlertDialog(BuildContext context) {
      return showDialog(context: context, builder: (context){
        return AlertDialog( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Container( 
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),   
            child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(height: 100.0,),
                  Container(height: 100.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                      color: Color(0xff0d2e44), ),
                      child: Center(child: Text('Detalles', style: TextStyle(color: Colors.white),)),
                  ),
                ],),],),),
          
         // Text('Resultados'.toUpperCase()),
          content: Container( height:395.0, width: 400.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: SingleChildScrollView( child: Column(
              children: <Widget>[

                //INICIO RESULTADOS//
                Padding(padding: const EdgeInsets.only(top: 10.0)),

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'LatTx: $lattx ° $_latitudItemSelected' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Latitud del sitio de transmisión.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'LonTx: $lontx ° $_longitudItemSelected' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Longitud del sitio de transmisión.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'LFS: $lfs dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Pérdidas (atenuación) en el espacio libre.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'd: $d Km' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Distancia real desde la estación terrena de transmisión hasta el satélite en kilometros.",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'Qd: $qdtx °',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Diferencia de longitud para la transmisión (Qd) en grados. Qd = Qs - Qr. El resultado puede ser negativo.",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'X: $x °',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "variable del ángulo de elevación en grados.",
                  ),
                ),
                padding,

                 Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'Elevación: $elevacion °' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Elevación de la antena de transmisión en grados.",
                  ),
                ),
                padding,

                //FIN RESULTADOS//               
              ], 
            ),),
          ), 
          actions: <Widget>[
            MaterialButton(elevation: 5.0, child: Text('Aceptar'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: (){ Navigator.of(context).pop();}, )
          ],
        );
      }
    );
  }

  Future<bool> stylishDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return Dialog( 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container( height:650.0, width: 400.0,
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
                        image: DecorationImage(image: AssetImage('images/satelite.bmp'), fit: BoxFit.cover),)
                    ),
                  ),
                ],),

                //INICIO RESULTADOS//
                new Text(
                  'Detalles'.toUpperCase(), 
                    style: TextStyle(color: Color(0xff0d2e44), fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.bold), // Theme.of(context).textTheme.display1,
                  ),

                Padding(padding: const EdgeInsets.only(top: 20.0)),

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      _latitudItemSelected=="Norte"?
                      'φTx: $lattx° (N)' : 'LatTx: $lattx° (S)',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Latitud (φ) del sitio de transmisión/recepción: estación terrena de transmisión/recepción satelital (°).",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'λTx: -$lontx° (O)', // ($_longitudItemSelected)' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Longitud (λ) del sitio de transmisión/recepción: estación terrena de transmisión/recepción satelital (°). Ej: Oeste(O) para Colombia.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'LFS: $lfs dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Pérdidas (atenuación) en el espacio libre.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'd: $d Km' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Distancia real desde la estación terrena de transmisión/recepción hasta el satélite en kilometros.",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'Qd: $qdtx °',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Diferencia de longitud para la transmisión/recepción (Qd) en grados. Qd = Qs - Qr. El resultado puede ser negativo.",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'X: $x °',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "variable del ángulo de elevación en grados.",
                  ),
                ),
                padding,

                 Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'Elevación: $elevacion °' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Elevación de la antena de transmisión/recepción en grados.",
                  ),
                ),
                padding,
                
                Padding(padding: const EdgeInsets.only(top: 40)),  
                //Linea 
                Row( children: <Widget>[  
                  SizedBox(width: 20.0),  Flexible( child: linea,), SizedBox(width: 20.0),
                ]),

                //FIN RESULTADOS//
                
                SizedBox(height: 5.0,),

                FlatButton(child: Center(child: Text('Aceptar'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),), ), 
                onPressed: (){ Navigator.of(context).pop();},),
  
                SizedBox(height: 5.0,),  

              ], 
            ), ),
          ),
        );
      }
    );
  }

  Future<bool> errorAlertDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return AlertDialog( 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('Cuidado'),
        content:    
                    new Text(
                      'Ingresa todos los datos correctamente para poder realizar el análisis.' ,
                      style: TextStyle(fontSize: 13, letterSpacing: -0.3), textAlign: TextAlign.justify,// Theme.of(context).textTheme.display1,
                    ), 
                                           
        actions: <Widget>[
          MaterialButton(elevation: 5.0, child: Text('Aceptar'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: (){ Navigator.of(context).pop();}, )
        ],
      );
    });
  }


}