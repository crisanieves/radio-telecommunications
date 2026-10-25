package com.eradio.app

import com.eradio.app.math.RadioMathEngine
import org.junit.Assert.*
import org.junit.Test

class ExampleUnitTest {

    @Test
    fun testRadioCalculationsBenchmark() {
        val result = RadioMathEngine.calculateRadio(
            fch = "174",
            nTx = "1",
            nCaras = "1",
            gantx = "10",
            zant = "50",
            aDistribuidor = "1.5",
            aCable = "2.5",
            lCable = "80",
            ptx = "1000",
            distancia = "25",
            nivelSelected = "Nivel máximo",
            bandaSelected = "III"
        )

        // Verificaciones matemáticas exactas
        assertEquals(175.25, result.pv, 0.001)
        assertEquals(178.83, result.pc, 0.001)
        assertEquals(179.75, result.pa, 0.001)
        assertEquals(107, result.keRounded)
        assertEquals(2.0, result.aCabledB, 0.001)
        assertEquals(0.0, result.aDistribucion, 0.001)
        assertEquals(60.0, result.ptxdBm, 0.001)
        assertTrue(result.prcdBm < 0.0)
        assertTrue(result.aEldB > 100.0)
        assertTrue(result.nAntenas > 0.0)
        assertNotNull(result.displayResults)
        assertEquals(11, result.displayResults.size)
    }

    @Test
    fun testRadioNivelMinimo() {
        val resultMin = RadioMathEngine.calculateRadio(
            fch = "174",
            nTx = "2",
            nCaras = "1",
            gantx = "12",
            zant = "75",
            aDistribuidor = "1.0",
            aCable = "2.0",
            lCable = "50",
            ptx = "500",
            distancia = "30",
            nivelSelected = "Nivel mínimo",
            bandaSelected = "IV"
        )
        assertTrue(resultMin.nAntenas > 0.0)
        assertTrue(resultMin.aDistribucion > 0.0)
    }

    @Test
    fun testMicroondasCalculationsBenchmark() {
        val result = RadioMathEngine.calculateMicroondas(
            r = "99.9",
            msnmTx = "2600",
            hTx = "30",
            lCableTx = "40",
            aCableTx = "5.5",
            gantx = "38",
            nA = "2",
            nTy = "1",
            distancia = "35",
            f = "7.2",
            msnmRx = "2800",
            hRx = "25",
            lCableRx = "35",
            aCableRx = "5.5",
            ganrx = "38",
            tr = "290",
            bwn = "28",
            cn = "25",
            factorASelected = "Promedio",
            factorBSelected = "Para climas promedios"
        )

        // Verificaciones matemáticas exactas
        assertEquals(40.14, result.gantxdB, 0.01)
        assertEquals(40.14, result.ganrxdB, 0.01)
        assertEquals(2630.0, result.hT, 0.1)
        assertEquals(2825.0, result.hR, 0.1)
        assertTrue(result.penlace > 400.0)
        assertTrue(result.lfs > 130.0)
        assertEquals(4.125, result.aCABLE, 0.01)
        assertEquals(3.0, result.aRamf, 0.01)
        assertTrue(result.fm > 0.0)
        assertTrue(result.cmin < 0.0)
        assertTrue(result.ptxWatts > 0.0)
        assertEquals(11, result.displayResults.size)
    }

    @Test
    fun testMicroondasClimateAndTerrainVariations() {
        val resultMountainRain = RadioMathEngine.calculateMicroondas(
            r = "99.99",
            msnmTx = "1500",
            hTx = "20",
            lCableTx = "30",
            aCableTx = "4.0",
            gantx = "35",
            nA = "1",
            nTy = "1",
            distancia = "20",
            f = "11.0",
            msnmRx = "1800",
            hRx = "20",
            lCableRx = "30",
            aCableRx = "4.0",
            ganrx = "35",
            tr = "300",
            bwn = "40",
            cn = "30",
            factorASelected = "Sobre terreno liso, agua, plano",
            factorBSelected = "Para un sitio lluvioso"
        )
        assertTrue(resultMountainRain.fm > 0.0)
        assertTrue(resultMountainRain.ptxdBm.isFinite())
    }

    @Test
    fun testSateliteCalculationsBenchmark() {
        val result = RadioMathEngine.calculateSatelite(
            h = "35786",
            fuplink = "6.095",
            lonsat = "70.0",
            latgtx = "4",
            latmtx = "35",
            latstx = "56",
            longtx = "74",
            lonmtx = "4",
            lonstx = "51",
            oeSatSelected = "Oeste",
            latSelected = "Norte",
            lonSelected = "Oeste"
        )

        // Verificaciones matemáticas exactas
        assertTrue(result.azimuth in 0.0..360.0)
        assertTrue(result.elevacion in 0.0..90.0)
        assertTrue(result.dKm > 35786.0)
        assertTrue(result.lfs > 190.0)
        assertEquals(8, result.displayResults.size)
    }

    @Test
    fun testSateliteHemisphereVariations() {
        val resultSurEste = RadioMathEngine.calculateSatelite(
            h = "35786",
            fuplink = "14.25",
            lonsat = "45.0",
            latgtx = "12",
            latmtx = "20",
            latstx = "0",
            longtx = "38",
            lonmtx = "15",
            lonstx = "0",
            oeSatSelected = "Este",
            latSelected = "Sur",
            lonSelected = "Este"
        )
        assertTrue(resultSurEste.azimuth in 0.0..360.0)
        assertTrue(resultSurEste.elevacion.isFinite())
        assertTrue(resultSurEste.dKm > 35000.0)
    }

    @Test
    fun testCybersecurityInputFuzzingAndSafety() {
        // Test con inputs maliciosos/extremos: strings infinitos, comas, negativos, caracteres inválidos
        val safeParsed1 = RadioMathEngine.parseSafeDouble("123,456", 0.0)
        assertEquals(123.456, safeParsed1, 0.0001)

        val safeParsed2 = RadioMathEngine.parseSafeDouble("".padStart(500, '9'), 10.0)
        assertTrue(safeParsed2.isFinite())

        val safeParsed3 = RadioMathEngine.parseSafeDouble("invalid_injection_payload", 42.0)
        assertEquals(42.0, safeParsed3, 0.0001)

        // Cálculo de Radio con datos corruptos no debe arrojar excepción
        val resultRadioCorrupt = RadioMathEngine.calculateRadio(
            fch = "invalid",
            nTx = "-10",
            nCaras = "0",
            gantx = "",
            zant = "0",
            aDistribuidor = "-5",
            aCable = "",
            lCable = "-100",
            ptx = "0",
            distancia = "0",
            nivelSelected = "Nivel máximo",
            bandaSelected = "I"
        )
        assertTrue(resultRadioCorrupt.nAntenas.isFinite())
        assertFalse(resultRadioCorrupt.nAntenas.isNaN())

        // Cálculo de Microondas con confiabilidad extrema r=100 (riesgo log(0)) no debe producir -Infinity o NaN
        val resultUondasCorrupt = RadioMathEngine.calculateMicroondas(
            r = "100.0",
            msnmTx = "-500",
            hTx = "0",
            lCableTx = "-10",
            aCableTx = "0",
            gantx = "0",
            nA = "0",
            nTy = "0",
            distancia = "0",
            f = "0",
            msnmRx = "0",
            hRx = "0",
            lCableRx = "0",
            aCableRx = "0",
            ganrx = "0",
            tr = "0",
            bwn = "0",
            cn = "0",
            factorASelected = "Desconocido",
            factorBSelected = "Desconocido"
        )
        assertTrue(resultUondasCorrupt.ptxdBm.isFinite())
        assertFalse(resultUondasCorrupt.ptxdBm.isNaN())

        // Cálculo de Satélite en el ecuador exacto lat=0 no debe producir división por 0
        val resultSatCorrupt = RadioMathEngine.calculateSatelite(
            h = "0",
            fuplink = "0",
            lonsat = "0",
            latgtx = "0",
            latmtx = "0",
            latstx = "0",
            longtx = "0",
            lonmtx = "0",
            lonstx = "0",
            oeSatSelected = "Oeste",
            latSelected = "Norte",
            lonSelected = "Oeste"
        )
        assertTrue(resultSatCorrupt.azimuth.isFinite())
        assertTrue(resultSatCorrupt.elevacion.isFinite())
        assertTrue(resultSatCorrupt.dKm.isFinite())
    }
}
