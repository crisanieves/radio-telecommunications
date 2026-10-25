package com.eradio.app

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import com.eradio.app.ui.ProjectViewModel
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [36])
class ExampleRobolectricTest {

  @Test
  fun `read string from context`() {
    val context = ApplicationProvider.getApplicationContext<Context>()
    val appName = context.getString(R.string.app_name)
    assertEquals("eRadio", appName)
  }

  @Test
  fun `viewmodel initial state is valid`() {
    val vm = ProjectViewModel()
    // Radio defaults
    assertEquals("174", vm.fch)
    assertEquals("1", vm.nTx)
    assertEquals("1", vm.nCaras)
    assertEquals("10", vm.gantx)
    assertEquals("50", vm.zant)
    assertEquals("1000", vm.ptx)
    // Microondas defaults
    assertEquals("99.9", vm.r)
    assertEquals("2600", vm.msnmTx)
    assertEquals("7.2", vm.f)
    // Satelite defaults
    assertEquals("35786", vm.h)
    assertEquals("6.095", vm.fuplink)
    assertEquals("70.0", vm.lonsat)
  }
}
