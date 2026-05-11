import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../widgets/common_widgets.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});
  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppTheme.accentLight,
          labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Scan'), Tab(text: 'Monitoring'), Tab(text: 'History')],
        ),
      ),
      body: TabBarView(controller: _tab, children: [
        _ScanTab(),
        _MonitoringTab(),
        _HistoryTab(),
      ]),
    );
  }
}

class _ScanTab extends StatefulWidget {
  @override
  State<_ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<_ScanTab> {
  bool _scanning = false;
  bool _scanned = false;

  void _startScan() async {
    setState(() { _scanning = true; _scanned = false; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _scanning = false; _scanned = true; });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      // Scan methods
      Row(children: [
        Expanded(child: _ScanOption(icon: Icons.camera_alt_rounded, label: 'Waste Analysis', color: AppTheme.danger, onTap: _startScan)),
        const SizedBox(width: 12),
        Expanded(child: _ScanOption(icon: Icons.visibility_rounded, label: 'Behavior Scan', color: AppTheme.info, onTap: _startScan)),
        const SizedBox(width: 12),
        Expanded(child: _ScanOption(icon: Icons.medical_services_rounded, label: 'Appearance', color: AppTheme.accent, onTap: _startScan)),
      ]),
      const SizedBox(height: 20),

      // Camera preview
      Container(
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1F1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
        ),
        child: _scanning
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const CircularProgressIndicator(color: AppTheme.accentLight, strokeWidth: 3),
                const SizedBox(height: 16),
                Text('Analyzing image...', style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 13)),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.camera_alt_rounded, size: 48, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 12),
                Text('Tap a scan type above\nor upload an image', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _startScan,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: Text('Upload Image', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ]),
      ),
      const SizedBox(height: 20),

      if (_scanned) ...[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.warning.withOpacity(0.4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Disease Detected', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.warning)),
                Text('Confidence: 78%', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
              ])),
              StatusChip(label: 'Medium Risk', color: AppTheme.warning),
            ]),
            const SizedBox(height: 14),
            Text('Suspected Condition:', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Newcastle Disease (Early Stage)', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Text('Recommended Actions:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            const SizedBox(height: 6),
            _ActionPoint('Isolate affected birds immediately'),
            _ActionPoint('Contact a licensed veterinarian'),
            _ActionPoint('Begin ND vaccination protocol'),
            _ActionPoint('Disinfect affected sheds'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: Text('Call Vet', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primary, side: const BorderSide(color: AppTheme.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 13)),
                child: Text('Buy Medicine', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
              )),
            ]),
          ]),
        ),
      ],
    ]);
  }
}

class _ActionPoint extends StatelessWidget {
  final String text;
  const _ActionPoint(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppTheme.accent),
      const SizedBox(width: 8),
      Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
    ]),
  );
}

class _ScanOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ScanOption({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ]),
    ),
  );
}

class _MonitoringTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monitors = [
      {'title': 'Shed A — Live Camera', 'status': 'Active', 'birds': 320, 'alert': false},
      {'title': 'Shed B — Live Camera', 'status': 'Active', 'birds': 480, 'alert': true},
      {'title': 'Shed C — Live Camera', 'status': 'Offline', 'birds': 440, 'alert': false},
    ];
    return ListView(padding: const EdgeInsets.all(16), children: [
      ...monitors.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: (m['alert'] as bool) ? AppTheme.danger.withOpacity(0.3) : const Color(0xFFE8F0EC))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1F1A),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.videocam_rounded, size: 36, color: (m['status'] as String) == 'Active' ? AppTheme.accentLight : Colors.white24),
                const SizedBox(height: 8),
                Text((m['status'] as String) == 'Active' ? 'LIVE' : 'OFFLINE',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700,
                    color: (m['status'] as String) == 'Active' ? AppTheme.danger : Colors.white38)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m['title'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                Text('${m['birds']} birds monitored', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
              ])),
              if (m['alert'] as bool) StatusChip(label: 'Alert!', color: AppTheme.danger),
            ]),
          ),
        ]),
      )),
    ]);
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = [
      {'disease': 'Avian Influenza', 'date': 'Apr 12, 2025', 'severity': 'High', 'resolved': true},
      {'disease': 'Coccidiosis', 'date': 'Mar 25, 2025', 'severity': 'Medium', 'resolved': true},
      {'disease': 'Newcastle Disease', 'date': 'Feb 10, 2025', 'severity': 'Medium', 'resolved': true},
      {'disease': 'Marek\'s Disease', 'date': 'Jan 05, 2025', 'severity': 'Low', 'resolved': true},
    ];
    return ListView(padding: const EdgeInsets.all(16), children: [
      ...history.map((h) {
        final sevColor = h['severity'] == 'High' ? AppTheme.danger : h['severity'] == 'Medium' ? AppTheme.warning : AppTheme.accent;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8F0EC))),
          child: Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: sevColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.bug_report_rounded, color: sevColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(h['disease'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
              Text(h['date'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              StatusChip(label: h['severity'] as String, color: sevColor),
              const SizedBox(height: 4),
              StatusChip(label: 'Resolved', color: AppTheme.accent),
            ]),
          ]),
        );
      }),
    ]);
  }
}