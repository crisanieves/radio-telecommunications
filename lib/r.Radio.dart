import 'dart:math';
import 'package:flutter/material.dart';

class Radiodifusion extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Radio',
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
        primarySwatch: Colors.blue
      ),
      home: MyRadioPage(),
    );
  }
}

class MyRadioPage extends StatefulWidget {
  MyRadioPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyRadioPageState createState() => _MyRadioPageState();
}

class _MyRadioPageState extends State<MyRadioPage> with AutomaticKeepAliveClientMixin<MyRadioPage> {
  //Definir propiedad para mantener datos en el Tab de la página = true:
  bool get wantKeepAlive => true;

  //Definición de constantes:
  double c = 300000000;                   // Velocidad de la luz: 3e8 m/s
  double pi = 3.14159265359;              // Constante PI
  //Definición de variables matemáticas:
  double lsf, nTx, nCaras, gantx, zant, aDistribuidor, aCable, lCable, ptx, dBuV_m, distancia; 
  double pv, pc, pa, kE, prcdBm, aELdB, aCabledB, ptxdBm, aDistribucion, sGANTX, nN, x, a, solucion;

  String eE;
  
  //Definición de variables controladoras de edición de texto:
  final TextEditingController fchText           = new TextEditingController();
  final TextEditingController nTxText           = new TextEditingController();
  final TextEditingController nCarasText        = new TextEditingController();
  final TextEditingController gantxText         = new TextEditingController();
  final TextEditingController zantText          = new TextEditingController();
  final TextEditingController aDistribuidorText = new TextEditingController();
  final TextEditingController aCableText        = new TextEditingController();
  final TextEditingController lCableText        = new TextEditingController(); 
  final TextEditingController ptxText           = new TextEditingController();
  final TextEditingController distanciaText     = new TextEditingController();
  //Variables para DropDownButton:
  var _bands = ['Banda','I','II','III','IV','V'];
  var _bandsItemSelected ='Banda';

  var _nivel = ['Nivel máximo','Nivel mínimo'];
  var _nivelItemSelected = 'Nivel máximo';

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

  void _onDropDownItemSelected(String newValueSelected, String nivelValueSelected) {
    setState(() {
      _nivelItemSelected = nivelValueSelected;                      
      _bandsItemSelected = newValueSelected;

//Condiciones para la BANDA DE TRANSMISIÓN utilizada:
          //Niveles De Potencia Para NIVEL DE SERVICIO MÁXIMO ---> dBuV/m
          if (_nivelItemSelected == 'Nivel máximo') 
          {      
              if      (_bandsItemSelected == "I")   { dBuV_m = (80);}
              else if (_bandsItemSelected == "II")  { dBuV_m = (80);}
              else if (_bandsItemSelected == "III") { dBuV_m = (83);}
              else if (_bandsItemSelected == "IV")  { dBuV_m = (86);}
              else if (_bandsItemSelected == "V")   { dBuV_m = (91);}
              else {dBuV_m = null;}
          }
           
          //Niveles De Potencia Para NIVEL DE SERVICIO MÍNIMO ---> dBuV/m
          else
          {
              if      (_bandsItemSelected == "I")   { dBuV_m = (48);}
              else if (_bandsItemSelected == "II")  { dBuV_m = (48);}
              else if (_bandsItemSelected == "III") { dBuV_m = (55);}
              else if (_bandsItemSelected == "IV")  { dBuV_m = (65);}
              else if (_bandsItemSelected == "V")   { dBuV_m = (70);}
              else {dBuV_m = null;}
          }

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
      fchText.text            = fchText.text.replaceAll(",",".").replaceAll(" ","");   
      nTxText.text            = nTxText.text.replaceAll(",",".").replaceAll(" ", ""); 
      nCarasText.text         = nCarasText.text.replaceAll(",",".").replaceAll(" ","");
      gantxText.text          = gantxText.text.replaceAll(",",".").replaceAll(" ","");
      aCableText.text         = aCableText.text.replaceAll(",",".").replaceAll(" ","");
      aDistribuidorText.text  = aDistribuidorText.text.replaceAll(",",".").replaceAll(" ","");
      
      //ALMACENAR VARIABLES DE ENTRADA (SISTEMA RADIADO) COMO NÚMEROS///Obtiene el texto del TextField y lo convierte en número:       
      lsf     = double.parse(fchText.text);
      nTx     = double.parse(nTxText.text);       nCaras    = double.parse(nCarasText.text);        
      gantx   = double.parse(gantxText.text);     zant      = double.parse(zantText.text);           aDistribuidor = double.parse(aDistribuidorText.text);
      aCable  = double.parse(aCableText.text);    lCable    = double.parse(lCableText.text);
      ptx     = double.parse(ptxText.text);       distancia = double.parse(distanciaText.text);

      // Condiciones de potencia de transmisión, de impedancia de antena, # de transmisores, de caras y distancia:
      if(ptx <= 0){
        ptxText.text = "1"; ptx = 1;
      }
      if(zant <= 0){
        zantText.text = "50"; zant = 50;
      }
      if(nTx <= 0){
        nTxText.text = "1"; nTx = 1;
      }
      if(nCaras <= 0){
        nCarasText.text = "1"; nCaras = 1;
      }
      if(distancia <= 0){
        distanciaText.text = "1"; distancia = 1; 
      }

      // LSF (Low shift Frecuency, Frecuencia Lateral inferior) FCH
        pv = lsf + 1.25;  // +1.25MHz(La portadora de video está a 1.25Mhz de LSF) FMHz
        pc = lsf + 4.83;  // +4.83MHz(La portadora de Color está a 4.83Mhz de LSF) PC
        pa = lsf + 5.75;  // +5.75MHz(La portadora de Audio está a 5.75Mhz de LSF) PA

      //HALLA E = dBm + kE, Por ejemplo dBm + 107 para Zant = 50 ohms
        kE = ((-(10 * (log(zant) / log(10)))) + 30);              //-10log(1e-3) = +30
          kE = ((kE * -1) + 120);                               //-10log(1e-6) = +120
            kE = double.parse(kE.toStringAsFixed(0));         //Redondea el valor a ",1" decimal
                      
              // SOLO PARA VISUALIZAR E = dBm + kE = dBuV
                  eE = "dBm + " + kE.toString();          //dBm = PRC

      //Potencia en el sitio mas lejano PRC [dBm]. Normalmente el resultado es "negativo".
        x = pv * 1000000;              // En esta fórmula la frecuencia es con notación (Hz)
        x = (2 * pi * x) / c;
        x = kE + (20 * (log(x) / log(10)));
        prcdBm = (dBuV_m) - x; //  prcdBm = dBuV_m - x;   //dBm = PRC


       //Atenuación en el espacio Libre aEL [dB]
        x = (20 * (log(pv) / log(10)));
        x = (20 * (log(distancia) / log(10))) + x;
        aELdB =  (32.44 + x);
                      
        
      //Atenuación TOTAL del cable [dB]
        a = ((lCable) * (aCable));
        aCabledB = (a / 100);


      //Atenuación por la distribución [dB]
        x = nTx / nCaras;                            //Número de transmisores/número de caras.
        aDistribucion = (10 * (log(x) / log(10)));
        aDistribucion = (aDistribucion).abs();     // puede o no ser negativo, pero siempre
                                                  // se toma el valor absoluto.

      //Potencia de transmisión [Watts] a dBm
        x = ptx / 0.001;
        ptxdBm = (10 * (log(x) / log(10)));


      //Ganancia del Sistema de Radiación [dB]
        sGANTX = prcdBm - ptxdBm + aCabledB + aELdB + aDistribucion + aDistribuidor;
          

      //Número de antenas (N) GANTX[dB]= 10log(N)+ Gantx[dB]
        x = (sGANTX - gantx) / 10;
        nN = pow(10,(x));

      //Redondear —después de todos los cálculos—:
        prcdBm = double.parse(prcdBm.toStringAsFixed(12));
        ptxdBm = double.parse(ptxdBm.toStringAsFixed(12));
        sGANTX = double.parse(sGANTX.toStringAsFixed(12));

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
    //Imagen:
    AssetImage         assetImage         = AssetImage('images/radio.bmp');
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
                      'Número de antenas (N)'.toUpperCase(), 
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                  ), 
                    message: "Número de antenas que debe usar el sistema (Normalmente tipo Panel): al realizar los cálculos da como resultado el número de antenas necesarias para el sistema.",
                ),
    
                Text( 
                  //IMPRIMIR SOLUCIÓN:
                  '$nN'.replaceAll("null", '0.0'), style: textTextstyle // Theme.of(context).textTheme.display1,
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
                    new Flexible(
                      child: GestureDetector( 
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Frecuencia lateral inferior del canal (LSF), VHF/UHF. Ingrese el valor en MHz.", textAlign: TextAlign.justify),
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: fchText,
                          keyboardType: TextInputType.number, 
                          autofocus: true,     
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            //prefixIcon: const Icon(Icons.settings_input_antenna, color: Colors.green,),              
                            labelText: 'Fch', labelStyle: textstyle, 
                            hintText: 'Canal...', hintStyle: hintstyle, 
                            suffixText: 'MHz', suffixStyle: suffixstyle,                
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),
                    //Padding(padding: const EdgeInsets.only(top: 15.0)),
                    
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("El número de transmisores de RF a utilizar: normalmente sólo un (1) transmisor de TV VHF/UHF.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: nTxText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Transmisores', labelStyle: textstyle, 
                            hintText: 'Número de transmisores...', hintStyle: hintstyle
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                          onDoubleTap: (){
                            snackBar = SnackBar(content: Text("Número de bahias o caras: normalmente una (1) cara pero pueden ser más.", textAlign: TextAlign.justify),  
                              duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                              action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          },
                        child: TextField(
                          controller: nCarasText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Caras', labelStyle: textstyle, 
                            hintText: 'Número de bahias o caras...', hintStyle: hintstyle
                          ),
                        ), 
                      )
                    ) ,
    sizedbox,     ]
                ),
                padding,

                new Row(
                  children: <Widget>[ sizedbox,

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Ganancia de la(s) antena(s) a utilizar en el sistema. Normalmente tipo panel de 50 ohms para la radiodifución de la señal: Gantx[dB] = dBi + 2.14.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          },
                        child: TextField(
                          controller: gantxText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Gantx', labelStyle: textstyle,
                            hintText: 'Ganancia de la(s) antena(s)...', hintStyle: hintstyle,
                            suffixText: 'dB', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),
                  
                  SizedBox(width: 10.0),

                    new Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Impedancia de entrada de la(s) antena(s) [Ohms]. Normalmente 50 Ohms porque se necesita radiar la mayor cantidad de potencia para dar cubrimiento.", textAlign: TextAlign.justify,),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "MÁS", textColor: Colors.white, 
                            onPressed: (){  
                              snackBar = SnackBar(content: Text("La impedancia característica de la linea de transmisión (cable) es normalmente de 50 ohms. La impedancia del cable debe ser igual a la impedancia de entrada de la antena, la impedancia del distribuidor y a la impedancia de salida del transmisor de TV (50 Ohms). Cuando la impedancia de estos sistemas es igual se transfiere la máxima potencia y el sistema transmite.", textAlign: TextAlign.justify),  
                              duration: Duration(seconds: 10), backgroundColor: Colors.blue
                              ); _scaffoldKey.currentState.showSnackBar(snackBar);
                            }),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: zantText,
                          keyboardType: TextInputType.number,       
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Zant[Ohms]', labelStyle: textstyle,
                            hintText: 'Impedancia de entrada de la(s) antena(s) [50 Ohms]...', hintStyle: hintstyle,
                            suffixText: 'Ω', suffixStyle: suffixstyle,                  
                          ),
                        ),
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Atenuación del distribuidor, repartidor o divisor de Alta Potencia (Pérdidas de inserción) [dB]. Consultar el DataSheet del fabricante. Puede o no existir un segundo distribuidor de Alta Potencia.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: aDistribuidorText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'αDivisor[dB]', labelStyle: textstyle,
                            hintText: 'Atenuación del distribuidor de Alta Potencia [dB]...', hintStyle: hintstyle,
                            suffixText: 'dB', suffixStyle: suffixstyle,
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
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Atenuación del cable [dB/100mts]: consultar al fabricante (Datasheet).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: aCableText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'αCable/100mts[dB]', labelStyle: textstyle,
                            hintText: 'Atenuación del cable [dB/100mts]...', hintStyle: hintstyle,
                            suffixText: 'dB', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                  SizedBox(width: 10.0),
                    //Padding(padding: const EdgeInsets.only(top: 15.0)),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Longitud del cable en metros. Longitud desde el TXRF/VHF/UHF a la antena/distribuidor (con latiguillos). Linea de Transmisión Coaxial (50 Ohms) HELIAX@ ú otro Fabricante. Click para información...", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: lCableText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Longitud del cable[mts]', labelStyle: textstyle,
                            hintText: 'Linea de Transmisión Coaxial...', hintStyle: hintstyle,
                            suffixText: 'm', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Potencia de transmisión en vatios.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: ptxText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'PTX [WATTS]', labelStyle: textstyle, 
                            hintText: 'Potencia de transmisión...', hintStyle: hintstyle,
                            suffixText: 'Watts', suffixStyle: suffixstyle,
                          ),
                        ),
                      ) 
                    ),

    sizedbox,    ]
                ),
                padding,

                new Row(
                  children: <Widget>[ sizedbox,
                    
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Distancia a cubrir (hasta el punto más lejano)[Kmts].", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: distanciaText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Distancia a cubrir[Kmts]', labelStyle: textstyle,
                            hintText: 'Distancia a cubrir...', hintStyle: hintstyle,
                            suffixText: 'km', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                      Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Nivel de servicio: nivel máximo o nivel mínimo para la banda de transmisión (I-V).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: DropdownButton( value: _nivelItemSelected,
                          items: _nivel.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            ); 
                          }).toList(), 
                          onChanged: (String newValueSelected){
                            _onDropDownItemSelected(_bandsItemSelected, newValueSelected);                        
                          }, underline: padding, isExpanded: true,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                        ),
                      )),
                    ),  

                    sizedbox,

                    Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Banda de transmisión (I-V) para el nivel de servicio: nivel máximo o nivel mínimo. Valor actual ($_nivelItemSelected: $dBuV_m)", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: DropdownButton( value: _bandsItemSelected,
                          items: _bands.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            ); 
                          }).toList(), 
                          onChanged: (String newValueSelected){
                            _onDropDownItemSelected(newValueSelected, _nivelItemSelected);
                          }, underline: padding,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                        ),
                      )),
                    ),  
                    
    sizedbox,     ]
                ),   
                        
                Padding(padding: const EdgeInsets.only(top: 50.0)),

                linea,

                Padding(padding: const EdgeInsets.only(top: 50.0)),

              ],
            ),
          ),

     ////////////////Cálcular////////////////////////:
          floatingActionButton: FloatingActionButton(
            onPressed: _calcular,
              tooltip: 'Analizar',
                child: Icon(Icons.settings_input_antenna), backgroundColor: Color(0xff0d2e44),

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
          content: Container( height:450.0, width: 400.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: SingleChildScrollView( child: Column(
              children: <Widget>[

                //INICIO RESULTADOS//
                Padding(padding: const EdgeInsets.only(top: 10.0)),

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'PV: $pv MHz' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de video del canal, FMHZ, está a 1,25Mhz de LSF. PV = LSF[MHz] + 1.25MHz",
                  ),
                ),
                padding,
                
                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'PC: $pc MHz' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de color del canal está a 4,83Mhz de LSF",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'PA: $pa MHz',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de audio del canal está a 5,75Mhz de LSF",
                  ),
                ),
                padding,
                
                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'E: $eE',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia en dBm Vs dBuV = dBm + kte(depende del parámetro Zant). Sólo la constante kE(kte) es usada para cálculos; dBm + kE no es usado para cálculos,",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                   child: Tooltip( child: Center(
                   child: new Text(
                      'PRC: $prcdBm dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia en el sitio mas lejano: PRC[dBm] = dBm.",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αEL: $aELdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación en el espacio libre",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αCable: $aCabledB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación total del cable (con latiguillos).",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αD: $aDistribucion dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación (pérdidas) por la distribución: 10log(nTx/nCaras).",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PTX: $ptxdBm dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia de transmisión en dBm",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'GAN TX: $sGANTX dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia del sistema de transmisión",
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 10.0)),

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
          child: Container( height:750.0, width: 400.0,
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
                        image: DecorationImage(image: AssetImage('images/radio.bmp'), fit: BoxFit.cover),)
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
                      'PV: $pv MHz' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de video del canal, FMHZ, está a 1,25Mhz de LSF. PV = LSF[MHz] + 1.25MHz",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'PC: $pc MHz' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de color del canal está a 4,83Mhz de LSF",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'PA: $pa MHz',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de audio del canal está a 5,75Mhz de LSF",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'E: $eE',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia en dBm Vs dBuV = dBm + kte(depende del parámetro Zant). Sólo la constante kE(kte) es usada para cálculos; dBm + kE no es usado para cálculos,",
                  ),
                ),
                padding,

                 Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PRC: $prcdBm dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Potencia en el sitio mas lejano: PRC[dBm] = dBm.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αEL: $aELdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Atenuación en el espacio libre",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αCable: $aCabledB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación total del cable (con latiguillos).",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                 child: Tooltip( child: Center(
                   child: new Text(
                      'αD: $aDistribucion dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación (pérdidas) por la distribución: 10log(nTx/nCaras).",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PTX: $ptxdBm dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia de transmisión en dBm",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),  
                  child: Tooltip( child: Center(
                   child: new Text(
                      'GAN TX: $sGANTX dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia del sistema de transmisión",
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 40)),   
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