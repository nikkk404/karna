package com.example.cygiene_ui;

import android.content.Context;
import android.content.Intent;
import android.bluetooth.BluetoothAdapter;
import android.nfc.NfcAdapter;
import android.location.LocationManager;
import android.provider.Settings;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String SETTINGS_CHANNEL = "samples.flutter.dev/settings";
    private static final String BLUETOOTH_CHANNEL = "samples.flutter.dev/bluetooth";
    private static final String GPS_CHANNEL = "samples.flutter.dev/gps";
    private static final String NFC_CHANNEL = "samples.flutter.dev/nfc";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SETTINGS_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("navigateToSettings")) {
                        String setting = call.argument("setting");
                        navigateToSetting(setting);
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BLUETOOTH_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getBluetoothStatus")) {
                        Boolean bluetoothStatus = getBluetoothStatus();
                        result.success(bluetoothStatus);
                    } else {
                        result.notImplemented();
                    }
                });


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), GPS_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getGpsStatus")) {
                        Boolean gpsEnabled = getGpsStatus();
                        result.success(gpsEnabled);
                    } else {
                        result.notImplemented();
                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), NFC_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getNfcStatus")) {
                        Boolean nfcStatus = getNfcStatus();
                        result.success(nfcStatus);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void navigateToSetting(String setting) {
        Intent intent = null;
        switch (setting) {
            case "bluetooth":
                intent = new Intent(Settings.ACTION_BLUETOOTH_SETTINGS);
                break;
            case "location":
                intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                break;
            case "nfc":
                intent = new Intent(Settings.ACTION_NFC_SETTINGS);
                break;
            case "developer_options":
                intent = new Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS);
                break;
            case "screen_lock":
                intent = new Intent(Settings.ACTION_SECURITY_SETTINGS);
                break;
            default:
                System.out.println("Invalid setting: " + setting);
                return;
        }
        if (intent != null) {
            startActivity(intent);
        }
    }

    public boolean getBluetoothStatus() {
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        return bluetoothAdapter != null && bluetoothAdapter.isEnabled();
    }

    public boolean getGpsStatus() {
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        return locationManager != null && locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }

    public boolean getNfcStatus() {
        NfcAdapter nfcAdapter = NfcAdapter.getDefaultAdapter(this);
        return nfcAdapter != null && nfcAdapter.isEnabled();
    }
}