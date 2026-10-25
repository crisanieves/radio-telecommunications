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
import kotlin.math.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.SatelliteAlt
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SateliteTab(
    snackbarHostState: SnackbarHostState,
    viewModel: ProjectViewModel = androidx.lifecycle.viewmodel.compose.viewModel(),
    onShowResults: (String, List<Pair<String, String>>) -> Unit
) {
    val coroutineScope = rememberCoroutineScope()

    var h by viewModel::h
    var fuplink by viewModel::fuplink
    var lonsat by viewModel::lonsat

    var latgtx by viewModel::latgtx
    var latmtx by viewModel::latmtx
    var latstx by viewModel::latstx

    var longtx by viewModel::longtx
    var lonmtx by viewModel::lonmtx
    var lonstx by viewModel::lonstx

    val oeList = viewModel.oeList
    var oeSatSelected by viewModel::oeSatSelected

    val latList = viewModel.latList
    var latSelected by viewModel::latSelected

    val lonList = viewModel.lonList
    var lonSelected by viewModel::lonSelected

    var resultAzimuth by viewModel::resultAzimuth
    var resultElevation by viewModel::resultElevation

    val lattx = remember(latgtx, latmtx, latstx) {
        val dec = com.eradio.app.math.RadioMathEngine.calculateCoordinateDec(latgtx, latmtx, latstx, 4.0, 35.0, 56.0)
        String.format(java.util.Locale.US, "%.4f°", dec)
    }

    val lontx = remember(longtx, lonmtx, lonstx) {
        val dec = com.eradio.app.math.RadioMathEngine.calculateCoordinateDec(longtx, lonmtx, lonstx, 74.0, 4.0, 51.0)
        String.format(java.util.Locale.US, "%.4f°", dec)
    }

    fun calcular() {
        try {
            val calcResult = com.eradio.app.math.RadioMathEngine.calculateSatelite(
                h = h,
                fuplink = fuplink,
                lonsat = lonsat,
                latgtx = latgtx,
                latmtx = latmtx,
                latstx = latstx,
                longtx = longtx,
                lonmtx = lonmtx,
                lonstx = lonstx,
                oeSatSelected = oeSatSelected,
                latSelected = latSelected,
                lonSelected = lonSelected
            )
            resultAzimuth = calcResult.azimuthFormatted
            resultElevation = calcResult.elevationFormatted
            onShowResults("Resultados Enlace Satelital", calcResult.displayResults)
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
                modifier = Modifier.testTag("calcular_satelite_button")
            ) {
                Icon(
                    imageVector = Icons.Default.SatelliteAlt,
                    contentDescription = "Calcular Satélite"
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
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "AZIMUTH",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = resultAzimuth,
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.secondary
                    )
                }

                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "ELEVACIÓN",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = resultElevation,
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.secondary
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))
            HorizontalDivider(color = Color.Blue, thickness = 2.dp)
            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "PARÁMETROS DEL SATÉLITE",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(16.dp))

            // Altura h, F.link, Satélite Longitud, Oeste/Este
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = h,
                    onValueChange = { h = it },
                    label = { Text("h", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("Km", color = SuffixGreen, fontSize = 11.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Altura orbital del satélite geoestacionario en Km (ej: 35786 Km). Distancia desde el punto del lanzamiento en la Tierra (fabricante).")
                )
                OutlinedTextField(
                    value = fuplink,
                    onValueChange = { fuplink = it },
                    label = { Text("F.link", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("GHz", color = SuffixGreen, fontSize = 10.sp, fontWeight = FontWeight.SemiBold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Enlace de subida o bajada (Uplink/Downlink Frecuency): la frecuencia de subida/bajada depende de la banda y el canal del satélite. Ejemplo:\nFuplink → Banda C (5.925GHz - 6.425GHz), Banda Ku...\nFdownlink → Banda C (3.760GHz - 4.200GHz), Banda Ku...")
                )
                OutlinedTextField(
                    value = lonsat,
                    onValueChange = { lonsat = it },
                    label = { Text("Sat(λ)", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("°", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Posición del satélite: longitud (λ) del satélite geoestacionario en el espacio en grados (°). Tener en cuenta la banda, el canal, la polarización, el EIRP y la huella del satélite.")
                )

                var expandedOe by remember { mutableStateOf(false) }
                BoxWithConstraints(modifier = Modifier.weight(1f)) {
                    val showShort = maxWidth < 110.dp
                    ExposedDropdownMenuBox(
                        expanded = expandedOe,
                        onExpandedChange = { expandedOe = !expandedOe },
                        modifier = Modifier
                            .fillMaxWidth()
                            .fieldInfo(coroutineScope, snackbarHostState, "Posición orbital del satélite (Oeste o Este de Greenwich). Longitud (λ) Oeste/Este ($lonsat $oeSatSelected). Nota: la longitud final debe ser oeste para los cálculos en Colombia.")
                    ) {
                        OutlinedTextField(
                            value = if (showShort) oeSatSelected.take(1) else oeSatSelected,
                            onValueChange = {},
                            readOnly = true,
                            singleLine = true,
                            maxLines = 1,
                            label = { Text(if (showShort) "Pos" else "Posición", fontSize = 11.sp, maxLines = 1) },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedOe) },
                            shape = RoundedCornerShape(12.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                        )
                        ExposedDropdownMenu(
                            expanded = expandedOe,
                            onDismissRequest = { expandedOe = false }
                        ) {
                            oeList.forEach { item ->
                                DropdownMenuItem(
                                    text = { Text("$item (${item.take(1)})", fontSize = 13.sp) },
                                    onClick = {
                                        oeSatSelected = item
                                        expandedOe = false
                                    }
                                )
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "COORDENADAS ESTACIÓN TERRENA",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(12.dp))

            // Latitud: Grados, Minutos, Segundos, Norte/Sur
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = latgtx,
                    onValueChange = { latgtx = it },
                    label = { Text("Lat[°]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("°", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Latitud grados de la estación terrena. Latitud (φ) del sitio de transmisión/recepción: grados.")
                )
                OutlinedTextField(
                    value = latmtx,
                    onValueChange = { latmtx = it },
                    label = { Text("Lat[min]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("′", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Latitud minutos de la estación terrena. Latitud (φ) del sitio de transmisión/recepción: minutos.")
                )
                OutlinedTextField(
                    value = latstx,
                    onValueChange = { latstx = it },
                    label = { Text("Lat[seg]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("″", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Latitud segundos de la estación terrena. Latitud (φ) del sitio de transmisión/recepción: segundos.")
                )

                var expandedLat by remember { mutableStateOf(false) }
                BoxWithConstraints(modifier = Modifier.weight(1f)) {
                    val showShort = maxWidth < 110.dp
                    ExposedDropdownMenuBox(
                        expanded = expandedLat,
                        onExpandedChange = { expandedLat = !expandedLat },
                        modifier = Modifier
                            .fillMaxWidth()
                            .fieldInfo(coroutineScope, snackbarHostState, "Hemisferio de la estación terrena (Norte o Sur del Ecuador). Latitud (φ) de la estación terrena: ($lattx $latSelected).")
                    ) {
                        OutlinedTextField(
                            value = if (showShort) latSelected.take(1) else latSelected,
                            onValueChange = {},
                            readOnly = true,
                            singleLine = true,
                            maxLines = 1,
                            label = { Text(if (showShort) "Hem" else "Hemisferio", fontSize = 11.sp, maxLines = 1) },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedLat) },
                            shape = RoundedCornerShape(12.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                        )
                        ExposedDropdownMenu(
                            expanded = expandedLat,
                            onDismissRequest = { expandedLat = false }
                        ) {
                            latList.forEach { item ->
                                DropdownMenuItem(
                                    text = { Text("$item (${item.take(1)})", fontSize = 13.sp) },
                                    onClick = {
                                        latSelected = item
                                        expandedLat = false
                                    }
                                )
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Longitud: Grados, Minutos, Segundos, Oeste/Este
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = longtx,
                    onValueChange = { longtx = it },
                    label = { Text("Lon[°]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("°", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud grados de la estación terrena. Longitud (λ) del sitio de transmisión/recepción: grados.")
                )
                OutlinedTextField(
                    value = lonmtx,
                    onValueChange = { lonmtx = it },
                    label = { Text("Lon[min]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("′", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud minutos de la estación terrena. Longitud (λ) del sitio de transmisión/recepción: minutos.")
                )
                OutlinedTextField(
                    value = lonstx,
                    onValueChange = { lonstx = it },
                    label = { Text("Lon[seg]", fontSize = 11.sp, maxLines = 1) },
                    suffix = { Text("″", color = SuffixGreen, fontSize = 12.sp, fontWeight = FontWeight.Bold) },
                    singleLine = true,
                    maxLines = 1,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .fieldInfo(coroutineScope, snackbarHostState, "Longitud segundos de la estación terrena. Longitud (λ) del sitio de transmisión/recepción: segundos.")
                )

                var expandedLon by remember { mutableStateOf(false) }
                BoxWithConstraints(modifier = Modifier.weight(1f)) {
                    val showShort = maxWidth < 110.dp
                    ExposedDropdownMenuBox(
                        expanded = expandedLon,
                        onExpandedChange = { expandedLon = !expandedLon },
                        modifier = Modifier
                            .fillMaxWidth()
                            .fieldInfo(coroutineScope, snackbarHostState, "Orientación de la estación terrena (Oeste o Este de Greenwich). Longitud (λ) de la estación terrena: ($lontx $lonSelected).")
                    ) {
                        OutlinedTextField(
                            value = if (showShort) lonSelected.take(1) else lonSelected,
                            onValueChange = {},
                            readOnly = true,
                            singleLine = true,
                            maxLines = 1,
                            label = { Text(if (showShort) "Ori" else "Orientación", fontSize = 11.sp, maxLines = 1) },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedLon) },
                            shape = RoundedCornerShape(12.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                        )
                        ExposedDropdownMenu(
                            expanded = expandedLon,
                            onDismissRequest = { expandedLon = false }
                        ) {
                            lonList.forEach { item ->
                                DropdownMenuItem(
                                    text = { Text("$item (${item.take(1)})", fontSize = 13.sp) },
                                    onClick = {
                                        lonSelected = item
                                        expandedLon = false
                                    }
                                )
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}
