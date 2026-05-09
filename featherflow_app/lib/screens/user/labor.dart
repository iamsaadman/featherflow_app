import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';
import '../../services/labor_api_service.dart';

class LaborScreen extends StatefulWidget {
  const LaborScreen({super.key});
  @override
  State<LaborScreen> createState() => _LaborScreenState();
}

class _LaborScreenState extends State<LaborScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DashboardData? _dashboardData;
  List<Worker> _workers = [];
  List<AttendanceRecord> _todayAttendance = [];
  List<TaskItem> _tasks = [];
  List<WorkScheduleModel> _schedules = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dashboard = await LaborApiService.getDashboard();
      final workers = await LaborApiService.getWorkers();
      final attendance = await LaborApiService.getTodayAttendance();
      final tasks = await LaborApiService.getTasks();
      final schedules = await LaborApiService.getSchedules();
      
      setState(() {
        _dashboardData = dashboard;
        _workers = workers;
        _todayAttendance = attendance;
        _tasks = tasks;
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      print('Load Data Error: $e');
      setState(() {
        _error = 'Backend Connection Error\nCheck if Django is running at http://127.0.0.1:8000';
        _isLoading = false;
      });
    }
  }

  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _wageCtrl = TextEditingController();

  void _showAddWorkerDialog() {
    _nameCtrl.clear(); _roleCtrl.clear(); _phoneCtrl.clear(); _wageCtrl.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Labourer', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _roleCtrl, decoration: const InputDecoration(labelText: 'Role / Position', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _wageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Daily Wage (৳)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () async {
                  if (_nameCtrl.text.isEmpty || _roleCtrl.text.isEmpty || _wageCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
                    return;
                  }
                  final wage = double.tryParse(_wageCtrl.text.replaceAll('৳', '').trim());
                  if (wage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid wage format')));
                    return;
                  }
                  try {
                    await LaborApiService.addWorker(Worker(
                      name: _nameCtrl.text,
                      role: _roleCtrl.text,
                      phone: _phoneCtrl.text,
                      dailyWage: wage,
                    ));
                    Navigator.pop(context);
                    _loadAllData();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Labourer added successfully!'), backgroundColor: Colors.green));
                  } catch (e) {
                    print('Add Labourer Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add labourer: $e'), backgroundColor: Colors.red));
                  }
                },
                child: const Text('Save Labourer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      drawer: const UserDrawer(currentRoute: AppRoutes.labor),
      appBar: AppBar(
        title: const Text('Labor Management'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAllData),
          const SizedBox(width: 8),
          const PremiumBadge(),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.accentLight,
          labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Attendance'),
            Tab(text: 'Tasks'),
            Tab(text: 'Staff'),
            Tab(text: 'Scheduling'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null 
          ? _ErrorState(error: _error!, onRetry: _loadAllData)
          : TabBarView(
              controller: _tabController,
              children: [
                _DashboardTab(data: _dashboardData!),
                _AttendanceTab(records: _todayAttendance, onRefresh: _loadAllData),
                _TasksTab(tasks: _tasks, workers: _workers, onRefresh: _loadAllData),
                _WorkersTab(workers: _workers, onRefresh: _loadAllData, onAdd: _showAddWorkerDialog),
                _SchedulingTab(schedules: _schedules, workers: _workers, onRefresh: _loadAllData),
                _ReportsTab(data: _dashboardData!, workers: _workers),
              ],
            ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry Connection')),
        ],
      ),
    );
  }
}

// ─── TABS ──────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  final DashboardData data;
  const _DashboardTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Today\'s Attendance'),
        Row(
          children: [
            _StatCard(label: 'Present', value: '${data.presentToday}', color: AppTheme.accent),
            const SizedBox(width: 12),
            _StatCard(label: 'Absent', value: '${data.absentToday}', color: AppTheme.danger),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'Work Progress'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _ProgressLine(label: 'Task Completion', value: data.taskCompletionRate / 100, color: AppTheme.primary),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MiniStat(label: 'Pending', value: '${data.pendingTasks}'),
                  _MiniStat(label: 'Done', value: '${data.completedTasks}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'Financials'),
        _StatusCard(
          title: 'Total Pending Wages',
          value: '৳${data.totalPayable.toStringAsFixed(0)}',
          icon: Icons.account_balance_wallet_outlined,
          color: AppTheme.warning,
        ),
      ],
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  final List<AttendanceRecord> records;
  final VoidCallback onRefresh;
  const _AttendanceTab({required this.records, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const Center(child: Text('No attendance data available for today.'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final r = records[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(child: Text(r.workerAvatar)),
            title: Text(r.workerName, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
            subtitle: Text(r.workerRole),
            trailing: _StatusToggle(
              status: r.status,
              onChanged: (val) async {
                await LaborApiService.bulkMarkAttendance(
                  DateTime.now().toIso8601String().split('T')[0],
                  [{'worker_id': r.workerId, 'status': val}]
                );
                onRefresh();
              },
            ),
          ),
        );
      },
    );
  }
}

class _TasksTab extends StatelessWidget {
  final List<TaskItem> tasks;
  final List<Worker> workers;
  final VoidCallback onRefresh;
  const _TasksTab({required this.tasks, required this.workers, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTask(context),
        child: const Icon(Icons.add_task),
      ),
      body: tasks.isEmpty 
        ? const Center(child: Text('No tasks assigned yet.'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final t = tasks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(t.title),
                subtitle: Text('Assigned to: ${t.workerName}'),
                trailing: Chip(
                  label: Text(t.status),
                  backgroundColor: t.status == 'Completed' ? Colors.green[100] : Colors.orange[100],
                ),
                onTap: () async {
                  String nextStatus = t.status == 'Pending' ? 'In Progress' : 'Completed';
                  await LaborApiService.updateTaskStatus(t.id!, nextStatus);
                  onRefresh();
                },
              ),
            );
          },
        ),
    );
  }

  void _showAddTask(BuildContext context) {
    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add staff members first')));
      return;
    }
    int selectedWorkerId = workers.first.id!;
    String selectedPriority = 'Medium';
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(context: context, builder: (_) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Assign New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedWorkerId,
                items: workers.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedWorkerId = val!),
                decoration: const InputDecoration(labelText: 'Assign To'),
              ),
              const SizedBox(height: 12),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
                  DropdownMenuItem(value: 'High', child: Text('High Priority')),
                ],
                onChanged: (val) => setDialogState(() => selectedPriority = val!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter task title')));
                return;
              }
              try {
                await LaborApiService.addTask(TaskItem(
                  workerId: selectedWorkerId,
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  priority: selectedPriority,
                ));
                Navigator.pop(context);
                onRefresh();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task assigned successfully!'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to assign task'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    ));
  }
}

class _WorkersTab extends StatelessWidget {
  final List<Worker> workers;
  final VoidCallback onRefresh;
  final VoidCallback onAdd;
  const _WorkersTab({required this.workers, required this.onRefresh, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: onAdd,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: workers.isEmpty
        ? const Center(child: Text('No staff members added yet.'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workers.length,
          itemBuilder: (context, index) {
            final w = workers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(w.avatar)),
                title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${w.role} • ৳${w.dailyWage}/day'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async {
                    await LaborApiService.deleteWorker(w.id!);
                    onRefresh();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff member removed')));
                  },
                ),
              ),
            );
          },
        ),
    );
  }
}

class _SchedulingTab extends StatelessWidget {
  final List<WorkScheduleModel> schedules;
  final List<Worker> workers;
  final VoidCallback onRefresh;
  const _SchedulingTab({required this.schedules, required this.workers, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _showAddScheduleDialog(context),
        child: const Icon(Icons.add_alarm, color: Colors.white),
      ),
      body: schedules.isEmpty
        ? const Center(child: Text('No schedules created yet.'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final s = schedules[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(s.workerAvatar)),
                title: Text('${s.workerName} - ${s.shift}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${s.taskType} @ ${s.location}\nDate: ${s.date}'),
                isThreeLine: true,
                trailing: s.status == 'Pending' 
                  ? IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        await LaborApiService.updateSchedule(s.id!, {'status': 'Completed'});
                        onRefresh();
                      },
                    )
                  : Chip(
                      label: Text(s.status, style: const TextStyle(fontSize: 10, color: Colors.black)),
                      backgroundColor: s.status == 'Completed' ? Colors.green[100] : (s.status == 'Active' ? Colors.blue[100] : Colors.grey[200]),
                    ),
                onTap: () => _showEditSchedule(context, s),
              ),
            );
          },
        ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add staff members first')));
      return;
    }
    int selectedWorkerId = workers.first.id!;
    String selectedShift = 'Morning';
    final taskCtrl = TextEditingController(text: 'General Work');
    final locCtrl = TextEditingController(text: 'Farm Main Area');

    showDialog(context: context, builder: (_) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Create Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedWorkerId,
                items: workers.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedWorkerId = val!),
                decoration: const InputDecoration(labelText: 'Worker'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedShift,
                items: const [
                  DropdownMenuItem(value: 'Morning', child: Text('Morning (6 AM – 12 PM)')),
                  DropdownMenuItem(value: 'Afternoon', child: Text('Afternoon (12 PM – 6 PM)')),
                  DropdownMenuItem(value: 'Evening', child: Text('Evening (6 PM – 10 PM)')),
                ],
                onChanged: (val) => setDialogState(() => selectedShift = val!),
                decoration: const InputDecoration(labelText: 'Shift'),
              ),
              const SizedBox(height: 12),
              TextField(controller: taskCtrl, decoration: const InputDecoration(labelText: 'Task Type', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await LaborApiService.addSchedule(WorkScheduleModel(
                  workerId: selectedWorkerId,
                  date: DateTime.now().toIso8601String().split('T')[0],
                  shift: selectedShift,
                  taskType: taskCtrl.text,
                  location: locCtrl.text,
                ));
                Navigator.pop(context);
                onRefresh();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule created!'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create schedule'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    ));
  }

  void _showEditSchedule(BuildContext context, WorkScheduleModel s) {
    showModalBottomSheet(context: context, builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: const Text('Mark as Completed'),
          onTap: () async {
            await LaborApiService.updateSchedule(s.id!, {'status': 'Completed'});
            Navigator.pop(context);
            onRefresh();
          },
        ),
        ListTile(
          leading: const Icon(Icons.cancel_outlined, color: Colors.red),
          title: const Text('Cancel Schedule'),
          onTap: () async {
            await LaborApiService.updateSchedule(s.id!, {'status': 'Cancelled'});
            Navigator.pop(context);
            onRefresh();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Delete Permanently'),
          onTap: () async {
            await LaborApiService.deleteSchedule(s.id!);
            Navigator.pop(context);
            onRefresh();
          },
        ),
      ],
    ));
  }
}

class _ReportsTab extends StatelessWidget {
  final DashboardData data;
  final List<Worker> workers;
  const _ReportsTab({required this.data, required this.workers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Labor Insights'),
        Row(
          children: [
            _ReportCard(title: 'Attendance', value: '${data.attendanceRate30d}%', sub: 'Last 30 days', color: Colors.blue),
            const SizedBox(width: 12),
            _ReportCard(title: 'Efficiency', value: '${data.taskCompletionRate}%', sub: 'Task completion', color: Colors.green),
          ],
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'Payroll Summary'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _ReportRow(label: 'Total Paid (30d)', value: '৳${data.totalPaid30d}', color: Colors.green),
              const Divider(),
              _ReportRow(label: 'Total Pending', value: '৳${data.totalPayable}', color: Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: 'Performance Ranking'),
        ...workers.map((w) => ListTile(
          leading: CircleAvatar(child: Text(w.avatar)),
          title: Text(w.name),
          subtitle: Text('Attendance: ${w.attendanceRate}%'),
          trailing: Text('Rank #${workers.indexOf(w) + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
        )),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download),
          label: const Text('Export Full PDF Report'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title, value, sub;
  final Color color;
  const _ReportCard({required this.title, required this.value, required this.sub, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ]),
    ));
  }
}

class _ReportRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReportRow({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
    ]);
  }
}

// ─── HELPERS ───────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    ));
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ProgressLine({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text('${(value * 100).toInt()}%'),
      ]),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: value, backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color)),
    ]);
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
    ]);
  }
}

class _StatusCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatusCard({required this.title, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final String status;
  final Function(String) onChanged;
  const _StatusToggle({required this.status, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isPresent = status == 'Present';
    return Switch(
      value: isPresent,
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
      onChanged: (val) => onChanged(val ? 'Present' : 'Absent'),
    );
  }
}