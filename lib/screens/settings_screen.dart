import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/farm_provider.dart';
import '../models/farm_models.dart';
import '../widgets/farm_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, farm, _) {
        final settings = farm.settings;

        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ─── Header ───────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // ─── Mode Selector ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildModeSelector(settings, farm),
                  ),
                ),

                // ─── Vegetable Category ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'Kategori Sayuran',
                          subtitle: 'Pilih untuk auto-set pH & PPM',
                        ),
                        const SizedBox(height: 14),
                        _buildVegetableGrid(settings, farm),
                      ],
                    ),
                  ),
                ),

                // ─── Selected Veg Info ────────────────────────────────
                if (settings.selectedVegetable != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _buildVegetableInfo(settings.selectedVegetable!),
                    ),
                  ),

                // ─── Manual pH / PPM Settings ─────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      children: [
                        SectionHeader(
                          title: 'Target Parameter',
                          subtitle: settings.mode == 'auto'
                              ? 'Otomatis dari kategori tanaman'
                              : 'Atur secara manual',
                        ),
                        const SizedBox(height: 14),
                        _buildPhSlider(settings, farm),
                        const SizedBox(height: 16),
                        _buildPpmSlider(settings, farm),
                      ],
                    ),
                  ),
                ),

                // ─── Tolerance Settings ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      children: [
                        const SectionHeader(
                          title: 'Toleransi Kontrol',
                          subtitle: 'Batas penyimpangan sebelum motor aktif',
                        ),
                        const SizedBox(height: 14),
                        _buildToleranceCard(settings, farm),
                      ],
                    ),
                  ),
                ),

                // ─── Save Button ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildSaveButton(context, farm),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            'Konfigurasi sistem hidroponik kamu',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(FarmSettings settings, FarmProvider farm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _modeTab(
            label: 'Otomatis',
            subtitle: 'Berdasarkan tanaman',
            isSelected: settings.mode == 'auto',
            onTap: () => farm.setMode('auto'),
            color: AppTheme.primary,
          ),
          const SizedBox(width: 6),
          _modeTab(
            label: 'Manual',
            subtitle: 'Atur sendiri',
            isSelected: settings.mode == 'manual',
            onTap: () => farm.setMode('manual'),
            color: const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white.withOpacity(0.8)
                      : AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVegetableGrid(FarmSettings settings, FarmProvider farm) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: vegetables.length,
      itemBuilder: (_, i) {
        final veg = vegetables[i];
        final isSelected = settings.selectedVegetable?.name == veg.name;
        return GestureDetector(
          onTap: () => farm.selectVegetable(veg),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppTheme.primary : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(veg.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  veg.name,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVegetableInfo(VegetableCategory veg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(veg.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    veg.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  Text(
                    veg.description,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _infoChip(
                  'pH Optimal', '${veg.phMin} – ${veg.phMax}', AppTheme.phColor),
              const SizedBox(width: 10),
              _infoChip('PPM Optimal', '${veg.ppmMin.toInt()} – ${veg.ppmMax.toInt()}',
                  AppTheme.ppmColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppTheme.textSecondary),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhSlider(FarmSettings settings, FarmProvider farm) {
    final isManual = settings.mode == 'manual';
    return _parameterCard(
      label: 'Target pH',
      icon: Icons.science_rounded,
      color: AppTheme.phColor,
      value: settings.targetPh.toStringAsFixed(1),
      unit: 'pH',
      child: AbsorbPointer(
        absorbing: !isManual,
        child: Opacity(
          opacity: isManual ? 1.0 : 0.5,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.phColor,
              thumbColor: AppTheme.phColor,
              overlayColor: AppTheme.phColor.withOpacity(0.2),
              inactiveTrackColor: AppTheme.phColor.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: settings.targetPh,
              min: 4.0,
              max: 9.0,
              divisions: 50,
              onChanged: (v) {
                farm.updateSettings(settings.copyWith(targetPh: v));
              },
            ),
          ),
        ),
      ),
      minLabel: '4.0',
      maxLabel: '9.0',
    );
  }

  Widget _buildPpmSlider(FarmSettings settings, FarmProvider farm) {
    final isManual = settings.mode == 'manual';
    return _parameterCard(
      label: 'Target PPM',
      icon: Icons.water_drop_rounded,
      color: AppTheme.ppmColor,
      value: settings.targetPpm.toStringAsFixed(0),
      unit: 'ppm',
      child: AbsorbPointer(
        absorbing: !isManual,
        child: Opacity(
          opacity: isManual ? 1.0 : 0.5,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.ppmColor,
              thumbColor: AppTheme.ppmColor,
              overlayColor: AppTheme.ppmColor.withOpacity(0.2),
              inactiveTrackColor: AppTheme.ppmColor.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: settings.targetPpm,
              min: 200,
              max: 3500,
              divisions: 165,
              onChanged: (v) {
                farm.updateSettings(settings.copyWith(targetPpm: v));
              },
            ),
          ),
        ),
      ),
      minLabel: '200',
      maxLabel: '3500',
    );
  }

  Widget _parameterCard({
    required String label,
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
    required Widget child,
    required String minLabel,
    required String maxLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$value $unit',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          child,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppTheme.textMuted)),
              Text(maxLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToleranceCard(FarmSettings settings, FarmProvider farm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _toleranceRow(
            label: 'Toleransi pH',
            value: '±${settings.phTolerance.toStringAsFixed(1)}',
            color: AppTheme.phColor,
            sliderValue: settings.phTolerance,
            min: 0.1,
            max: 1.0,
            onChanged: (v) {
              farm.updateSettings(settings.copyWith(phTolerance: v));
            },
          ),
          const Divider(height: 24),
          _toleranceRow(
            label: 'Toleransi PPM',
            value: '±${settings.ppmTolerance.toStringAsFixed(0)}',
            color: AppTheme.ppmColor,
            sliderValue: settings.ppmTolerance,
            min: 50,
            max: 500,
            onChanged: (v) {
              farm.updateSettings(settings.copyWith(ppmTolerance: v));
            },
          ),
        ],
      ),
    );
  }

  Widget _toleranceRow({
    required String label,
    required String value,
    required Color color,
    required double sliderValue,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            inactiveTrackColor: color.withOpacity(0.2),
            trackHeight: 3,
          ),
          child: Slider(
            value: sliderValue,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, FarmProvider farm) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Pengaturan berhasil disimpan!',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(
        'Simpan Pengaturan',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
