class SatelliteInfo {
  final int svid;
  final String constellation;
  final double cn0DbHz;
  final double elevation;
  final double azimuth;
  final bool hasEphemeris;
  final bool hasAlmanac;
  final bool usedInFix;

  SatelliteInfo({
    required this.svid,
    required this.constellation,
    required this.cn0DbHz,
    required this.elevation,
    required this.azimuth,
    required this.hasEphemeris,
    required this.hasAlmanac,
    required this.usedInFix,
  });

  factory SatelliteInfo.fromMap(Map<dynamic, dynamic> map) {
    return SatelliteInfo(
      svid: map['svid'] as int,
      constellation: map['constellation'] as String,
      cn0DbHz: (map['cn0DbHz'] as num).toDouble(),
      elevation: (map['elevation'] as num).toDouble(),
      azimuth: (map['azimuth'] as num).toDouble(),
      hasEphemeris: map['hasEphemeris'] as bool,
      hasAlmanac: map['hasAlmanac'] as bool,
      usedInFix: map['usedInFix'] as bool,
    );
  }
}
