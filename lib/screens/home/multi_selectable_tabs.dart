import 'package:flutter/material.dart';

class MultiSelectableTabs extends StatefulWidget {
  const MultiSelectableTabs({super.key});

  @override
  MultiSelectableTabsState createState() => MultiSelectableTabsState();
}

class MultiSelectableTabsState extends State<MultiSelectableTabs> {
  // Track selected tabs
  final List<bool> _selectedTabs = [false, false, false, false];

  // Tab data
  final List<Map<String, dynamic>> _tabs = [
    {'icon': '+', 'color': const Color(0xFFE6E6FA)}, // Light purple
    {'icon': '−', 'color': const Color(0xFF00FF9D)}, // Green
    {'icon': '×', 'color': const Color(0xFF00FF9D)}, // Green
    {'icon': '−', 'color': const Color(0xFF00FF9D)}, // Green
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab row
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _tabs.length,
              (index) => _buildTab(index),
            ),
          ),
        ),

        // Difficulty level section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Difficulty Level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enhance your mental agility and problem solving skills through',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDifficultyChip('1 - 10'),
                  const SizedBox(width: 8),
                  _buildDifficultyChip('10 - 100'),
                  const SizedBox(width: 8),
                  _buildDifficultyChip('100 - 1000'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add your begin logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Begin'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabs[index] = !_selectedTabs[index];
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color:
              _selectedTabs[index] ? _tabs[index]['color'] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          // Add connected effect when selected
          /*borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(_selectedTabs[index] ? 0 : 12),
          ),*/
        ),
        child: Center(
          child: Text(
            _tabs[index]['icon'],
            style: TextStyle(
              fontSize: 24,
              color: _selectedTabs[index] ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label),
    );
  }
}
