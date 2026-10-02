import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final minutes = StorageService.getInt('total_mindful_minutes', defaultValue: 42);
    final streak = StorageService.getInt('mindful_streak', defaultValue: 5);

    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Journey'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.spa_rounded, size: 64, color: AppTheme.primary),
                  const SizedBox(height: 12),
                  Text('$minutes min', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Total Mindfulness Practiced', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('🔥 $streak Days Streak', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weekly Reflection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((e) {
                      final active = e.key < 5;
                      return Column(
                        children: [
                          Container(
                            width: 32,
                            height: 60,
                            decoration: BoxDecoration(
                              color: active ? AppTheme.primary : AppTheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(e.value, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: AppTheme.secondary, child: Icon(Icons.favorite, color: Colors.white)),
              title: const Text('Calm Mindset'),
              subtitle: const Text('Regular slow breathing lowers cortisol and heart rate.'),
            ),
          ),
        ],
      ),
    );
  }
}
