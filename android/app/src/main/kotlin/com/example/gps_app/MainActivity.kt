package com.example.gps_app

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.GnssStatus
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.gps_app/gnss"
    private val EVENT_CHANNEL = "com.example.gps_app/gnss_stream"
    private lateinit var locationManager: LocationManager
    private var gnssCallback: GnssStatus.Callback? = null
    private var locationListener: LocationListener? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        // Method Channel for one-time calls
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermissions" -> {
                    val hasPermission = checkLocationPermission()
                    result.success(hasPermission)
                }
                "getCurrentLocation" -> {
                    getCurrentLocation(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event Channel for streaming satellite and location data
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    startGnssUpdates(events)
                }

                override fun onCancel(arguments: Any?) {
                    stopGnssUpdates()
                }
            }
        )
    }

    private fun checkLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        if (!checkLocationPermission()) {
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        try {
            val location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            if (location != null) {
                val locationData = mapOf(
                    "latitude" to location.latitude,
                    "longitude" to location.longitude,
                    "altitude" to location.altitude,
                    "accuracy" to location.accuracy,
                    "timestamp" to location.time
                )
                result.success(locationData)
            } else {
                result.error("NO_LOCATION", "No location available", null)
            }
        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", e.message, null)
        }
    }

    private fun startGnssUpdates(events: EventChannel.EventSink?) {
        if (!checkLocationPermission() || events == null) {
            events?.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        try {
            // Location updates
            locationListener = object : LocationListener {
                override fun onLocationChanged(location: Location) {
                    val locationData = mapOf(
                        "type" to "location",
                        "latitude" to location.latitude,
                        "longitude" to location.longitude,
                        "altitude" to location.altitude,
                        "accuracy" to location.accuracy,
                        "speed" to location.speed,
                        "bearing" to location.bearing,
                        "timestamp" to location.time
                    )
                    events.success(locationData)
                }

                override fun onProviderEnabled(provider: String) {}
                override fun onProviderDisabled(provider: String) {}
            }

            locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                1000, // 1 second
                0f,   // 0 meters
                locationListener!!
            )

            // GNSS Status updates (satellite info)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                gnssCallback = object : GnssStatus.Callback() {
                    override fun onSatelliteStatusChanged(status: GnssStatus) {
                        val satellites = mutableListOf<Map<String, Any>>()
                        
                        for (i in 0 until status.satelliteCount) {
                            val constellationType = when (status.getConstellationType(i)) {
                                GnssStatus.CONSTELLATION_GPS -> "GPS"
                                GnssStatus.CONSTELLATION_GLONASS -> "GLONASS"
                                GnssStatus.CONSTELLATION_BEIDOU -> "BEIDOU"
                                GnssStatus.CONSTELLATION_GALILEO -> "GALILEO"
                                GnssStatus.CONSTELLATION_QZSS -> "QZSS"
                                GnssStatus.CONSTELLATION_SBAS -> "SBAS"
                                else -> "UNKNOWN"
                            }

                            satellites.add(
                                mapOf(
                                    "svid" to status.getSvid(i),
                                    "constellation" to constellationType,
                                    "cn0DbHz" to status.getCn0DbHz(i),
                                    "elevation" to status.getElevationDegrees(i),
                                    "azimuth" to status.getAzimuthDegrees(i),
                                    "hasEphemeris" to status.hasEphemerisData(i),
                                    "hasAlmanac" to status.hasAlmanacData(i),
                                    "usedInFix" to status.usedInFix(i)
                                )
                            )
                        }

                        val satelliteData = mapOf(
                            "type" to "satellites",
                            "satellites" to satellites,
                            "timestamp" to System.currentTimeMillis()
                        )
                        events.success(satelliteData)
                    }

                    override fun onStarted() {
                        events.success(mapOf("type" to "gnss_started"))
                    }

                    override fun onStopped() {
                        events.success(mapOf("type" to "gnss_stopped"))
                    }
                }
                locationManager.registerGnssStatusCallback(gnssCallback!!)
            }
        } catch (e: SecurityException) {
            events?.error("PERMISSION_DENIED", e.message, null)
        }
    }

    private fun stopGnssUpdates() {
        locationListener?.let {
            locationManager.removeUpdates(it)
            locationListener = null
        }

        gnssCallback?.let {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                locationManager.unregisterGnssStatusCallback(it)
            }
            gnssCallback = null
        }
    }

    override fun onDestroy() {
        stopGnssUpdates()
        super.onDestroy()
    }
}
