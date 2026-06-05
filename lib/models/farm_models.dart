class SensorData {
  final double ph;
  final double ppm;
  final double waterTemp;
  final double airTemp;
  final double humidity;
  final DateTime timestamp;

  SensorData({
    required this.ph,
    required this.ppm,
    required this.waterTemp,
    required this.airTemp,
    required this.humidity,
    required this.timestamp,
  });

  SensorData copyWith({
    double? ph,
    double? ppm,
    double? waterTemp,
    double? airTemp,
    double? humidity,
    DateTime? timestamp,
  }) {
    return SensorData(
      ph: ph ?? this.ph,
      ppm: ppm ?? this.ppm,
      waterTemp: waterTemp ?? this.waterTemp,
      airTemp: airTemp ?? this.airTemp,
      humidity: humidity ?? this.humidity,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class MotorStatus {
  final bool phUp;
  final bool phDown;
  final bool nutrisiA;
  final bool nutrisiB;
  final bool pump;

  MotorStatus({
    this.phUp = false,
    this.phDown = false,
    this.nutrisiA = false,
    this.nutrisiB = false,
    this.pump = true,
  });

  MotorStatus copyWith({
    bool? phUp,
    bool? phDown,
    bool? nutrisiA,
    bool? nutrisiB,
    bool? pump,
  }) {
    return MotorStatus(
      phUp: phUp ?? this.phUp,
      phDown: phDown ?? this.phDown,
      nutrisiA: nutrisiA ?? this.nutrisiA,
      nutrisiB: nutrisiB ?? this.nutrisiB,
      pump: pump ?? this.pump,
    );
  }
}

class VegetableCategory {
  final String name;
  final String emoji;
  final double phMin;
  final double phMax;
  final double ppmMin;
  final double ppmMax;
  final String description;

  const VegetableCategory({
    required this.name,
    required this.emoji,
    required this.phMin,
    required this.phMax,
    required this.ppmMin,
    required this.ppmMax,
    required this.description,
  });
}

class FarmSettings {
  final String mode; // 'auto' or 'manual'
  final VegetableCategory? selectedVegetable;
  final double targetPh;
  final double targetPpm;
  final double phTolerance;
  final double ppmTolerance;

  FarmSettings({
    this.mode = 'auto',
    this.selectedVegetable,
    this.targetPh = 6.5,
    this.targetPpm = 1200,
    this.phTolerance = 0.3,
    this.ppmTolerance = 100,
  });

  FarmSettings copyWith({
    String? mode,
    VegetableCategory? selectedVegetable,
    double? targetPh,
    double? targetPpm,
    double? phTolerance,
    double? ppmTolerance,
  }) {
    return FarmSettings(
      mode: mode ?? this.mode,
      selectedVegetable: selectedVegetable ?? this.selectedVegetable,
      targetPh: targetPh ?? this.targetPh,
      targetPpm: targetPpm ?? this.targetPpm,
      phTolerance: phTolerance ?? this.phTolerance,
      ppmTolerance: ppmTolerance ?? this.ppmTolerance,
    );
  }
}

// Preset vegetable data
const List<VegetableCategory> vegetables = [
  VegetableCategory(
    name: 'Selada',
    emoji: '🥬',
    phMin: 6.0,
    phMax: 7.0,
    ppmMin: 840,
    ppmMax: 1260,
    description: 'Lettuce - Ideal untuk pemula',
  ),
  VegetableCategory(
    name: 'Bayam',
    emoji: '🌿',
    phMin: 6.0,
    phMax: 7.0,
    ppmMin: 1260,
    ppmMax: 1610,
    description: 'Spinach - Kaya nutrisi',
  ),
  VegetableCategory(
    name: 'Kangkung',
    emoji: '🥦',
    phMin: 5.5,
    phMax: 6.5,
    ppmMin: 1400,
    ppmMax: 1680,
    description: 'Water Spinach - Cepat panen',
  ),
  VegetableCategory(
    name: 'Sawi',
    emoji: '🥗',
    phMin: 6.0,
    phMax: 7.0,
    ppmMin: 1050,
    ppmMax: 1400,
    description: 'Mustard Green - Populer lokal',
  ),
  VegetableCategory(
    name: 'Tomat',
    emoji: '🍅',
    phMin: 5.5,
    phMax: 6.5,
    ppmMin: 1400,
    ppmMax: 3500,
    description: 'Tomato - Butuh nutrisi tinggi',
  ),
  VegetableCategory(
    name: 'Cabai',
    emoji: '🌶️',
    phMin: 6.0,
    phMax: 6.5,
    ppmMin: 1260,
    ppmMax: 1540,
    description: 'Chili - Hasil melimpah',
  ),
  VegetableCategory(
    name: 'Basil',
    emoji: '🌱',
    phMin: 5.5,
    phMax: 6.5,
    ppmMin: 700,
    ppmMax: 1120,
    description: 'Holy Basil - Aromatik',
  ),
  VegetableCategory(
    name: 'Timun',
    emoji: '🥒',
    phMin: 5.5,
    phMax: 6.0,
    ppmMin: 1190,
    ppmMax: 1750,
    description: 'Cucumber - Perlu ruang',
  ),
];
