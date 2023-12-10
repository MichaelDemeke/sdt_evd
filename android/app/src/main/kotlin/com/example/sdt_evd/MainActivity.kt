package com.example.sdt_evd

import android.app.Activity
import android.app.Instrumentation.ActivityResult
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.*
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.content.Intent
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding.OnSaveInstanceStateListener
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "bluetooth_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanBluetoothDevices") {
                val devices = scanBluetoothDevices()
                result.success(devices)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun scanBluetoothDevices(): List<BluetoothDevice> {
        // Implement your Bluetooth scanning logic here
        // Return a list of Bluetooth devices as strings
        // Example:
       // val devices = listOf("Device 1", "Device 2", "Device 3")

        //return
    }
}
