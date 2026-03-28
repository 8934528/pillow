import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class EqualizerPage extends StatelessWidget {
  const EqualizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final mood = appState.currentMood;
    final primaryColor = mood?.gradientColors[0] ?? const Color(0xFFFF0000);
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final List<String> bands = ['60Hz', '230Hz', '910Hz', '4kHz', '14kHz'];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Text('Equalizer', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Presets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['Flat', 'Pop', 'Rock', 'Bass Boost', 'Classical'].map((preset) {
                  final isSelected = appState.activePreset == preset;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(preset),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) appState.setEqualizerPreset(preset);
                      },
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                      backgroundColor: cardColor,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(bands.length, (index) {
                    return _buildSliderColumn(
                      context,
                      bands[index],
                      appState.equalizerGains[index],
                      index,
                      primaryColor,
                      isDark,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(isDark, cardColor, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderColumn(BuildContext context, String label, double value, int index, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          '${value > 0 ? "+" : ""}${value.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: color,
                inactiveTrackColor: color.withValues(alpha: 0.2),
                thumbColor: color,
                overlayColor: color.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: value,
                min: -10.0,
                max: 10.0,
                onChanged: (newValue) {
                  context.read<AppState>().setEqualizerGain(index, newValue);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDark, Color cardColor, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text('About Equalizer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Adjust the frequency bands to customize your listening experience. Presets provide optimized settings for different genres.',
            style: TextStyle(height: 1.5, color: isDark ? Colors.white70 : Colors.black87),
          ),
        ],
      ),
    );
  }
}
