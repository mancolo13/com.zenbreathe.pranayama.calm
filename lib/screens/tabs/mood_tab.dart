import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MoodTab extends StatefulWidget {
  const MoodTab({super.key});

  @override
  State<MoodTab> createState() => _MoodTabState();
}

class _MoodTabState extends State<MoodTab> {
  String _selectedMood = 'Peaceful';
  final List<String> _moods = ['Peaceful', 'Grounded', 'Anxious', 'Energized', 'Tired', 'Grateful'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Journal'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('How are you feeling right now?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _moods.map((m) {
              final sel = _selectedMood == m;
              return ChoiceChip(
                label: Text(m),
                selected: sel,
                selectedColor: AppTheme.primary.withValues(alpha: 0.3),
                onSelected: (_) => setState(() => _selectedMood = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Reflection: $_selectedMood', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text('Take three slow, conscious breaths and note what thoughts pass without clinging to them.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
