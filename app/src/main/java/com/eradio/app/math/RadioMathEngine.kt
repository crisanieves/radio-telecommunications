package com.eradio.app.math

import java.util.Locale
import kotlin.math.*

/**
 * Motor de cálculos matemáticos para ingeniería de telecomunicaciones (eRadio).
 * Contiene las fórmulas exactas para Radiodifusión, Radioenlaces Microondas y Comunicaciones Satelitales.
 */
object RadioMathEngine {

    const val K_BOLTZMANN = 1.38e-23
    const val R_EARTH_KM = 6378.0

    /**
     * Parseo seguro de strings a Double soportando comas y puntos, con sanitización de longitud y NaN/Inf.
     */
    fun parseSafeDouble(value: String, default: Double): Double {
        if (value.isBlank()) return default
        // Limitar longitud para evitar overflow o ataques por saturación de entrada
        val sanitized = value.trim().take(30).replace(",", ".")
        val parsed = sanitized.toDoubleOrNull() ?: default
        return if (parsed.isNaN() || parsed.isInfinite()) default else parsed
    }

    // =========================================================================
    // 1. CÁLCULOS DE RADIODIFUSIÓN
    // =========================================================================
    data class RadioResult(
        val nAntenas: Double,
        val nFormatted: String,
        val pv: Double,
        val pc: Double,
        val pa: Double,
        val keRounded: Int,
        val prcdBm: Double,
        val aEldB: Double,
        val aCabledB: Double,
        val aDistribucion: Double,
        val ptxdBm: Double,
        val sGANTX: Double,
        val displayResults: List<Pair<String, String>>
    )

    fun calculateRadio(
        fch: String,
        nTx: String,
        nCaras: String,
        gantx: String,
        zant: String,
        aDistribuidor: String,
        aCable: String,
        lCable: String,
        ptx: String,
        distancia: String,
        nivelSelected: String,
        bandaSelected: String
    ): RadioResult {
        val lsfVal = parseSafeDouble(fch, 174.0)
        val nTxVal = maxOf(1.0, parseSafeDouble(nTx, 1.0))
        val nCarasVal = maxOf(1.0, parseSafeDouble(nCaras, 1.0))
        val gantxVal = parseSafeDouble(gantx, 10.0)
        val zantVal = maxOf(1.0, parseSafeDouble(zant, 50.0))
        val aDistVal = parseSafeDouble(aDistribuidor, 1.5)
        val aCableVal = parseSafeDouble(aCable, 2.5)
        val lCableVal = parseSafeDouble(lCable, 80.0)
        val ptxVal = maxOf(1.0, parseSafeDouble(ptx, 1000.0))
        val distVal = maxOf(0.1, parseSafeDouble(distancia, 25.0))

        val dBuV_m = if (nivelSelected == "Nivel máximo") {
            when (bandaSelected) {
                "I", "II" -> 80.0
                "III" -> 83.0
                "IV" -> 86.0
                else -> 91.0
            }
        } else {
            when (bandaSelected) {
                "I", "II" -> 48.0
                "III" -> 55.0
                "IV" -> 65.0
                else -> 70.0
            }
        }

        val pv = lsfVal + 1.25
        val pc = lsfVal + 4.83
        val pa = lsfVal + 5.75

        var kE = (-(10.0 * log10(zantVal))) + 30.0
        kE = ((kE * -1.0) + 120.0)
        val kERounded = Math.round(kE).toDouble()

        var x = pv * 1_000_000.0
        x = (2.0 * Math.PI * x) / 300_000_000.0
        x = kERounded + (20.0 * log10(maxOf(1e-12, x)))
        val prcdBm = dBuV_m - x

        val aELdB = 32.44 + (20.0 * log10(maxOf(0.1, pv))) + (20.0 * log10(distVal))
        val aCabledB = (lCableVal * aCableVal) / 100.0
        val aDistribucion = abs(10.0 * log10(nTxVal / nCarasVal))
        val ptxdBm = 10.0 * log10(ptxVal / 0.001)

        val sGANTX = prcdBm - ptxdBm + aCabledB + aELdB + aDistribucion + aDistVal
        val nVal = (sGANTX - gantxVal) / 10.0
        val nN = 10.0.pow(nVal)
        val nFormatted = String.format(Locale.US, "%.3f", nN)

        val displayList = listOf(
            "Número de antenas N" to nFormatted,
            "Portadora Video PV" to String.format(Locale.US, "%.2f MHz", pv),
            "Portadora Color PC" to String.format(Locale.US, "%.2f MHz", pc),
            "Portadora Audio PA" to String.format(Locale.US, "%.2f MHz", pa),
            "E (kE)" to "dBm + ${kERounded.toInt()}",
            "PRC (Sitio más lejano)" to String.format(Locale.US, "%.2f dBm", prcdBm),
            "αEL (Espacio libre)" to String.format(Locale.US, "%.2f dB", aELdB),
            "αCable (Atenuación cable)" to String.format(Locale.US, "%.2f dB", aCabledB),
            "αD (Pérdidas distribución)" to String.format(Locale.US, "%.2f dB", aDistribucion),
            "PTX (Potencia TX)" to String.format(Locale.US, "%.2f dBm", ptxdBm),
            "GAN TX (Ganancia sistema)" to String.format(Locale.US, "%.2f dB", sGANTX)
        )

        return RadioResult(
            nAntenas = nN,
            nFormatted = nFormatted,
            pv = pv,
            pc = pc,
            pa = pa,
            keRounded = kERounded.toInt(),
            prcdBm = prcdBm,
            aEldB = aELdB,
            aCabledB = aCabledB,
            aDistribucion = aDistribucion,
            ptxdBm = ptxdBm,
            sGANTX = sGANTX,
            displayResults = displayList
        )
    }

    // =========================================================================
    // 2. CÁLCULOS DE MICROONDAS
    // =========================================================================
    data class MicroondasResult(
        val ptxFormatted: String,
        val gantxdB: Double,
        val ganrxdB: Double,
        val hT: Double,
        val hR: Double,
        val penlace: Double,
        val lfs: Double,
        val fm: Double,
        val aCABLE: Double,
        val aRamf: Double,
        val cmin: Double,
        val gsistema: Double,
        val ptxdBm: Double,
        val ptxWatts: Double,
        val displayResults: List<Pair<String, String>>
    )

    fun calculateMicroondas(
        r: String,
        msnmTx: String,
        hTx: String,
        lCableTx: String,
        aCableTx: String,
        gantx: String,
        nA: String,
        nTy: String,
        distancia: String,
        f: String,
        msnmRx: String,
        hRx: String,
        lCableRx: String,
        aCableRx: String,
        ganrx: String,
        tr: String,
        bwn: String,
        cn: String,
        factorASelected: String,
        factorBSelected: String
    ): MicroondasResult {
        val fA = when (factorASelected) {
            "Sobre terreno liso, agua, plano" -> 4.0
            "Aspero montañoso" -> 0.25
            else -> 1.0
        }

        val fB = when (factorBSelected) {
            "Para un sitio lluvioso" -> 1.0
            "Areas calientes y humedas" -> 0.5
            "Para climas secos y montañosos" -> 0.125
            else -> 0.25
        }

        val rVal = minOf(99.999, maxOf(1.0, parseSafeDouble(r, 99.9)))
        val msnmTxVal = parseSafeDouble(msnmTx, 2600.0)
        val hTxVal = maxOf(1.0, parseSafeDouble(hTx, 30.0))
        val lCableTxVal = parseSafeDouble(lCableTx, 40.0)
        val aCableTxVal = parseSafeDouble(aCableTx, 5.5)
        val gantxVal = parseSafeDouble(gantx, 38.0)

        val nAVal = maxOf(1.0, parseSafeDouble(nA, 2.0))
        val nTyVal = maxOf(1.0, parseSafeDouble(nTy, 1.0))
        val distVal = maxOf(0.1, parseSafeDouble(distancia, 35.0))
        val fVal = maxOf(0.1, parseSafeDouble(f, 7.2))

        val msnmRxVal = parseSafeDouble(msnmRx, 2800.0)
        val hRxVal = maxOf(1.0, parseSafeDouble(hRx, 25.0))
        val lCableRxVal = parseSafeDouble(lCableRx, 35.0)
        val aCableRxVal = parseSafeDouble(aCableRx, 5.5)
        val ganrxVal = parseSafeDouble(ganrx, 38.0)

        val trVal = maxOf(1.0, parseSafeDouble(tr, 290.0))
        val bwnVal = maxOf(0.1, parseSafeDouble(bwn, 28.0))
        val cnVal = parseSafeDouble(cn, 25.0)

        val gantxdB = gantxVal + 2.14
        val ganrxdB = ganrxVal + 2.14

        val hT = msnmTxVal + hTxVal
        val hR = msnmRxVal + hRxVal
        val penlace = 4.07 * (sqrt(maxOf(0.0, hT)) + sqrt(maxOf(0.0, hR)))

        val lfs = 92.44 + (20.0 * log10(fVal)) + (20.0 * log10(distVal))

        val re = rVal / 100.0
        val logD = 30.0 * log10(distVal)
        val climatePart = 6.0 * fA * fB * fVal
        val combined = logD + (10.0 * log10(maxOf(1e-12, climatePart)))
        val logR = 10.0 * log10(maxOf(1e-12, 1.0 - re))
        val fm = combined - logR - 70.0

        val aCABLE = ((lCableTxVal * aCableTxVal) / 100.0) + ((lCableRxVal * aCableRxVal) / 100.0)
        val aRamf = nAVal + nTyVal

        val noiseBase = 10.0 * log10((K_BOLTZMANN * trVal) / 0.001)
        val n = noiseBase + (10.0 * log10(bwnVal * 1_000_000.0))

        val cmin = cnVal + n
        val gsistema = fm + lfs + aCABLE + aRamf - gantxdB - ganrxdB
        val ptxdBm = gsistema + cmin
        val ptxWatts = 10.0.pow(ptxdBm / 10.0) * 0.001

        val ptxFormatted = String.format(Locale.US, "%.2f dBm (%.4f W)", ptxdBm, ptxWatts)

        val displayList = listOf(
            "PTX Mínima" to ptxFormatted,
            "GanTx / GanRx" to String.format(Locale.US, "%.2f dB / %.2f dB", gantxdB, ganrxdB),
            "HT / HR" to String.format(Locale.US, "%.1f m / %.1f m", hT, hR),
            "Horizonte óptico" to String.format(Locale.US, "%.2f Km", penlace),
            "LFS (Espacio libre)" to String.format(Locale.US, "%.2f dB", lfs),
            "FM (Margen desvanecimiento)" to String.format(Locale.US, "%.2f dB", fm),
            "αCable (Total)" to String.format(Locale.US, "%.2f dB", aCABLE),
            "αRamf (Ramificación)" to String.format(Locale.US, "%.2f dB", aRamf),
            "N (Ruido receptor)" to String.format(Locale.US, "%.2f dBm", n),
            "Cmin (Umbral receptor)" to String.format(Locale.US, "%.2f dBm", cmin),
            "GSISTEMA" to String.format(Locale.US, "%.2f dB", gsistema)
        )

        return MicroondasResult(
            ptxFormatted = ptxFormatted,
            gantxdB = gantxdB,
            ganrxdB = ganrxdB,
            hT = hT,
            hR = hR,
            penlace = penlace,
            lfs = lfs,
            fm = fm,
            aCABLE = aCABLE,
            aRamf = aRamf,
            cmin = cmin,
            gsistema = gsistema,
            ptxdBm = ptxdBm,
            ptxWatts = ptxWatts,
            displayResults = displayList
        )
    }

    // =========================================================================
    // 3. CÁLCULOS DE SATÉLITE
    // =========================================================================
    data class SateliteResult(
        val azimuthFormatted: String,
        val elevationFormatted: String,
        val azimuth: Double,
        val elevacion: Double,
        val dKm: Double,
        val lfs: Double,
        val displayResults: List<Pair<String, String>>
    )

    fun calculateCoordinateDec(deg: String, min: String, sec: String, defaultDeg: Double, defaultMin: Double, defaultSec: Double): Double {
        val g = abs(parseSafeDouble(deg, defaultDeg))
        val m = abs(parseSafeDouble(min, defaultMin))
        val s = abs(parseSafeDouble(sec, defaultSec))
        return g + (m / 60.0) + (s / 3600.0)
    }

    fun calculateSatelite(
        h: String,
        fuplink: String,
        lonsat: String,
        latgtx: String,
        latmtx: String,
        latstx: String,
        longtx: String,
        lonmtx: String,
        lonstx: String,
        oeSatSelected: String,
        latSelected: String,
        lonSelected: String
    ): SateliteResult {
        val hVal = maxOf(100.0, parseSafeDouble(h, 35786.0))
        val fuplinkVal = maxOf(0.1, parseSafeDouble(fuplink, 6.095))
        val lonsatVal = abs(parseSafeDouble(lonsat, 70.0))

        val latGVal = abs(parseSafeDouble(latgtx, 4.0))
        val latMVal = abs(parseSafeDouble(latmtx, 35.0))
        val latSVal = abs(parseSafeDouble(latstx, 56.0))

        val lonGVal = abs(parseSafeDouble(longtx, 74.0))
        val lonMVal = abs(parseSafeDouble(lonmtx, 4.0))
        val lonSVal = abs(parseSafeDouble(lonstx, 51.0))

        var latTx = latGVal + (latMVal / 60.0) + (latSVal / 3600.0)
        var lonTx = lonGVal + (lonMVal / 60.0) + (lonSVal / 3600.0)

        if (latSelected == "Sur") latTx = -latTx
        if (latTx == 0.0) latTx = 1e-12

        val calcLonTx = if (lonSelected == "Este") 360.0 - lonTx else lonTx
        val calcLonSat = if (oeSatSelected == "Este") 360.0 - lonsatVal else lonsatVal

        val qdtx = calcLonSat - calcLonTx

        val qdrad = (qdtx * Math.PI) / 180.0
        val wo = (latTx * Math.PI) / 180.0

        val azRad = atan(tan(qdrad) / sin(wo))
        var azimuth = (azRad * 180.0 / Math.PI) + 180.0
        while (azimuth < 0.0) azimuth += 360.0
        while (azimuth >= 360.0) azimuth -= 360.0

        var cosX = cos(wo) * cos(qdrad)
        cosX = cosX.coerceIn(-1.0, 1.0)
        val acosXRad = acos(cosX)
        val xDeg = (acosXRad * 180.0) / Math.PI

        val sinAcos = maxOf(1e-12, sin(acosXRad))
        val elvRatio = (R_EARTH_KM / (R_EARTH_KM + hVal)) * (1.0 / sinAcos)
        val tanAcos = tan(acosXRad)
        val cotX = if (abs(tanAcos) < 1e-12) 0.0 else 1.0 / tanAcos
        val elvVal = cotX - elvRatio
        val elevacion = atan(elvVal) * 180.0 / Math.PI

        val dFactor = 1.0 - (cos(wo) * cos(qdrad))
        val d = hVal * sqrt(maxOf(0.0, 1.0 + (0.42 * dFactor)))

        val lfs = 92.44 + (20.0 * log10(maxOf(0.1, d))) + (20.0 * log10(fuplinkVal))

        val azimuthFormatted = String.format(Locale.US, "%.2f°", azimuth)
        val elevationFormatted = String.format(Locale.US, "%.2f°", elevacion)

        val displayList = listOf(
            "Azimuth" to azimuthFormatted,
            "Elevación" to elevationFormatted,
            "LatTx (Decimal)" to String.format(Locale.US, "%.4f° %s", latTx, latSelected),
            "LonTx (Decimal)" to String.format(Locale.US, "%.4f° %s", lonTx, lonSelected),
            "Qd (Δ Longitud)" to String.format(Locale.US, "%.2f°", qdtx),
            "Ángulo X" to String.format(Locale.US, "%.2f°", xDeg),
            "Distancia real d" to String.format(Locale.US, "%.1f Km", d),
            "LFS (Espacio libre)" to String.format(Locale.US, "%.2f dB", lfs)
        )

        return SateliteResult(
            azimuthFormatted = azimuthFormatted,
            elevationFormatted = elevationFormatted,
            azimuth = azimuth,
            elevacion = elevacion,
            dKm = d,
            lfs = lfs,
            displayResults = displayList
        )
    }
}
