package com.eradio.app.ui

import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.waitForUpOrCancellation
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHostState
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.input.pointer.pointerInput
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

fun Modifier.fieldInfo(
    coroutineScope: CoroutineScope,
    snackbarHostState: SnackbarHostState,
    description: String
): Modifier = this.pointerInput(description) {
    awaitEachGesture {
        awaitFirstDown(pass = PointerEventPass.Initial)
        // Wait for up or long-press timeout
        val up = withTimeoutOrNull(viewConfiguration.longPressTimeoutMillis) {
            waitForUpOrCancellation(pass = PointerEventPass.Initial)
        }
        if (up == null) {
            // Long press detected!
            coroutineScope.launch {
                snackbarHostState.currentSnackbarData?.dismiss()
                snackbarHostState.showSnackbar(
                    message = description,
                    actionLabel = "ACEPTAR",
                    duration = SnackbarDuration.Short
                )
            }
        } else {
            // Check for second tap (double tap)
            val secondDown = withTimeoutOrNull(viewConfiguration.doubleTapTimeoutMillis) {
                awaitFirstDown(pass = PointerEventPass.Initial)
            }
            if (secondDown != null) {
                // Double tap detected!
                coroutineScope.launch {
                    snackbarHostState.currentSnackbarData?.dismiss()
                    snackbarHostState.showSnackbar(
                        message = description,
                        actionLabel = "ACEPTAR",
                        duration = SnackbarDuration.Short
                    )
                }
            }
        }
    }
}
