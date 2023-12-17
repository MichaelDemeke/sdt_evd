package com.example.sdt_evd

import android.app.Activity
import android.Manifest
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
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat


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
        val bluetoothDevices: MutableList<BluetoothDevice> = mutableListOf()

        // Check if the necessary permission is granted
        if (ContextCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.BLUETOOTH
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()

            // Check if Bluetooth is supported on the device
            if (bluetoothAdapter != null) {
                // Check if Bluetooth is enabled
                if (bluetoothAdapter.isEnabled) {
                    val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter.bondedDevices

                    pairedDevices?.forEach { device ->
                        bluetoothDevices.add(device)
                    }
                } else {
                    // Bluetooth is disabled, handle accordingly
                }
            } else {
                // Bluetooth is not supported on the device, handle accordingly
            }
        } else {
            // Permission is not granted, handle accordingly
        }

        return bluetoothDevices
    }
}
