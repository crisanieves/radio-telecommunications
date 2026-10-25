package com.eradio.app.ui

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.CompareArrows
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.SatelliteAlt
import androidx.compose.material.icons.filled.Save
import androidx.compose.material.icons.filled.Wifi
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.eradio.app.ui.theme.NavyPrimary
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProjectScreen(
    onNavigateBack: () -> Unit
) {
    BackHandler {
        onNavigateBack()
    }

    var selectedTabIndex by remember { mutableIntStateOf(0) }
    var showMenu by remember { mutableStateOf(false) }
    var showMapDialog by remember { mutableStateOf(false) }
    var showAboutDialog by remember { mutableStateOf(false) }
    var showHelpDialog by remember { mutableStateOf(false) }

    var resultsDialogData by remember { mutableStateOf<Pair<String, List<Pair<String, String>>>?>(null) }

    val projectViewModel: ProjectViewModel = androidx.lifecycle.viewmodel.compose.viewModel()
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    val tabs = listOf(
        Triple("RADIO", Icons.Default.Wifi, "tab_radio"),
        Triple("μONDAS", Icons.AutoMirrored.Filled.CompareArrows, "tab_microondas"),
        Triple("SATÉLITE", Icons.Default.SatelliteAlt, "tab_satelite")
    )

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        topBar = {
            Column {
                TopAppBar(
                    title = {
                        Text(
                            text = "eRadio",
                            color = Color.White,
                            fontWeight = FontWeight.Bold
                        )
                    },
                    navigationIcon = {
                        IconButton(
                            onClick = onNavigateBack,
                            modifier = Modifier.testTag("nav_back_button")
                        ) {
                            Icon(
                                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                                contentDescription = "Regresar",
                                tint = Color.White
                            )
                        }
                    },
                    actions = {
                        IconButton(
                            onClick = { showMapDialog = true },
                            modifier = Modifier.testTag("map_action_button")
                        ) {
                            Icon(
                                imageVector = Icons.Default.Map,
                                contentDescription = "Mapa del sistema radiado",
                                tint = Color.White
                            )
                        }
                        IconButton(
                            onClick = {
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar("Proyecto guardado correctamente.")
                                }
                            },
                            modifier = Modifier.testTag("save_action_button")
                        ) {
                            Icon(
                                imageVector = Icons.Default.Save,
                                contentDescription = "Guardar proyecto",
                                tint = Color.White
                            )
                        }
                        IconButton(
                            onClick = { showMenu = !showMenu },
                            modifier = Modifier.testTag("menu_action_button")
                        ) {
                            Icon(
                                imageVector = Icons.Default.MoreVert,
                                contentDescription = "Información",
                                tint = Color.White
                            )
                        }
                        DropdownMenu(
                            expanded = showMenu,
                            onDismissRequest = { showMenu = false }
                        ) {
                            DropdownMenuItem(
                                text = { Text("Ayuda", fontWeight = FontWeight.Medium) },
                                onClick = {
                                    showMenu = false
                                    showHelpDialog = true
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Acerca de", fontWeight = FontWeight.Medium) },
                                onClick = {
                                    showMenu = false
                                    showAboutDialog = true
                                }
                            )
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = NavyPrimary,
                        titleContentColor = Color.White
                    )
                )

                PrimaryTabRow(
                    selectedTabIndex = selectedTabIndex,
                    containerColor = NavyPrimary,
                    contentColor = Color.White,
                    indicator = {
                        TabRowDefaults.PrimaryIndicator(
                            modifier = Modifier.tabIndicatorOffset(selectedTabIndex),
                            color = Color.White,
                            height = 3.dp
                        )
                    }
                ) {
                    tabs.forEachIndexed { index, (title, icon, testTag) ->
                        Tab(
                            selected = selectedTabIndex == index,
                            onClick = { selectedTabIndex = index },
                            text = {
                                Text(
                                    text = title,
                                    fontWeight = if (selectedTabIndex == index) FontWeight.Bold else FontWeight.Normal,
                                    fontSize = 13.sp
                                )
                            },
                            icon = {
                                Icon(
                                    imageVector = icon,
                                    contentDescription = title,
                                    modifier = Modifier.size(20.dp)
                                )
                            },
                            selectedContentColor = Color.White,
                            unselectedContentColor = Color.White.copy(alpha = 0.7f),
                            modifier = Modifier.testTag(testTag)
                        )
                    }
                }
            }
        }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            when (selectedTabIndex) {
                0 -> RadioTab(
                    snackbarHostState = snackbarHostState,
                    viewModel = projectViewModel,
                    onShowResults = { title, results ->
                        resultsDialogData = title to results
                    }
                )
                1 -> MicroondasTab(
                    snackbarHostState = snackbarHostState,
                    viewModel = projectViewModel,
                    onShowResults = { title, results ->
                        resultsDialogData = title to results
                    }
                )
                2 -> SateliteTab(
                    snackbarHostState = snackbarHostState,
                    viewModel = projectViewModel,
                    onShowResults = { title, results ->
                        resultsDialogData = title to results
                    }
                )
            }
        }
    }

    if (showMapDialog) {
        MapDialog(
            tabIndex = selectedTabIndex,
            onDismiss = { showMapDialog = false }
        )
    }

    if (showAboutDialog) {
        AboutDialog(
            onDismiss = { showAboutDialog = false }
        )
    }

    if (showHelpDialog) {
        HelpDialog(
            onDismiss = { showHelpDialog = false }
        )
    }

    resultsDialogData?.let { (title, results) ->
        ResultsDialog(
            title = title,
            results = results,
            onDismiss = { resultsDialogData = null }
        )
    }
}
