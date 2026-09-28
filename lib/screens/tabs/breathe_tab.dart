import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';

class BreatheTab extends StatefulWidget {
  const BreatheTab({super.key});

  @override
  State<BreatheTab> createState() => _BreatheTabState();
}

class _BreatheTabState extends State<BreatheTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _phase = 'Inhale';
  bool _active = false;
  Timer? _timer;
  int _patternIndex = 0; // 0: Box (4-4-4-4), 1: 4-7-8, 2: Relax (4-6)

  final List<Map<String, dynamic>> _patterns = const [
    {"name": "Box Breathing", "inhale": 4, "hold1": 4, "exhale": 4, "hold2": 4},
    {"name": "4-7-8 Relax", "inhale": 4, "hold1": 7, "exhale": 8, "hold2": 0},
    {"name": "Calm Flow", "inhale": 4, "hold1": 0, "exhale": 6, "hold2": 0},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
  }

  void _start() {
    setState(() => _active = true);
    _runCycle();
  }

  void _runCycle() {
    if (!_active) return;
    final p = _patterns[_patternIndex];
    final inhale = p['inhale'] as int;
    final hold1 = p['hold1'] as int;

    setState(() {
      _phase = 'Inhale';
    });
    _controller.duration = Duration(seconds: inhale);
    _controller.forward();

    _timer = Timer(Duration(seconds: inhale), () {
      if (!_active) return;
      if (hold1 > 0) {
        setState(() {
          _phase = 'Hold';
        });
        _timer = Timer(Duration(seconds: hold1), _doExhale);
      } else {
        _doExhale();
      }
    });
  }

  void _doExhale() {
    if (!_active) return;
    final p = _patterns[_patternIndex];
    final exhale = p['exhale'] as int;
    final hold2 = p['hold2'] as int;

    setState(() {
      _phase = 'Exhale';
    });
    _controller.duration = Duration(seconds: exhale);
    _controller.reverse();

    _timer = Timer(Duration(seconds: exhale), () {
      if (!_active) return;
      if (hold2 > 0) {
        setState(() {
          _phase = 'Hold';
        });
        _timer = Timer(Duration(seconds: hold2), _runCycle);
      } else {
        _runCycle();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    _controller.stop();
    setState(() => _active = false);
    int count = StorageService.getInt('breathe_sessions') + 1;
    StorageService.setInt('breathe_sessions', count);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZenBreathe Flow'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 8,
              children: List.generate(_patterns.length, (i) {
                return ChoiceChip(
                  label: Text(_patterns[i]['name'].toString()),
                  selected: _patternIndex == i,
                  selectedColor: AppTheme.primary.withValues(alpha: 0.3),
                  onSelected: (sel) {
                    if (sel && !_active) setState(() => _patternIndex = i);
                  },
                );
              }),
            ),
            const SizedBox(height: 48),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 1.0 + (_controller.value * 0.5);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.6),
                          AppTheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _phase,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _active ? _stop : _start,
              style: ElevatedButton.styleFrom(
                backgroundColor: _active ? AppTheme.secondary : AppTheme.primary,
                foregroundColor: AppTheme.background,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(_active ? 'End Session' : 'Begin Breathing', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
