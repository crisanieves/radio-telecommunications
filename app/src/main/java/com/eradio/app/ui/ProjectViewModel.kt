package com.eradio.app.ui

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel

class ProjectViewModel : ViewModel() {

    // ==========================================
    // RADIO TAB STATE
    // ==========================================
    var fch by mutableStateOf("174")
    var nTx by mutableStateOf("1")
    var nCaras by mutableStateOf("1")
    var gantx by mutableStateOf("10")
    var zant by mutableStateOf("50")
    var aDistribuidor by mutableStateOf("1.5")
    var aCable by mutableStateOf("2.5")
    var lCable by mutableStateOf("80")
    var ptx by mutableStateOf("1000")
    var distanciaRadio by mutableStateOf("25")

    val niveles = listOf("Nivel máximo", "Nivel mínimo")
    var nivelSelected by mutableStateOf(niveles[0])

    val bandas = listOf("I", "II", "III", "IV", "V")
    var bandaSelected by mutableStateOf(bandas[2])

    var resultN by mutableStateOf("0.0")

    // ==========================================
    // MICROONDAS TAB STATE
    // ==========================================
    var r by mutableStateOf("99.9")
    var msnmTx by mutableStateOf("2600")
    var hTx by mutableStateOf("30")
    var lCableTx by mutableStateOf("40")
    var aCableTx by mutableStateOf("5.5")
    var gantxUondas by mutableStateOf("38")

    var nA by mutableStateOf("2")
    var nTy by mutableStateOf("1")
    var distanciaUondas by mutableStateOf("35")
    var f by mutableStateOf("7.2")

    var msnmRx by mutableStateOf("2800")
    var hRx by mutableStateOf("25")
    var lCableRx by mutableStateOf("35")
    var aCableRx by mutableStateOf("5.5")
    var ganrx by mutableStateOf("38")

    var tr by mutableStateOf("290")
    var bwn by mutableStateOf("28")
    var cn by mutableStateOf("25")

    val factoresB = listOf(
        "Para climas promedios",
        "Para un sitio lluvioso",
        "Areas calientes y humedas",
        "Para climas secos y montañosos"
    )
    var factorBSelected by mutableStateOf(factoresB[0])

    val factoresA = listOf(
        "Promedio",
        "Sobre terreno liso, agua, plano",
        "Aspero montañoso"
    )
    var factorASelected by mutableStateOf(factoresA[0])

    var resultPtx by mutableStateOf("0.0 dBm")

    // ==========================================
    // SATELITE TAB STATE
    // ==========================================
    var h by mutableStateOf("35786")
    var fuplink by mutableStateOf("6.095")
    var lonsat by mutableStateOf("70.0")

    var latgtx by mutableStateOf("4")
    var latmtx by mutableStateOf("35")
    var latstx by mutableStateOf("56")

    var longtx by mutableStateOf("74")
    var lonmtx by mutableStateOf("4")
    var lonstx by mutableStateOf("51")

    val oeList = listOf("Oeste", "Este")
    var oeSatSelected by mutableStateOf(oeList[0])

    val latList = listOf("Norte", "Sur")
    var latSelected by mutableStateOf(latList[0])

    val lonList = listOf("Oeste", "Este")
    var lonSelected by mutableStateOf(lonList[0])

    var resultAzimuth by mutableStateOf("0.0°")
    var resultElevation by mutableStateOf("0.0°")
}
