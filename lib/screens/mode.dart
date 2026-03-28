import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/notification_utils.dart';
import 'drive_mode.dart';

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedMode = appState.appMode;
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColorMain = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Mode',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFFFF0000)),
        ),
        backgroundColor: cardColorMain,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF0000)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mode selection card
            Container(
              decoration: BoxDecoration(
                color: cardColorMain,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: RadioGroup<String>(
                groupValue: selectedMode,
                onChanged: (v) {
                  if (v != null) {
                    context.read<AppState>().setAppMode(v);
                    NotificationUtils.showSuccessToast(context, 'Mode changed to ${v.capitalize()}');
                  }
                },
                child: Column(
                  children: [
                  // Offline mode
                  _buildModeOption(
                    context,
                    icon: Icons.offline_bolt,
                    color: const Color(0xFFFF0000),
                    title: 'Offline Mode',
                    subtitle: 'Play downloaded music only',
                    isSelected: selectedMode == 'offline',
                    trailing: Radio<String>(
                      value: 'offline',
                      activeColor: const Color(0xFFFF0000),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // Driving mode
                  _buildModeOption(
                    context,
                    icon: Icons.drive_eta,
                    color: const Color(0xFFFFA500),
                    title: 'Driving Mode',
                    subtitle: 'Simplified interface for driving',
                    isSelected: selectedMode == 'driving',
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DriveModePage()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Enter'),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // Online mode
                  _buildModeOption(
                    context,
                    icon: Icons.wifi,
                    color: const Color(0xFFFF5349),
                    title: 'Online Mode',
                    subtitle: 'Stream music from the internet',
                    isSelected: selectedMode == 'online',
                    trailing: Radio<String>(
                      value: 'online',
                      activeColor: const Color(0xFFFF5349),
                    ),
                  ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Current mode info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF0000).withValues(alpha: 0.1),
                    const Color(0xFFFFA500).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.info_outline,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('Current Mode',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF0000))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cardColorMain,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _modeIcon(selectedMode),
                          color: _modeColor(selectedMode),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _modeLabel(selectedMode),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _modeColor(selectedMode)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _modeDescription(selectedMode),
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('✨ More modes coming soon',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isSelected,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isSelected ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }

  IconData _modeIcon(String mode) {
    switch (mode) {
      case 'driving':
        return Icons.drive_eta;
      case 'online':
        return Icons.wifi;
      default:
        return Icons.offline_bolt;
    }
  }

  Color _modeColor(String mode) {
    switch (mode) {
      case 'driving':
        return const Color(0xFFFFA500);
      case 'online':
        return const Color(0xFFFF5349);
      default:
        return const Color(0xFFFF0000);
    }
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'driving':
        return 'Driving Mode';
      case 'online':
        return 'Online Mode';
      default:
        return 'Offline Mode';
    }
  }

  String _modeDescription(String mode) {
    switch (mode) {
      case 'driving':
        return 'Driving mode is ready. Tap "Enter" to start the simplified driving interface.';
      case 'online':
        return 'You are in Online mode. Stream music from the internet.';
      default:
        return 'You are in Offline mode. Only downloaded songs are available.';
    }
  }
}
