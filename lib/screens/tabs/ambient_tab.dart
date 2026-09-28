import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AmbientTab extends StatefulWidget {
  const AmbientTab({super.key});

  @override
  State<AmbientTab> createState() => _AmbientTabState();
}

class _AmbientTabState extends State<AmbientTab> {
  final Map<String, double> _volumes = {
    "Forest Rain": 0.6,
    "Mountain Wind": 0.4,
    "Tibetan Bowls": 0.8,
    "Ocean Waves": 0.5,
    "Night Crickets": 0.2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Ambience'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: _volumes.keys.map((title) {
          final vol = _volumes[title]!;
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${(vol * 100).round()}%', style: const TextStyle(color: AppTheme.primary)),
                    ],
                  ),
                  Slider(
                    value: vol,
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _volumes[title] = val),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
