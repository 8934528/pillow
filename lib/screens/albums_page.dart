import 'package:flutter/material.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        title: const Text(
          'Albums',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF0000),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFFF0000)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Search albums - Coming soon!'),
                    backgroundColor: const Color(0xFFFF5349),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAE42).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.album,
                      size: 70,
                      color: const Color(0xFFFFAE42).withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No albums detected',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Albums will appear here when you add music to your library',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: const Color(0xFFFFAE42), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '0 albums in library',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
