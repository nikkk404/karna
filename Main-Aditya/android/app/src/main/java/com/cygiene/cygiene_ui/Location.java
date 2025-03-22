// package com.example.Karna_ui;
// import android.content.Context;
// import android.bluetooth.BluetoothAdapter;

// import androidx.annotation.NonNull;
// import android.location.LocationManager ;
// import androidx.core.location.LocationManagerCompat;
// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.plugin.common.MethodChannel;


// public class Location extends FlutterActivity {
//     public static final String LOCATION_CHANNEL = "samples.flutter.dev/bluetooth";

//     @Override
//     public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//         super.configureFlutterEngine(flutterEngine);
//         new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), LOCATION_CHANNEL)
//                 .setMethodCallHandler(
//                         (call, result) ->{

//                             if (call.method.equals("getGpsStatus")) {    
//                             java.lang.Boolean gpsStatus = getGpsStatus();
//                             result.success(gpsStatus);
//                                 result.notImplemented();
//                                 return;

//                             }}
//                 );
//     }
//     public boolean getGpsStatus() {
//         LocationManager lm = (LocationManager)
//                 getSystemService(Context.LOCATION_SERVICE);
//         boolean gps_enabled = false;
//         // System.out.println("gps is enabled" + gps_enabled);

//         try {
//             gps_enabled = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
//             System.out.println("gps is enabled" + gps_enabled);
//         } catch (Exception e) {
//             e.printStackTrace();
//         }
//         return gps_enabled;
//         // boolean bluetoothStatus = false;

//         // BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//         // if (mBluetoothAdapter == null) {
//         //     // Device does not support Bluetooth
//         // } else if (!mBluetoothAdapter.isEnabled()) {
//         //     System.out.println("bluetooth is currently off");
//         //     // Bluetooth is not enabled :)
//         // } else {
//         //     System.out.println("bluetooth is on by users");
//         //         bluetoothStatus=true;  
//         //     // else{
//         //     //     System.out.println("hii I am vivek")
//         //     // }
//         //     // Bluetooth is enabled
//         // }                               
// //        else{
// //            result.error("Unavailable", "Blu status is not available", null);
// //        }
//         // return bluetoothStatus;
//     }
// }





