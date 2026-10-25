package com.eradio.app.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.eradio.app.ui.theme.NavyPrimary
import com.eradio.app.ui.theme.SuffixGreen
import kotlin.math.log10
import kotlin.math.pow
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.SettingsInputAntenna
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RadioTab(
    snackbarHostState: SnackbarHostState,
    viewModel: ProjectViewModel = androidx.lifecycle.viewmodel.compose.viewModel(),
    onShowResults: (String, List<Pair<String, String>>) -> Unit
) {
    val coroutineScope = rememberCoroutineScope()

    var fch by viewModel::fch
    var nTx by viewModel::nTx
    var nCaras by viewModel::nCaras
    var gantx by viewModel::gantx
    var zant by viewModel::zant
    var aDistribuidor by viewModel::aDistribuidor
    var aCable by viewModel::aCable
    var lCable by viewModel::lCable
    var ptx by viewModel::ptx
    var distancia by viewModel::distanciaRadio
    val niveles = viewModel.niveles
    var nivelSelected by viewModel::nivelSelected
    val bandas = viewModel.bandas
    var bandaSelected by viewModel::bandaSelected
    var resultN by viewModel::resultN

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

    fun calcular() {
        try {
            val calcResult = com.eradio.app.math.RadioMathEngine.calculateRadio(
                fch = fch,
                nTx = nTx,
                nCaras = nCaras,
                gantx = gantx,
                zant = zant,
                aDistribuidor = aDistribuidor,
                aCable = aCable,
                lCable = lCable,
                ptx = ptx,
                distancia = distancia,
                nivelSelected = nivelSelected,
                bandaSelected = bandaSelected
            )
            resultN = calcResult.nFormatted
            onShowResults("Resultados Radiodifusión", calcResult.displayResults)
        } catch (e: Exception) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("Error en el cálculo: verifique los datos ingresados.")
            }
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = { calcular() },
                containerColor = NavyPrimary,
                contentColor = Color.White,
                modifier = Modifier.testTag("calcular_radio_button")
            ) {
                Icon(
                    imageVector = Icons.Default.SettingsInputAntenna,
                    contentDescription = "Calcular Radio"
                )
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "NÚMERO DE ANTENAS (N)",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = resultN,
                fontSize = 28.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.secondary
            )

            Spacer(modifier = Modifier.height(16.dp))
            HorizontalDivider(color = Color.Blue, thickness = 2.dp)
            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "PARÁMETROS DEL SISTEMA",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(16.dp))

            // Fch, Transmisores, Caras
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = fch,
                    onValueChange = { fch = it },
                    label = { Text("Fch", fontSize = 12.sp) },
                    suffix = { Text("MHz", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Frecuencia lateral inferior del canal (LSF), VHF/UHF. Ingrese el valor en MHz.")
                )
                OutlinedTextField(
                    value = nTx,
                    onValueChange = { nTx = it },
                    label = { Text("Transmisores", fontSize = 12.sp) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Número de transmisores de RF a utilizar: normalmente sólo un (1) transmisor de TV VHF/UHF.")
                )
                OutlinedTextField(
                    value = nCaras,
                    onValueChange = { nCaras = it },
                    label = { Text("Caras", fontSize = 12.sp) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Número de bahias o caras: normalmente una (1) cara pero pueden ser más.")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Gantx, Zant, Divisor
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = gantx,
                    onValueChange = { gantx = it },
                    label = { Text("Gantx", fontSize = 12.sp) },
                    suffix = { Text("dB", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Ganancia de la(s) antena(s) a utilizar en el sistema. Normalmente tipo panel de 50 ohms para la radiodifución de la señal: Gantx[dB] = dBi + 2.14.")
                )
                OutlinedTextField(
                    value = zant,
                    onValueChange = { zant = it },
                    label = { Text("Zant", fontSize = 12.sp) },
                    suffix = { Text("Ω", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Impedancia de entrada de la(s) antena(s) [Ohms]. Normalmente 50 Ohms porque se necesita radiar la mayor cantidad de potencia para dar cubrimiento.")
                )
                OutlinedTextField(
                    value = aDistribuidor,
                    onValueChange = { aDistribuidor = it },
                    label = { Text("αDivisor", fontSize = 12.sp) },
                    suffix = { Text("dB", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Atenuación del distribuidor, repartidor o divisor de Alta Potencia (Pérdidas de inserción) [dB]. Consultar el DataSheet del fabricante. Puede o no existir un segundo distribuidor de Alta Potencia.")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // αCable, Longitud, PTX
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = aCable,
                    onValueChange = { aCable = it },
                    label = { Text("αCable/100m", fontSize = 12.sp) },
                    suffix = { Text("dB", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Atenuación del cable [dB/100mts]: consultar al fabricante (Datasheet).")
                )
                OutlinedTextField(
                    value = lCable,
                    onValueChange = { lCable = it },
                    label = { Text("Longitud", fontSize = 12.sp) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud del cable en metros. Longitud desde el TXRF(VHF/UHF) a la antena/distribuidor (con latiguillos). Linea de Transmisión Coaxial (50 Ohms) HELIAX@ ú otro Fabricante.")
                )
                OutlinedTextField(
                    value = ptx,
                    onValueChange = { ptx = it },
                    label = { Text("PTX", fontSize = 12.sp) },
                    suffix = { Text("Watts", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Potencia de transmisión en Vatios (Watts).")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Distancia, Nivel, Banda
            BoxWithConstraints(modifier = Modifier.fillMaxWidth()) {
                val totalRowWidth = maxWidth
                // 3 fields with two 8.dp gaps: available width per field is (totalRowWidth - 16.dp) / 3
                val fieldWidth = (totalRowWidth - 16.dp) / 3
                // Two-line mode activates when width does not allow full text "Nivel máximo" on 1 line
                val isTwoLineMode = fieldWidth < 140.dp
                val sharedFieldHeight = if (isTwoLineMode) 90.dp else 58.dp

                val textFontSize = when {
                    fieldWidth < 95.dp -> 11.sp
                    fieldWidth < 115.dp -> 12.sp
                    else -> 13.sp
                }
                val labelFontSize = when {
                    fieldWidth < 100.dp -> 10.sp
                    fieldWidth < 120.dp -> 11.sp
                    else -> 12.sp
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Distancia
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .fieldInfo(coroutineScope, snackbarHostState, "Distancia a cubrir hasta el punto más lejano [Km].")
                    ) {
                        OutlinedTextField(
                            value = distancia,
                            onValueChange = { distancia = it.replace("\n", "").filter { c -> c.isDigit() || c == '.' } },
                            label = { Text("Distancia", fontSize = labelFontSize, maxLines = 1, softWrap = false) },
                            suffix = { Text("Km", color = SuffixGreen, fontSize = if (fieldWidth < 100.dp) 10.sp else 11.sp, fontWeight = FontWeight.SemiBold) },
                            textStyle = LocalTextStyle.current.copy(
                                fontSize = textFontSize,
                                lineHeight = if (isTwoLineMode) (textFontSize.value + 4).sp else textFontSize
                            ),
                            singleLine = true,
                            maxLines = 1,
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                            shape = RoundedCornerShape(16.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(sharedFieldHeight)
                        )
                    }

                    // Dropdown Nivel
                    var expandedNivel by remember { mutableStateOf(false) }
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .fieldInfo(coroutineScope, snackbarHostState, "Nivel de intensidad de campo requerido según recomendación UIT-R. Nivel de servicio: nivel máximo o nivel mínimo para la banda de transmisión (I-V).")
                    ) {
                        ExposedDropdownMenuBox(
                            expanded = expandedNivel,
                            onExpandedChange = { expandedNivel = !expandedNivel },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            OutlinedTextField(
                                value = if (isTwoLineMode && nivelSelected.contains(" ")) {
                                    nivelSelected.replace(" ", "\n")
                                } else {
                                    nivelSelected
                                },
                                onValueChange = {},
                                readOnly = true,
                                singleLine = !isTwoLineMode,
                                minLines = if (isTwoLineMode) 2 else 1,
                                maxLines = if (isTwoLineMode) 2 else 1,
                                label = { Text("Nivel", fontSize = labelFontSize, maxLines = 1, softWrap = false) },
                                textStyle = LocalTextStyle.current.copy(
                                    fontSize = textFontSize,
                                    lineHeight = if (isTwoLineMode) (textFontSize.value + 4).sp else textFontSize
                                ),
                                trailingIcon = {
                                    ExposedDropdownMenuDefaults.TrailingIcon(
                                        expanded = expandedNivel,
                                        modifier = Modifier.size(if (fieldWidth < 110.dp) 20.dp else 24.dp)
                                    )
                                },
                                shape = RoundedCornerShape(16.dp),
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(sharedFieldHeight)
                                    .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                            )
                            ExposedDropdownMenu(
                                expanded = expandedNivel,
                                onDismissRequest = { expandedNivel = false }
                            ) {
                                niveles.forEach { item ->
                                    DropdownMenuItem(
                                        text = { Text(item) },
                                        onClick = {
                                            nivelSelected = item
                                            expandedNivel = false
                                        }
                                    )
                                }
                            }
                        }
                    }

                    // Dropdown Banda
                    var expandedBanda by remember { mutableStateOf(false) }
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .fieldInfo(coroutineScope, snackbarHostState, "Banda de frecuencia de radiodifusión (I, II, III, IV, V). Banda de transmisión (I-V) para el nivel de servicio: nivel máximo o nivel mínimo. Valor actual ($nivelSelected: $dBuV_m)")
                    ) {
                        ExposedDropdownMenuBox(
                            expanded = expandedBanda,
                            onExpandedChange = { expandedBanda = !expandedBanda },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            OutlinedTextField(
                                value = if (isTwoLineMode) "Banda\n$bandaSelected" else "Banda $bandaSelected",
                                onValueChange = {},
                                readOnly = true,
                                singleLine = !isTwoLineMode,
                                minLines = if (isTwoLineMode) 2 else 1,
                                maxLines = if (isTwoLineMode) 2 else 1,
                                label = { Text("Banda", fontSize = labelFontSize, maxLines = 1, softWrap = false) },
                                textStyle = LocalTextStyle.current.copy(
                                    fontSize = textFontSize,
                                    lineHeight = if (isTwoLineMode) (textFontSize.value + 4).sp else textFontSize
                                ),
                                trailingIcon = {
                                    ExposedDropdownMenuDefaults.TrailingIcon(
                                        expanded = expandedBanda,
                                        modifier = Modifier.size(if (fieldWidth < 110.dp) 20.dp else 24.dp)
                                    )
                                },
                                shape = RoundedCornerShape(16.dp),
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(sharedFieldHeight)
                                    .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                            )
                            ExposedDropdownMenu(
                                expanded = expandedBanda,
                                onDismissRequest = { expandedBanda = false }
                            ) {
                                bandas.forEach { item ->
                                    DropdownMenuItem(
                                        text = { Text("Banda $item") },
                                        onClick = {
                                            bandaSelected = item
                                            expandedBanda = false
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}
