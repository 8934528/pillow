import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/notification_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF0000), fontSize: 22),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF0000)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFFF0000)),
            onPressed: () {
              appState.scanMusic();
              NotificationUtils.showToast(context, 'Rescanning library...', icon: Icons.refresh);
            },
            tooltip: 'Rescan library',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildStorageCard(context, appState, cardColor, isDark),
          ),
          SliverToBoxAdapter(
            child: _buildHeader('Library', Icons.library_music, isDark),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.folder,
              title: 'Scan local songs',
              subtitle: 'Scan device for music files',
              cardColor: cardColor,
              isDark: isDark,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                appState.scanMusic();
                NotificationUtils.showToast(context, 'Scanning device for music...', icon: Icons.folder_open);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildHeader('Playback', Icons.play_circle, isDark),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.audio_file,
              title: 'Audio quality',
              subtitle: appState.audioQuality,
              cardColor: cardColor,
              isDark: isDark,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showAudioQualitySheet(context, appState),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.equalizer,
              title: 'Equalizer',
              subtitle: 'Premium sound control',
              cardColor: cardColor,
              isDark: isDark,
              trailing: Switch(
                value: appState.equalizerEnabled,
                onChanged: (v) => appState.setEqualizer(v),
                activeThumbColor: const Color(0xFFFF0000),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildHeader('Preferences', Icons.settings, isDark),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.brightness_medium,
              title: 'Dark mode',
              subtitle: isDark ? 'Enabled' : 'Disabled',
              cardColor: cardColor,
              isDark: isDark,
              trailing: Switch(
                value: isDark,
                onChanged: (v) {
                  appState.setDarkMode(v);
                  NotificationUtils.showToast(context, v ? 'Dark mode enabled' : 'Light mode enabled', icon: v ? Icons.dark_mode : Icons.light_mode);
                },
                activeThumbColor: const Color(0xFFFF0000),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildStorageCard(BuildContext context, AppState appState, Color cardColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage, color: Color(0xFFFF0000), size: 24),
              const SizedBox(width: 12),
              Text('Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0000)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text('Location: ${appState.storageLocation}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF0000), size: 18),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    required Color cardColor,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFFF0000).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFFFF0000), size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: trailing,
      ),
    );
  }

  void _showAudioQualitySheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qualityTile(ctx, 'Low (96kbps)', appState),
          _qualityTile(ctx, 'Normal (160kbps)', appState),
          _qualityTile(ctx, 'High (320kbps)', appState),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _qualityTile(BuildContext context, String quality, AppState appState) {
    return ListTile(
      title: Text(quality),
      onTap: () {
        appState.setAudioQuality(quality);
        Navigator.pop(context);
        NotificationUtils.showToast(context, 'Audio quality set to $quality', icon: Icons.high_quality);
      },
      trailing: appState.audioQuality == quality ? const Icon(Icons.check, color: Color(0xFFFF0000)) : null,
    );
  }
}
