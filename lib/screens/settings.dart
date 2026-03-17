import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _autoDownloadEnabled = false;
  bool _darkModeEnabled = false;
  bool _equalizerEnabled = false;
  String _audioQuality = "High";
  String _storageLocation = "Internal Storage";
  bool _scanning = false;

  void _showFeatureComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feature coming soon!'),
        backgroundColor: const Color(0xFFFF5349),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _scanLocalSongs() {
    setState(() {
      _scanning = true;
    });
    
    // Simulate scanning
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _scanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Scan Complete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Found 2 new songs',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFF0000),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _showStorageLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Storage Location',
            style: TextStyle(
              color: Color(0xFFFF0000),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStorageOption('Internal Storage', Icons.phone_android),
              const SizedBox(height: 8),
              _buildStorageOption('SD Card', Icons.sd_storage),
              const SizedBox(height: 8),
              _buildStorageOption('Cloud Storage', Icons.cloud),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStorageOption(String title, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _storageLocation = title;
        });
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _storageLocation == title
              ? const Color(0xFFFF0000).withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _storageLocation == title
                ? const Color(0xFFFF0000)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _storageLocation == title
                  ? const Color(0xFFFF0000)
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: _storageLocation == title
                    ? const Color(0xFFFF0000)
                    : Colors.black87,
                fontWeight: _storageLocation == title
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_storageLocation == title)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFF0000),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader(String title, IconData icon) {
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
            child: Icon(icon, color: const Color(0xFFFF0000), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
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
                    color: (iconColor ?? const Color(0xFFFF0000)).withValues(alpha: 0.1),
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF0000),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
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
              onPressed: _scanLocalSongs,
              tooltip: 'Rescan library',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(), // Prevents stretching
        slivers: [
          // Storage Info Sliver
          SliverToBoxAdapter(
            child: Container(
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
                  color: const Color(0xFFFF0000).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storage,
                      color: Color(0xFFFF0000),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Storage',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _storageLocation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.3,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF0000),
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '2.4 GB used',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '8.0 GB total',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Library Section
          SliverToBoxAdapter(
            child: _buildSettingsHeader('Library', Icons.library_music),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.folder,
              title: 'Scan local songs',
              subtitle: 'Scan device for music files',
              trailing: _scanning
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFFF0000),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Scan',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
              onTap: _scanLocalSongs,
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.folder_open,
              title: 'Storage location',
              subtitle: _storageLocation,
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
              onTap: _showStorageLocationDialog,
            ),
          ),

          // Playback Section
          SliverToBoxAdapter(
            child: _buildSettingsHeader('Playback', Icons.play_circle),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.audio_file,
              title: 'Audio quality',
              subtitle: _audioQuality,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _audioQuality,
                      style: const TextStyle(
                        color: Color(0xFFFF0000),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFFF0000),
                      size: 18,
                    ),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
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
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Audio Quality',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ),
                          _buildQualityOption('Low', '~ 96 kbps'),
                          _buildQualityOption('Medium', '~ 192 kbps'),
                          _buildQualityOption('High', '~ 320 kbps'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.equalizer,
              title: 'Equalizer',
              subtitle: _equalizerEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: _equalizerEnabled,
                onChanged: (value) {
                  setState(() {
                    _equalizerEnabled = value;
                  });
                  if (value) {
                    _showFeatureComingSoon();
                  }
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          // Preferences Section
          SliverToBoxAdapter(
            child: _buildSettingsHeader('Preferences', Icons.settings),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.notifications,
              title: 'Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.download,
              title: 'Auto download',
              subtitle: 'Download music over Wi-Fi',
              trailing: Switch(
                value: _autoDownloadEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoDownloadEnabled = value;
                  });
                  if (value) {
                    _showFeatureComingSoon();
                  }
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.brightness_medium,
              title: 'Dark mode',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  _showFeatureComingSoon();
                },
                activeColor: const Color(0xFFFF0000),
              ),
            ),
          ),

          // About Section
          SliverToBoxAdapter(
            child: _buildSettingsHeader('About', Icons.info),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _showFeatureComingSoon,
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.info,
              title: 'About',
              subtitle: 'Version 1.0.0',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _showFeatureComingSoon,
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSettingsCard(
              icon: Icons.description,
              title: 'Terms of Service',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _showFeatureComingSoon,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityOption(String quality, String bitrate) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _audioQuality == quality
              ? const Color(0xFFFF0000).withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.audio_file,
          color: _audioQuality == quality
              ? const Color(0xFFFF0000)
              : Colors.grey[600],
          size: 22,
        ),
      ),
      title: Text(
        quality,
        style: TextStyle(
          fontWeight: _audioQuality == quality ? FontWeight.bold : FontWeight.normal,
          color: _audioQuality == quality ? const Color(0xFFFF0000) : Colors.black87,
        ),
      ),
      subtitle: Text(
        bitrate,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: _audioQuality == quality
          ? const Icon(Icons.check_circle, color: Color(0xFFFF0000))
          : null,
      onTap: () {
        setState(() {
          _audioQuality = quality;
        });
        Navigator.pop(context);
      },
    );
  }
}
