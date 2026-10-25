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
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.eradio.app.ui.theme.NavyPrimary
import com.eradio.app.ui.theme.SuffixGreen
import kotlin.math.log10
import kotlin.math.pow
import kotlin.math.sqrt
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MicroondasTab(
    snackbarHostState: SnackbarHostState,
    viewModel: ProjectViewModel = androidx.lifecycle.viewmodel.compose.viewModel(),
    onShowResults: (String, List<Pair<String, String>>) -> Unit
) {
    val coroutineScope = rememberCoroutineScope()

    var r by viewModel::r
    var msnmTx by viewModel::msnmTx
    var hTx by viewModel::hTx
    var lCableTx by viewModel::lCableTx
    var aCableTx by viewModel::aCableTx
    var gantx by viewModel::gantxUondas

    var nA by viewModel::nA
    var nTy by viewModel::nTy
    var distancia by viewModel::distanciaUondas
    var f by viewModel::f

    var msnmRx by viewModel::msnmRx
    var hRx by viewModel::hRx
    var lCableRx by viewModel::lCableRx
    var aCableRx by viewModel::aCableRx
    var ganrx by viewModel::ganrx

    var tr by viewModel::tr
    var bwn by viewModel::bwn
    var cn by viewModel::cn

    val factoresB = viewModel.factoresB
    var factorBSelected by viewModel::factorBSelected

    val factoresA = viewModel.factoresA
    var factorASelected by viewModel::factorASelected

    var resultPtx by viewModel::resultPtx

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

    fun calcular() {
        try {
            val calcResult = com.eradio.app.math.RadioMathEngine.calculateMicroondas(
                r = r,
                msnmTx = msnmTx,
                hTx = hTx,
                lCableTx = lCableTx,
                aCableTx = aCableTx,
                gantx = gantx,
                nA = nA,
                nTy = nTy,
                distancia = distancia,
                f = f,
                msnmRx = msnmRx,
                hRx = hRx,
                lCableRx = lCableRx,
                aCableRx = aCableRx,
                ganrx = ganrx,
                tr = tr,
                bwn = bwn,
                cn = cn,
                factorASelected = factorASelected,
                factorBSelected = factorBSelected
            )
            resultPtx = calcResult.ptxFormatted
            onShowResults("Resultados Microondas", calcResult.displayResults)
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
                modifier = Modifier.testTag("calcular_microondas_button")
            ) {
                Icon(
                    imageVector = Icons.Default.PlayArrow,
                    contentDescription = "Calcular Microondas"
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
                text = "POTENCIA TRANSMISORA",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = resultPtx,
                fontSize = 22.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.secondary
            )

            Spacer(modifier = Modifier.height(16.dp))
            HorizontalDivider(color = Color.Blue, thickness = 2.dp)
            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "PARÁMETROS DEL ENLACE",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(16.dp))

            // Factores Climático y Topográfico
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                var expandedB by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = expandedB,
                    onExpandedChange = { expandedB = !expandedB },
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Factor Climático B según Barnett-Vigants. Valor actual: $factorBSelected es $fB).")
                ) {
                    OutlinedTextField(
                        value = factorBSelected,
                        onValueChange = {},
                        readOnly = true,
                        minLines = 2,
                        maxLines = 2,
                        label = { Text("Factor B (Clima)", fontSize = 11.sp, maxLines = 1, overflow = TextOverflow.Ellipsis) },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedB) },
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                    )
                    ExposedDropdownMenu(
                        expanded = expandedB,
                        onDismissRequest = { expandedB = false }
                    ) {
                        factoresB.forEach { item ->
                            DropdownMenuItem(
                                text = { Text(item, fontSize = 13.sp) },
                                onClick = {
                                    factorBSelected = item
                                    expandedB = false
                                }
                            )
                        }
                    }
                }

                var expandedA by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = expandedA,
                    onExpandedChange = { expandedA = !expandedA },
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Factor topográfico A según Barnett-Vigants. Valor actual: $factorASelected es $fA)")
                ) {
                    OutlinedTextField(
                        value = factorASelected,
                        onValueChange = {},
                        readOnly = true,
                        minLines = 2,
                        maxLines = 2,
                        label = { Text("Factor A (Terreno)", fontSize = 11.sp, maxLines = 1, overflow = TextOverflow.Ellipsis) },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedA) },
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                    )
                    ExposedDropdownMenu(
                        expanded = expandedA,
                        onDismissRequest = { expandedA = false }
                    ) {
                        factoresA.forEach { item ->
                            DropdownMenuItem(
                                text = { Text(item, fontSize = 13.sp) },
                                onClick = {
                                    factorASelected = item
                                    expandedA = false
                                }
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Confiabilidad, Hstx, hTx
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = r,
                    onValueChange = { r = it },
                    label = { Text("R", fontSize = 12.sp) },
                    suffix = { Text("%", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Confiabilidad porcentual esperada del enlace (ej: 99.9%). Es un valor porcentual y normalmente es establecido al 99%.")
                )
                OutlinedTextField(
                    value = msnmTx,
                    onValueChange = { msnmTx = it },
                    label = { Text("Hstx", fontSize = 12.sp) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Altura del sitio donde está ubicada la estación terrena de transmisión (estudio) en metros (metros sobre el nivel del mar).")
                )
                OutlinedTextField(
                    value = hTx,
                    onValueChange = { hTx = it },
                    label = { Text("hTx", fontSize = 12.sp) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Altura desde el suelo hasta el centro de la antena de transmisión en metros (metros sobre el nivel del suelo).")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // CableTX, AtenuaciónTX, GanTX
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = lCableTx,
                    onValueChange = { lCableTx = it },
                    label = { Text("LCableTX", fontSize = 12.sp) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud total en metros de la línea de transmisión (cable): desde el transmisor microondas hasta la antena de transmisión.")
                )
                OutlinedTextField(
                    value = aCableTx,
                    onValueChange = { aCableTx = it },
                    label = { Text("αCableTX", fontSize = 12.sp) },
                    suffix = { Text("dB", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Atenuación/pérdida característica del cable de transmisión por cada cien metros de cable [dB/100mts]: consultar al fabricante (Datasheet).")
                )
                OutlinedTextField(
                    value = gantx,
                    onValueChange = { gantx = it },
                    label = { Text("GanTX", fontSize = 12.sp) },
                    suffix = { Text("dBi", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Ganancia de la antena de transmisión microondas [dBi].")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Antenas, Trayectorias, Distancia, Frecuencia
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = nA,
                    onValueChange = { nA = it },
                    label = { Text("Antenas", fontSize = 11.sp, maxLines = 1, softWrap = false) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(0.95f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Número de antenas totales del sistema microondas.")
                )
                OutlinedTextField(
                    value = nTy,
                    onValueChange = { nTy = it },
                    label = { Text("Trayectorias", fontSize = 10.sp, maxLines = 1, softWrap = false, overflow = TextOverflow.Ellipsis) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1.3f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Número de trayectorias totales del sistema microondas.")
                )
                OutlinedTextField(
                    value = distancia,
                    onValueChange = { distancia = it },
                    label = { Text("Dist.", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("Km", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(0.95f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Distancia punto a punto del radioenlace microondas en kilómetros: enlace en línea de vista terrestre.")
                )
                OutlinedTextField(
                    value = f,
                    onValueChange = { f = it },
                    label = { Text("F", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("GHz", color = SuffixGreen, fontSize = 10.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(0.9f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Frecuenia de transmisión microondas: frecuencia del enlace microondas en GHz (Gigahercios).")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Hsrx, hRx, CableRX, AtenuaciónRX, GanRX
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = msnmRx,
                    onValueChange = { msnmRx = it },
                    label = { Text("Hsrx", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Altura del sitio donde está ubicada la estación terrena de recepción (cerro) en metros (metros sobre el nivel del mar).")
                )
                OutlinedTextField(
                    value = hRx,
                    onValueChange = { hRx = it },
                    label = { Text("hRx", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Altura desde el suelo hasta el centro de la antena de recepción en metros (metros sobre el nivel del suelo)")
                )
                OutlinedTextField(
                    value = lCableRx,
                    onValueChange = { lCableRx = it },
                    label = { Text("LCableRX", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("m", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud total en metros de la línea de transmisión (cable): desde la antena receptora hasta el receptor microondas.")
                )
                OutlinedTextField(
                    value = ganrx,
                    onValueChange = { ganrx = it },
                    label = { Text("GanRX", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("dBi", color = SuffixGreen, fontSize = 10.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Ganancia de la antena de recepción microondas (dBi).")
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Tr, nBW, C/N
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = tr,
                    onValueChange = { tr = it },
                    label = { Text("Tr", fontSize = 12.sp) },
                    suffix = { Text("K", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Temperatura de ruido equivalente del receptor en kelvin (ruido térmico): normalmente se toma la temperatura de 290K (16,85°C).")
                )
                OutlinedTextField(
                    value = bwn,
                    onValueChange = { bwn = it },
                    label = { Text("nBW", fontSize = 12.sp) },
                    suffix = { Text("MHz", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Ancho de banda de ruido en MHz (Megahercios).")
                )
                OutlinedTextField(
                    value = cn,
                    onValueChange = { cn = it },
                    label = { Text("C/N", fontSize = 12.sp) },
                    suffix = { Text("dB", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Relación portadora a ruido mínima requerida en dB.")
                )
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}
