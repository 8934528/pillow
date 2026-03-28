import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

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
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF0000),
              fontSize: 22),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF0000).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFF0000)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFFFF0000)),
              onPressed: () =>
                  _scanLocalSongs(context, appState),
              tooltip: 'Rescan library',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Storage Info card
          SliverToBoxAdapter(
            child: _buildStorageCard(context, appState, cardColor),
          ),

          // Library
          SliverToBoxAdapter(
            child: _buildHeader('Library', Icons.library_music, cardColor),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.folder,
              title: 'Scan local songs',
              subtitle: 'Scan device for music files',
              cardColor: cardColor,
              trailing: _scanButton(context, appState),
              onTap: () => _scanLocalSongs(context, appState),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.folder_open,
              title: 'Storage location',
              subtitle: appState.storageLocation,
              cardColor: cardColor,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () =>
                  _showStorageLocationDialog(context, appState),
            ),
          ),

          // Playback
          SliverToBoxAdapter(
            child: _buildHeader('Playback', Icons.play_circle, cardColor),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.audio_file,
              title: 'Audio quality',
              subtitle: appState.audioQuality,
              cardColor: cardColor,
              trailing: _qualityBadge(appState.audioQuality),
              onTap: () => _showAudioQualitySheet(context, appState),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.equalizer,
              title: 'Equalizer',
              subtitle:
                  appState.equalizerEnabled ? 'Enabled' : 'Disabled',
              cardColor: cardColor,
              trailing: Switch(
                value: appState.equalizerEnabled,
                onChanged: (v) {
                  appState.setEqualizer(v);
                  if (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Feature coming soon!'),
                        backgroundColor: const Color(0xFFFF5349),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          // Preferences
          SliverToBoxAdapter(
            child: _buildHeader('Preferences', Icons.settings, cardColor),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.notifications,
              title: 'Notifications',
              cardColor: cardColor,
              trailing: Switch(
                value: appState.notificationsEnabled,
                onChanged: appState.setNotifications,
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.download,
              title: 'Auto download',
              subtitle: 'Download music over Wi-Fi',
              cardColor: cardColor,
              trailing: Switch(
                value: appState.autoDownloadEnabled,
                onChanged: (v) {
                  appState.setAutoDownload(v);
                  if (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Feature coming soon!'),
                        backgroundColor: const Color(0xFFFF5349),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.brightness_medium,
              title: 'Dark mode',
              subtitle: isDark ? 'Enabled' : 'Disabled',
              cardColor: cardColor,
              trailing: Switch(
                value: isDark,
                onChanged: (v) => appState.setDarkMode(v),
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          // About
          SliverToBoxAdapter(
            child: _buildHeader('About', Icons.info, cardColor),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              cardColor: cardColor,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showComingSoon(context),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.info,
              title: 'About Pillow',
              subtitle: 'Version 1.0.0',
              cardColor: cardColor,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showAboutDialog(context),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              icon: Icons.description,
              title: 'Terms of Service',
              cardColor: cardColor,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showComingSoon(context),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────────────

  Widget _buildStorageCard(
      BuildContext context, AppState appState, Color cardColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF0000).withValues(alpha: 0.1),
            const Color(0xFFFFA500).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFFFF0000).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                    blurRadius: 10)
              ],
            ),
            child: const Icon(Icons.storage,
                color: Color(0xFFFF0000), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Storage',
                    style:
                        TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(appState.storageLocation,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF0000)),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2.4 GB used',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                    Text('8.0 GB total',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Icon(icon, color: const Color(0xFFFF0000), size: 20),
          ),
          const SizedBox(width: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    required Color cardColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? const Color(0xFFFF0000))
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? const Color(0xFFFF0000),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scanButton(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Scan',
          style: TextStyle(
              color: Color(0xFFFF0000),
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }

  Widget _qualityBadge(String quality) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(quality,
              style: const TextStyle(
                  color: Color(0xFFFF0000),
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down,
              color: Color(0xFFFF0000), size: 18),
        ],
      ),
    );
  }

  // ─── Actions ─────────────────────────────────────────────────────

  void _scanLocalSongs(BuildContext context, AppState appState) {
    final messenger = ScaffoldMessenger.of(context);
    Future.delayed(const Duration(seconds: 2), () {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Scan Complete',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Found ${appState.songs.length} songs',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12)),
                ],
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFF0000),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _showStorageLocationDialog(
      BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Text('Storage Location',
              style: TextStyle(
                  color: Color(0xFFFF0000), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _storageOption(
                  ctx, 'Internal Storage', Icons.phone_android, appState),
              const SizedBox(height: 8),
              _storageOption(ctx, 'SD Card', Icons.sd_storage, appState),
              const SizedBox(height: 8),
              _storageOption(ctx, 'Cloud Storage', Icons.cloud, appState),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _storageOption(
      BuildContext context, String title, IconData icon, AppState appState) {
    final isSelected = appState.storageLocation == title;
    return InkWell(
      onTap: () {
        appState.setStorageLocation(title);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF0000).withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF0000)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected
                    ? const Color(0xFFFF0000)
                    : Colors.grey[600]),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFFF0000)
                        : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFFF0000), size: 20),
          ],
        ),
      ),
    );
  }

  void _showAudioQualitySheet(BuildContext context, AppState appState) {
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Audio Quality',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000))),
              ),
              _qualityOption(ctx, 'Low', '~96 kbps', appState),
              _qualityOption(ctx, 'Medium', '~192 kbps', appState),
              _qualityOption(ctx, 'High', '~320 kbps', appState),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _qualityOption(
      BuildContext context, String quality, String bitrate, AppState appState) {
    final isSelected = appState.audioQuality == quality;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF0000).withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.audio_file,
            color: isSelected
                ? const Color(0xFFFF0000)
                : Colors.grey[600],
            size: 22),
      ),
      title: Text(quality,
          style: TextStyle(
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFFFF0000)
                  : Colors.black87)),
      subtitle: Text(bitrate,
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFFFF0000))
          : null,
      onTap: () {
        appState.setAudioQuality(quality);
        Navigator.pop(context);
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feature coming soon!'),
        backgroundColor: const Color(0xFFFF5349),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF0000).withValues(alpha: 0.3),
                    const Color(0xFFFF0000),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.music_note,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Pillow',
                style: TextStyle(
                    color: Color(0xFFFF0000),
                    fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text(
              'A beautiful music player for your local library.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFFFF0000))),
          ),
        ],
      ),
    );
  }
}
