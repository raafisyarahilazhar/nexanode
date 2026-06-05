import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/farm_provider.dart';
import '../widgets/farm_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Selamat Pagi ☀️';
    if (hour >= 11 && hour < 15) return 'Selamat Siang 🌤️';
    if (hour >= 15 && hour < 18) return 'Selamat Sore 🌅';
    return 'Selamat Malam 🌙';
  }

  String _getGreetingSubtitle() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Cek kondisi tanaman harianmu';
    if (hour >= 11 && hour < 15) return 'Pantau nutrisi siang ini';
    if (hour >= 15 && hour < 18) return 'Waktu kontrol sore tiba';
    return 'Monitor malam, panen besok!';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, farm, _) {
        final sensor = farm.sensorData;
        final motor = farm.motorStatus;

        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ─── Top Header ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildHeader(farm),
                ),

                // ─── Hero Monitoring Banner ───────────────────────────
                SliverToBoxAdapter(
                  child: _buildHeroBanner(sensor, farm),
                ),

                // ─── Sensor Grid ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SectionHeader(
                          title: 'Sensor Monitoring',
                          subtitle: 'Real-time dari node IoT',
                        ),
                        const SizedBox(height: 14),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.15,
                          children: [
                            SensorCard(
                              label: 'pH Air',
                              value: sensor.ph.toStringAsFixed(1),
                              unit: 'pH',
                              icon: Icons.science_rounded,
                              iconColor: AppTheme.phColor,
                              gradient: AppGradients.cardPh,
                              status: farm.getPhStatus(),
                            ),
                            SensorCard(
                              label: 'Kepekatan Nutrisi',
                              value: sensor.ppm.toStringAsFixed(0),
                              unit: 'ppm',
                              icon: Icons.water_drop_rounded,
                              iconColor: AppTheme.ppmColor,
                              gradient: AppGradients.cardPpm,
                              status: farm.getPpmStatus(),
                            ),
                            SensorCard(
                              label: 'Suhu Air',
                              value: sensor.waterTemp.toStringAsFixed(1),
                              unit: '°C',
                              icon: Icons.thermostat_rounded,
                              iconColor: AppTheme.waterTempColor,
                              gradient: AppGradients.cardWaterTemp,
                              status: sensor.waterTemp < 18 || sensor.waterTemp > 30
                                  ? (sensor.waterTemp < 18 ? 'low' : 'high')
                                  : 'normal',
                            ),
                            SensorCard(
                              label: 'Suhu Udara',
                              value: sensor.airTemp.toStringAsFixed(1),
                              unit: '°C',
                              icon: Icons.air_rounded,
                              iconColor: AppTheme.airTempColor,
                              gradient: AppGradients.cardAirTemp,
                              status: sensor.airTemp < 22 || sensor.airTemp > 35
                                  ? (sensor.airTemp < 22 ? 'low' : 'high')
                                  : 'normal',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Humidity full-width card
                        _buildHumidityCard(sensor.humidity),
                      ],
                    ),
                  ),
                ),

                // ─── Motor Control Section ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      children: [
                        SectionHeader(
                          title: 'Kontrol Motor Pompa',
                          subtitle: 'Tap untuk aktifkan/matikan',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const StatusDot(color: AppTheme.success),
                                const SizedBox(width: 6),
                                Text(
                                  'IoT Online',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                          children: [
                            MotorControlCard(
                              label: 'pH Up',
                              subtitle: 'Naikkan pH',
                              icon: Icons.arrow_upward_rounded,
                              color: const Color(0xFF00BCD4),
                              isActive: motor.phUp,
                              onToggle: () => farm.toggleMotor('phUp'),
                            ),
                            MotorControlCard(
                              label: 'pH Down',
                              subtitle: 'Turunkan pH',
                              icon: Icons.arrow_downward_rounded,
                              color: const Color(0xFFFF5722),
                              isActive: motor.phDown,
                              onToggle: () => farm.toggleMotor('phDown'),
                            ),
                            MotorControlCard(
                              label: 'Nutrisi A',
                              subtitle: 'Makro nutrisi',
                              icon: Icons.opacity_rounded,
                              color: const Color(0xFF4CAF50),
                              isActive: motor.nutrisiA,
                              onToggle: () => farm.toggleMotor('nutrisiA'),
                            ),
                            MotorControlCard(
                              label: 'Nutrisi B',
                              subtitle: 'Mikro nutrisi',
                              icon: Icons.bubble_chart_rounded,
                              color: const Color(0xFF9C27B0),
                              isActive: motor.nutrisiB,
                              onToggle: () => farm.toggleMotor('nutrisiB'),
                            ),
                          ],
                        ),
                        // Main Pump
                        const SizedBox(height: 12),
                        _buildMainPumpCard(motor.pump, farm),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(FarmProvider farm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  _getGreetingSubtitle(),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 22),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(dynamic sensor, FarmProvider farm) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'HydroFarm Monitor',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const StatusDot(color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Live',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniStat('pH', sensor.ph.toStringAsFixed(1), farm.getPhStatus()),
              _divider(),
              _miniStat(
                  'PPM', sensor.ppm.toStringAsFixed(0), farm.getPpmStatus()),
              _divider(),
              _miniStat('Suhu', '${sensor.waterTemp.toStringAsFixed(1)}°', 'normal'),
              _divider(),
              _miniStat('Hum', '${sensor.humidity.toStringAsFixed(0)}%', 'normal'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded,
                    color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farm.settings.selectedVegetable != null
                        ? 'Tanaman: ${farm.settings.selectedVegetable!.emoji} ${farm.settings.selectedVegetable!.name} — Target pH ${farm.settings.selectedVegetable!.phMin}–${farm.settings.selectedVegetable!.phMax}'
                        : 'Pilih kategori sayuran di halaman Pengaturan',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, String status) {
    Color statusColor = Colors.white;
    if (status == 'low') statusColor = Colors.yellowAccent;
    if (status == 'high') statusColor = Colors.redAccent.shade100;

    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: statusColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 11, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildHumidityCard(double humidity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.humidityColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.humidityColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.water_rounded,
                color: AppTheme.humidityColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelembaban Udara',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: humidity / 100,
                    backgroundColor: AppTheme.humidityColor.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.humidityColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '${humidity.toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.humidityColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPumpCard(bool isActive, FarmProvider farm) {
    return GestureDetector(
      onTap: () => farm.toggleMotor('pump'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isActive
              ? AppGradients.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xFFEEEEEE), Color(0xFFE0E0E0)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isActive ? Colors.white : Colors.grey)
                    .withOpacity(isActive ? 0.25 : 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.opacity_rounded,
                color: isActive ? Colors.white : Colors.grey.shade500,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pompa Utama',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    isActive
                        ? 'Sedang mengalirkan larutan nutrisi'
                        : 'Pompa dalam kondisi mati',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isActive
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.3)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
