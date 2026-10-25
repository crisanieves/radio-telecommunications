import 'dart:math';
import 'package:flutter/material.dart';

class Microondas extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'MicroOndas',
      theme: ThemeData(

        primarySwatch: Colors.blue
      
      ),
      home: MyMicroondasPage(),
    );
  }
}

class MyMicroondasPage extends StatefulWidget {
  MyMicroondasPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMicroondasPageState createState() => _MyMicroondasPageState();
}

class _MyMicroondasPageState extends State<MyMicroondasPage> with AutomaticKeepAliveClientMixin<MyMicroondasPage> {
  //Definir propiedad para mantener datos en el Tab de la página = true:
  bool get wantKeepAlive => true;

  //K = Constante de Boltzmann en Joules/Kelvin
  double k = 1.38e-23;
  //Definición de variables matemáticas:
  double r, msnmTx, hTx, lCableTx, aCableTx, gantx, nA, nTy, distancia, f, msnmRx, hRx, lCableRx, aCableRx, ganrx, tr, bwn, cn, fA, fB; 
  double gantxdB, ganrxdB, hT, hR, penlace, lfs, fm, aCABLE, aRamf, n, cmin, gsistema, ptxdBm, ptxWatts, x;
  
  //Definición de variables controladoras de edición de texto:
  final TextEditingController confiabilidadText   = new TextEditingController();
  final TextEditingController msnmTxText          = new TextEditingController();
  final TextEditingController hTxText             = new TextEditingController();
  final TextEditingController lCableTxText        = new TextEditingController();
  final TextEditingController aCableTxText        = new TextEditingController();
  final TextEditingController gantxText           = new TextEditingController();

  final TextEditingController nAText              = new TextEditingController();
  final TextEditingController nTyText             = new TextEditingController();
  final TextEditingController distanciaText       = new TextEditingController();
  final TextEditingController fText               = new TextEditingController();

  final TextEditingController msnmRxText          = new TextEditingController();
  final TextEditingController hRxText             = new TextEditingController();
  final TextEditingController lCableRxText        = new TextEditingController();
  final TextEditingController aCableRxText        = new TextEditingController();
  final TextEditingController ganrxText           = new TextEditingController(); 

  final TextEditingController trText              = new TextEditingController();
  final TextEditingController bwnText             = new TextEditingController();
  final TextEditingController cnText              = new TextEditingController();
  
  //Variables para DropDownButton:
  var _fB = ['Factor Climático B','Para un sitio lluvioso','Areas calientes y humedas','Para climas promedios','Para climas secos y montañosos',];
  var _factorBItemSelected ='Factor Climático B';

  var _fA = ['Factor Topográfico A','Sobre terreno liso, agua, plano','Promedio','Aspero montañoso'];
  var _factorAItemSelected = 'Factor Topográfico A';

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

  void _onDropDownItemSelected(String factorBSelected, String factorASelected) {
    setState(() {
      _factorAItemSelected = factorASelected;                      
      _factorBItemSelected = factorBSelected;
      
        if      (_factorAItemSelected  == "Sobre terreno liso, agua, plano")  { fA = (4);   }
        else if (_factorAItemSelected  == "Promedio")                         { fA = (1);   }
        else if (_factorAItemSelected  == "Aspero montañoso")                 { fA = (0.25);}
        else    {fA = null;}
                     
      //Niveles De Potencia Para NIVEL DE SERVICIO MÍNIMO ---> dBuV/m

        if      (_factorBItemSelected == "Para un sitio lluvioso")          { fB = (1);}
        else if (_factorBItemSelected == "Areas calientes y humedas")       { fB = (0.5);}
        else if (_factorBItemSelected == "Para climas promedios")           { fB = (0.25);}
        else if (_factorBItemSelected == "Para climas secos y montañosos")  { fB = (0.125);}
        else    {fB = null;}       

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
      confiabilidadText.text  = confiabilidadText.text.replaceAll(",",".").replaceAll(" ",""); 
      msnmTxText.text         = msnmTxText.text.replaceAll(",",".").replaceAll(" ",""); 
      msnmRxText.text         = msnmRxText.text.replaceAll(",",".").replaceAll(" ","");   
      nAText.text             = nAText.text.replaceAll(",",".").replaceAll(" ", ""); 
      nTyText.text            = nTyText.text.replaceAll(",",".").replaceAll(" ","");
      gantxText.text          = gantxText.text.replaceAll(",",".").replaceAll(" ","");
      ganrxText.text          = ganrxText.text.replaceAll(",",".").replaceAll(" ","");
      fText.text              = fText.text.replaceAll(",",".").replaceAll(" ","");
      aCableTxText.text       = aCableTxText.text.replaceAll(",",".").replaceAll(" ","");
      aCableRxText.text       = aCableRxText.text.replaceAll(",",".").replaceAll(" ","");
      distanciaText.text      = distanciaText.text.replaceAll(",",".").replaceAll(" ","");
      
      
      //ALMACENAR VARIABLES DE ENTRADA (SISTEMA RADIADO) COMO NÚMEROS///Obtiene el texto del TextField y lo convierte en número:       
      r         = double.parse(confiabilidadText.text);   msnmTx   = double.parse(msnmTxText.text); 
      hTx       = double.parse(hTxText.text);             lCableTx = double.parse(lCableTxText.text); 
      aCableTx  = double.parse(aCableTxText.text);        gantx    = double.parse(gantxText.text); 
      nA        = double.parse(nAText.text);              nTy      = double.parse(nTyText.text); 
      distancia = double.parse(distanciaText.text); 
      f         = double.parse(fText.text);               msnmRx   = double.parse(msnmRxText.text); 
      hRx       = double.parse(hRxText.text);             lCableRx = double.parse(lCableRxText.text);
      aCableRx  = double.parse(aCableRxText.text);        ganrx    = double.parse(ganrxText.text); 

      tr = double.parse(trText.text);               
      bwn = double.parse(bwnText.text);  cn = double.parse(cnText.text);   
      // Condiciones:
      if(hTx <= 0)        {   hTxText.text = "50";  hTx = 50;         }
      if(hRx <= 0)        {   hTxText.text = "50";  hRx = 50;         }
      if(nA <= 0)         {   nAText.text = "1";    nA = 1;           }
      if(nTy <= 0)        {   nTyText.text = "1";   nTy = 1;          }
      if(r >= 100)        {   confiabilidadText.text = "99"; r = 99;  }
      if(bwn <= 0)        {   bwnText.text = "10";  bwn = 10;         }
      if(cn <= 0)         {   cnText.text = "15";   cn = 15;          }
      if(f <= 0)          {   fText.text = "1.76";  f = 1.76;         }
      if(distancia <= 0)  { distanciaText.text = "1"; distancia = 1;  }

      //Ganancia de la antena dBi -----> dB
        gantxdB = gantx + 2.14;
        ganrxdB = ganrx + 2.14;

      //Altura real de cada punto, desde el nivel del mar hasta la altura de la antena respectiva [mts]
        hT = msnmTx + hTx;
        hR = msnmRx + hRx;

      //Permitividad del enlace [Kmts]
        penlace = 4.07 + (sqrt(hT + hR));

      //Atenuación en el espacio Libre [dB]
        x = (20 * (log(f) / log(10)));
          x = (20 * (log(distancia) / log(10))) + x;
            lfs = 92.44 + (x);

      //Margen de desvanecimiento [dB]
      double re, logD, logR;            
        re = r / 100;                                   // Confiabilidad en decimal
          logD = (30 * (log(distancia) / log(10)));
            x = ((6 * fA * fB * f));
              x = (log(x) / log(10));
                x = logD + (10 * x);
                  logR = (10 * (log(1 - re) / log(10)));
                    x = x - logR;
                      fm = x - 70;

      //ATENUACIÓN TOTAL DEL CABLEADO [dB]
      //lCableTX = (mtx1) + (mtx2) + (mtx3) + (hTX) - (mtx4)
      //lCableRX = (mrxA) + (mrxB) + (mrxC) + (hRX) - (mrxD)
        double aTx, aRx;    
        aTx = ((lCableTx) * (aCableTx)) / 100;
        aRx = ((lCableRx) * (aCableRx)) / 100;
        aCABLE = (aTx + aRx);
                      
      //Pérdidas por ramificación del sistema [dB]
        aRamf = (nA) + (nTy);

      //Potencia de ruido [dBm]
      //Capacidad del receptor de recibir señales de baja intensidad y amplificarlas

        x = (10 * (log(k * tr / 0.001) / log(10)));     //se suele aproximar a -174dBm con tr = 290K
        n = x + (10 * (log(bwn * 1000000) / log(10)));

      //Umbral Mínimo De la Portadora en el Receptor [dBm] (Potencia minima de la portadora de banda ancha en la entrada del receptor)
      //Capacidad del receptor de recibir bajas potencias y amplificarlas
      //Cmin[dBm] = C/N[dB] + N[dBm]
        cmin = (cn) + (n);
          

      //GANANCIA DEL SISTEMA MICROONDAS
      //GSISTEMA[dB] = Ptx[dBm]-Cmin[dBm]
      //Ganancia del Sistema [dB]:
        gsistema = (fm) + (lfs) + (aCABLE) + (aRamf) - (gantxdB) - (ganrxdB);

      //POTENCIA MINIMA DE LA PORTADORA TRANSMISORA
      //PTX [dBm]
        ptxdBm = (gsistema) + (cmin);

      //PTX [WATTS]
        x = (ptxdBm / 10);
        ptxWatts = (pow (10, x)) * 0.001;

      //Redondear —después de todos los cálculos—:
        ptxWatts = double.parse(ptxWatts.toStringAsFixed(12));

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
    AssetImage         assetImage         = AssetImage('images/uondas.jpg');
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
                    'Potencia transmisora'.toUpperCase(), 
                    style: textTextstyle // Theme.of(context).textTheme.display1,
                  ), 
                  message: "Potencia mínima de la portadora transmisora que debe usar el sistema: al realizar los cálculos da como resultado la potencia mínima para el sistema.",
                ),
    
                Text( ptxdBm==null?
                  //IMPRIMIR SOLUCIÓN:
                  '$ptxdBm'.replaceAll("null", '0.0') : '$ptxdBm' + ' dBm', style: textTextstyle // Theme.of(context).textTheme.display1,
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
                    Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Factor climático B (valor actual: $_factorBItemSelected es $fB).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: DropdownButton( value: _factorBItemSelected,
                          items: _fB.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            ); 
                          }).toList(), 
                          onChanged: (String newValueSelected){
                            _onDropDownItemSelected(newValueSelected, _factorAItemSelected);
                          }, underline: padding, isExpanded: true,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                        ),
                      )),
                    ), 

    sizedbox,     ],
                ),
                padding,

                new Row(
                  children: <Widget>[ sizedbox,
                    Flexible( child: Container(decoration: bandadecoration, padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Factor topográfico A (valor actual: $_factorAItemSelected es $fA)", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: DropdownButton( value: _factorAItemSelected,
                          items: _fA.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            ); 
                          }).toList(), 
                          onChanged: (String newValueSelected){
                            _onDropDownItemSelected(_factorBItemSelected, newValueSelected);                        
                          }, underline: padding, isExpanded: true,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),                                
                        ),
                      )),
                    ),  
    sizedbox,     ],
                ),
                padding,     

                new Row(
                  children: <Widget>[ sizedbox,
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Confiabilidad: es un valor porcentual y normalmente es establecido al 99%.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: confiabilidadText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'R', labelStyle: textstyle,
                            hintText: 'Confiabilidad', hintStyle: hintstyle,
                            suffixText: '%', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector( 
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Altura del sitio donde está ubicada la estación terrena de transmisión (estudio) en metros (metros sobre el nivel del mar).", textAlign: TextAlign.justify),
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: msnmTxText,
                          keyboardType: TextInputType.number, 
                          autofocus: true,     
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            //prefixIcon: const Icon(Icons.settings_input_antenna, color: Colors.green,),              
                            labelText: 'Hstx', labelStyle: textstyle, 
                            hintText: 'Altura del sitio de TX (estudio)...', hintStyle: hintstyle, 
                            suffixText: 'm', suffixStyle: suffixstyle,                
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),
                    //Padding(padding: const EdgeInsets.only(top: 15.0)),
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Altura desde el suelo hasta el centro de la antena de transmisión en metros (metros sobre el nivel del suelo).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: hTxText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'hTx ', labelStyle: textstyle,
                            hintText: 'Altura de la antena...', hintStyle: hintstyle,
                            suffixText: 'm', suffixStyle: suffixstyle,
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
                          snackBar = SnackBar(content: Text("Longitud total en metros de la línea de transmisión (cable): desde el transmisor microondas hasta la antena de transmisión.", textAlign: TextAlign.justify),
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: lCableTxText,
                          keyboardType: TextInputType.number, 
                          autofocus: true,     
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            //prefixIcon: const Icon(Icons.settings_input_antenna, color: Colors.green,),              
                            labelText: 'LCableTX', labelStyle: textstyle, 
                            hintText: 'Longitud total...', hintStyle: hintstyle, 
                            suffixText: 'm', suffixStyle: suffixstyle,                
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),
                                                
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Atenuación característica del cable de transmisión por cada cien metros de cable [dB/100mts]: consultar al fabricante (Datasheet).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: aCableTxText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'αCableTX', labelStyle: textstyle, 
                            hintText: 'Atenuación del cable [dB/100m]', hintStyle: hintstyle,
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
                          snackBar = SnackBar(content: Text("Ganancia de la antena de transmisión microondas [dBi].", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: gantxText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'GanTX', labelStyle: textstyle, 
                            hintText: 'Ganancia...', hintStyle: hintstyle,
                            suffixText: 'dBi', suffixStyle: suffixstyle,  
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
                          snackBar = SnackBar(content: Text("Número de antenas de todo el sistema microondas.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          },
                        child: TextField(
                          controller: nAText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Antenas', labelStyle: textstyle,
                            hintText: 'Antenas', hintStyle: hintstyle,
                          ),
                        ), 
                      )
                    ),
                  
                    SizedBox(width: 10.0),

                    new Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Número de trayectorias de todo el sistema microondas.", textAlign: TextAlign.justify,),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, 
                            onPressed: (){ debugPrint("aceptar"); }),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: nTyText,
                          keyboardType: TextInputType.number,       
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Trayectorias', labelStyle: textstyle,
                            hintText: 'Trayectorias', hintStyle: hintstyle,            
                          ),
                        ),
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Distancia punto a punto del radioenlace microondas en kilómetros: enlace en línea de vista terrestre.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: distanciaText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'd', labelStyle: textstyle,
                            hintText: 'Distancia del enlace...', hintStyle: hintstyle,
                            suffixText: 'Km', suffixStyle: suffixstyle,
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
                            snackBar = SnackBar(content: Text("Frecuenia de transmisión microondas: frecuencia del enlace microondas en Gigahercios.", textAlign: TextAlign.justify),  
                              duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                              action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          },
                        child: TextField(
                          controller: fText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'F', labelStyle: textstyle, 
                            hintText: 'Frecuencia de transmisión...', hintStyle: hintstyle,
                            suffixText: 'GHz', suffixStyle: suffixstyle,  
                          ),
                        ), 
                      )
                    ) ,

                    SizedBox(width: 10.0),
                    //Padding(padding: const EdgeInsets.only(top: 15.0)),
                    
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Altura del sitio donde está ubicada la estación terrena de recepción (cerro) en metros (metros sobre el nivel del mar).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: msnmRxText,
                          keyboardType: TextInputType.number,                  
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Hsrx', labelStyle: textstyle, 
                            hintText: 'Altura del sitio de Rx...', hintStyle: hintstyle,
                            suffixText: 'm', suffixStyle: suffixstyle,  
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector( 
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Altura desde el suelo hasta el centro de la antena de recepción en metros (metros sobre el nivel del suelo).", textAlign: TextAlign.justify),
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: hRxText,
                          keyboardType: TextInputType.number, 
                          autofocus: true,     
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            //prefixIcon: const Icon(Icons.settings_input_antenna, color: Colors.green,),              
                            labelText: 'hRx', labelStyle: textstyle, 
                            hintText: 'Altura de la antena...', hintStyle: hintstyle, 
                            suffixText: 'm', suffixStyle: suffixstyle,                
                          ),
                        ),
                      ),
                    ),
                                    
    sizedbox,     ]
                ),
                padding,

                new Row(
                  children: <Widget>[ sizedbox, 
                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Longitud total en metros de la línea de transmisión (cable): desde la antena receptora hasta el receptor microondas.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: lCableRxText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'LCableRX', labelStyle: textstyle, 
                            hintText: 'Longitud de la línea de recepción...', hintStyle: hintstyle,
                            suffixText: 'm', suffixStyle: suffixstyle,
                          ),
                        ),
                      ) 
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Atenuación característica del cable de recepción por cada cien metros de cable [dB/100mts]: consultar al fabricante (Datasheet).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: aCableRxText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'αCableRX', labelStyle: textstyle,
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
                          snackBar = SnackBar(content: Text("Ganancia de la antena de recepción microondas.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: ganrxText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'GanRX', labelStyle: textstyle,
                            hintText: 'Ganancia de la antena de recepción...', hintStyle: hintstyle,
                            suffixText: 'dBi', suffixStyle: suffixstyle,
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
                          snackBar = SnackBar(content: Text("Temperatura de ruido equivalente del receptor en kelvin: normalmente se toma la temperatura de 290K (16,85°C).", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: trText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'Tr', labelStyle: textstyle,
                            hintText: 'Temperatura de ruido', hintStyle: hintstyle,
                            suffixText: 'K', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Ancho de banda de ruido en megahercios.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: bwnText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'nBW', labelStyle: textstyle,
                            hintText: 'Ancho de banda de ruido', hintStyle: hintstyle,
                            suffixText: 'MHz', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
                    ),

                    SizedBox(width: 10.0),

                    Flexible(
                      child: GestureDetector(
                        onDoubleTap: (){
                          snackBar = SnackBar(content: Text("Relación portadora a ruido en decibelios.", textAlign: TextAlign.justify),  
                            duration: Duration(seconds: 3), backgroundColor: Colors.blue,
                            action: new SnackBarAction(label: "ACEPTAR", textColor: Colors.white, onPressed: (){debugPrint("aceptar");}),
                          );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                        child: TextField(
                          controller: cnText,
                          keyboardType: TextInputType.number,                  
                          //obscureText: true,
                          decoration: InputDecoration(enabledBorder: enabledborder, border: outlineInputBorder,
                            labelText: 'C/N', labelStyle: textstyle,
                            hintText: 'Relación portadora a ruido', hintStyle: hintstyle,
                            suffixText: 'dB', suffixStyle: suffixstyle,
                          ),
                        ), 
                      )
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
              child: Icon(Icons.play_arrow), backgroundColor: Color(0xff0d2e44),

          ),
        );
      }

  Future<bool> createAlertDialog(BuildContext context) {
      return showDialog(context: context, builder: (context){
        return AlertDialog( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Center(child: Text('Detalles'.toUpperCase(), style: TextStyle(fontSize: 16),),),
          content: Container( height:450.0, width: 400.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: SingleChildScrollView( child: Column(
              children: <Widget>[

                //INICIO RESULTADOS//
                Padding(padding: const EdgeInsets.only(top: 10.0)),

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'GanTx: $gantxdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de video del canal, FMHZ, está a 1,25Mhz de LSF. PV = LSF[MHz] + 1.25MHz",
                  ),
                ),
                padding,
                
                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'GanRx: $ganrxdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La portadora de color del canal está a 4,83Mhz de LSF",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'PA: $hT m',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Altura total de la antena de transmisión.",
                  ),
                ),
                padding,
                
                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'E: $hR m',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Altura total de la antena de recepción.",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                   child: Tooltip( child: Center(
                   child: new Text(
                      'P. enlace: $penlace dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Permitividad del enlace: PRC[dBm] = dBm.",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'LFS: $lfs dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación en el espacio libre",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'FM: $fm dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación .",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αRamf: $aRamf dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Pérdidas por la ramificación: 10log(nTx/nCaras).",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αCable: $aCABLE dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia de transmisión en dBm",
                  ),
                ),
                padding,

                Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'N: $n dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia del sistema de transmisión",
                  ),
                ),

                 Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PTx: $ptxdBm dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia del sistema de transmisión",
                  ),
                ),
                padding,

                 Container(height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PTx: $ptxWatts W',
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
                        image: DecorationImage(image: AssetImage('images/uondas.jpg'), fit: BoxFit.cover),)
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
                      'GanTx: $gantxdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia de la antena de transmisión en decibelios.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                    child: new Text(
                      'GanRx: $ganrxdB dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia de la antena de recepción en decibelios.",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip(child: Center(
                    child: new Text(
                      'hT: $hT m',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La altura total en metros de la antena de transmisión (desde el nivel del mar).",
                  ),
                ),
                padding,
                
                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),
                  child: Tooltip( child: Center(
                   child: new Text(
                      'hR: $hR m',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "La altura total en metros de la antena de recepción (desde el nivel del mar).",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'P. enlace: $penlace Km' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Permitividad del enlace: el resultado es en kilómetros.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'LFS: $lfs dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ),), 
                    message: "Atenuación en el espacio libre: pérdidas de trayectoria en el espacio libre.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'FM: $fm dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Margen de desvanecimiento.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                 child: Tooltip( child: Center(
                   child: new Text(
                      'αRamf: $aRamf dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Pérdidas por ramificación del sistema: No. Antenas + No. Trayectorias.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'αCable: $aCABLE dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Atenuación total del cableado del sistema microondas.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),  
                  child: Tooltip( child: Center(
                   child: new Text(
                      'N: $n dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia de ruido de banda ancha en la entrada del receptor: capacidad del receptor de recibir señales de baja intensidad y amplificarlas.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),  
                  child: Tooltip( child: Center(
                   child: new Text(
                      'Cmin: $cmin dBm' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Umbral mínimo de la portadora en el receptor (potencia mínima de la portadora de banda ancha en la entrada del receptor - potencia mínima necesaria en el receptor desde la potencia de transmisión): sensibilidad del receptor.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0),  
                  child: Tooltip( child: Center(
                   child: new Text(
                      'Gsistema: $gsistema dB' ,
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Ganancia del sistema microondas.",
                  ),
                ),
                padding,

                Container(width: 300.0, height: heightRes, decoration: boxdecoration, padding: const EdgeInsets.all(5.0), 
                  child: Tooltip( child: Center(
                   child: new Text(
                      'PTX: $ptxWatts W',
                      style: textTextstyle // Theme.of(context).textTheme.display1,
                    ), ),
                    message: "Potencia mínima de la portadora transmisora: potencia del sistema de transmisión en vatios.",
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
                      style: TextStyle(fontSize: 13, letterSpacing: -0.3), textAlign: TextAlign.justify, // Theme.of(context).textTheme.display1,
                    ), 
                                           
        actions: <Widget>[
          MaterialButton(elevation: 5.0, child: Text('Aceptar'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: (){ Navigator.of(context).pop();}, )
        ],
      );
    });
  }


}