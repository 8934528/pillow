import 'package:flutter/material.dart';
import 'drive_mode.dart';

class ModePage extends StatefulWidget {
  const ModePage({super.key});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  String _selectedMode = "offline";

  void _showFeatureComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feature coming soon!'),
        backgroundColor: const Color(0xFFFF5349),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _navigateToDriveMode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DriveModePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        title: const Text(
          'Mode',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF0000),
          ),
        ),
        backgroundColor: Colors.white,
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Column(
                children: [
                  // Offline mode
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.offline_bolt, color: Color(0xFFFF0000)),
                    ),
                    title: const Text(
                      'Offline Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text('Play downloaded music only'),
                    trailing: Radio<String>(
                      value: 'offline',
                      groupValue: _selectedMode,
                      activeColor: const Color(0xFFFF0000),
                      onChanged: (value) {
                        setState(() {
                          _selectedMode = value!;
                        });
                        _showFeatureComingSoon();
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  
                  // Driving mode
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.drive_eta, color: Color(0xFFFFA500)),
                    ),
                    title: const Text(
                      'Driving Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text('Simplified interface for driving'),
                    trailing: ElevatedButton(
                      onPressed: _navigateToDriveMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Enter'),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  
                  // Online mode
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5349).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.wifi, color: Color(0xFFFF5349)),
                    ),
                    title: const Text(
                      'Online Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text('Stream music from the internet'),
                    trailing: Radio<String>(
                      value: 'online',
                      groupValue: _selectedMode,
                      activeColor: const Color(0xFFFF5349),
                      onChanged: (value) {
                        setState(() {
                          _selectedMode = value!;
                        });
                        _showFeatureComingSoon();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Current mode card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Container(
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
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Current Mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _selectedMode == 'offline' ? Icons.offline_bolt :
                            _selectedMode == 'driving' ? Icons.drive_eta :
                            Icons.wifi,
                            color: _selectedMode == 'offline' ? const Color(0xFFFF0000) :
                                   _selectedMode == 'driving' ? const Color(0xFFFFA500) :
                                   const Color(0xFFFF5349),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedMode == 'offline' ? 'Offline Mode' :
                            _selectedMode == 'driving' ? 'Driving Mode' :
                            'Online Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _selectedMode == 'offline' ? const Color(0xFFFF0000) :
                                     _selectedMode == 'driving' ? const Color(0xFFFFA500) :
                                     const Color(0xFFFF5349),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedMode == 'offline'
                          ? 'You are in Offline mode. Only downloaded songs are available.'
                          : _selectedMode == 'driving'
                              ? 'Driving mode is ready. Tap "Enter" to start the simplified driving interface.'
                              : 'You are in Online mode. Stream music from the internet.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Feature note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '✨ Other modes coming soon',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
