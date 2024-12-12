import 'package:flutter/material.dart';
import 'package:powertani/Schedule/Schedule.dart';
import 'package:powertani/Tanaman/Kalender/KalenderMusim.dart';
import 'package:powertani/Tanaman/TipsTanaman.dart';
import 'package:powertani/components/components.dart';
import 'package:powertani/env.dart';

class DaftarMenu extends StatefulWidget {
  DaftarMenu({super.key, required this.user});

  final Map<dynamic, dynamic> user;

  @override
  _DaftarMenuState createState() => _DaftarMenuState();
}

class _DaftarMenuState extends State<DaftarMenu> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> menuItems = [
      {
        "icon": Icons.event_note,
        "label": "Kalender Musim",
        "route": () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KalenderMusim()),
              ),
            },
      },
      {
        "icon": Icons.water_drop,
        "label": "Jadwal Penyiraman",
        "route": () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Schedule(user: widget.user)),
              ),
            },
      },
      {
        "icon": Icons.video_library,
        "label": "Video Edukasi",
        "route": () => {},
      },
      {
        "icon": Icons.lightbulb,
        "label": "Tips Tanaman",
        "route": () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TipsTanaman(user: widget.user)),
              ),
            },
      },
      {
        "icon": Icons.bug_report,
        "label": "Penanganan Hama",
        "route": () => {},
      },
      {
        "icon": Icons.analytics,
        "label": "Estimasi Panen",
        "route": () => {},
      },
      {
        "icon": Icons.alarm,
        "label": "Tracking Masa Tanam",
        "route": () => {},
      },
      {
        "icon": Icons.book,
        "label": "Teknik Bertani",
        "route": () => {},
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        // Grid Menu
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isExpanded ? 200 : 100, // Adjust height for expansion
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Items per row
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: isExpanded ? menuItems.length : 4, // Show 4 or all items
            itemBuilder: (context, index) {
              return _buildMenuItem(menuItems[index]);
            },
          ),
        ),
        // Expand/Collapse Button
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isExpanded ? "Tutup" : "Lainnya",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Menu item widget
  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon inside a circular gradient background
        PressableIconButton(
          icon: item['icon'],
          onTap: item['route'],
        ),
        SizedBox(height: 8),
        // Label
        Text(
          item["label"] ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
