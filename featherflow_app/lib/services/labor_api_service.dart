import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── Data Models ─────────────────────────────────────────

class Worker {
  final int? id;
  final String name;
  final String role;
  final String phone;
  final double dailyWage;
  final String avatar;
  final bool isActive;
  final String? hiredDate;
  final double? attendanceRate;
  final double? pendingWages;

  Worker({
    this.id,
    required this.name,
    required this.role,
    this.phone = '',
    this.dailyWage = 0,
    this.avatar = '👤',
    this.isActive = true,
    this.hiredDate,
    this.attendanceRate,
    this.pendingWages,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      dailyWage: double.tryParse(json['daily_wage']?.toString() ?? '0') ?? 0,
      avatar: json['avatar'] ?? '👤',
      isActive: json['is_active'] ?? true,
      hiredDate: json['hired_date'],
      attendanceRate: (json['attendance_rate'] as num?)?.toDouble(),
      pendingWages: (json['pending_wages'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    'phone': phone,
    'daily_wage': dailyWage.toString(),
    'avatar': avatar,
    'is_active': isActive,
  };
}

class AttendanceRecord {
  final int? id;
  final int workerId;
  final String workerName;
  final String workerAvatar;
  final String workerRole;
  final String date;
  final String status;

  AttendanceRecord({
    this.id,
    required this.workerId,
    this.workerName = '',
    this.workerAvatar = '👤',
    this.workerRole = '',
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      workerId: json['worker_id'] ?? json['worker'] ?? 0,
      workerName: json['worker_name'] ?? '',
      workerAvatar: json['worker_avatar'] ?? '👤',
      workerRole: json['worker_role'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Not Marked',
    );
  }
}

class WorkScheduleModel {
  final int? id;
  final int workerId;
  final String workerName;
  final String workerAvatar;
  final String date;
  final String shift;
  final String taskType;
  final String location;
  final String status;
  final String description;

  WorkScheduleModel({
    this.id,
    required this.workerId,
    this.workerName = '',
    this.workerAvatar = '👤',
    required this.date,
    required this.shift,
    this.taskType = 'General Work',
    this.location = 'Farm Main Area',
    this.status = 'Pending',
    this.description = '',
  });

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkScheduleModel(
      id: json['id'],
      workerId: json['worker'] ?? 0,
      workerName: json['worker_name'] ?? '',
      workerAvatar: json['worker_avatar'] ?? '👤',
      date: json['date'] ?? '',
      shift: json['shift'] ?? 'Morning',
      taskType: json['task_type'] ?? 'General Work',
      location: json['location'] ?? 'Farm Main Area',
      status: json['status'] ?? 'Pending',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'worker': workerId,
    'date': date,
    'shift': shift,
    'task_type': taskType,
    'location': location,
    'status': status,
    'description': description,
  };
}

class TaskItem {
  final int? id;
  final int workerId;
  final String workerName;
  final String workerAvatar;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String? assignedDate;
  final String? dueDate;

  TaskItem({
    this.id,
    required this.workerId,
    this.workerName = '',
    this.workerAvatar = '👤',
    required this.title,
    this.description = '',
    this.status = 'Pending',
    this.priority = 'Medium',
    this.assignedDate,
    this.dueDate,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      workerId: json['worker'] ?? 0,
      workerName: json['worker_name'] ?? '',
      workerAvatar: json['worker_avatar'] ?? '👤',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      priority: json['priority'] ?? 'Medium',
      assignedDate: json['assigned_date'],
      dueDate: json['due_date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'worker': workerId,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'due_date': dueDate,
  };
}

class WageRecord {
  final int? id;
  final int workerId;
  final String workerName;
  final String workerAvatar;
  final String date;
  final double amount;
  final double bonus;
  final double deduction;
  final double total;
  final bool isPaid;
  final String? paidDate;

  WageRecord({
    this.id,
    required this.workerId,
    this.workerName = '',
    this.workerAvatar = '👤',
    required this.date,
    this.amount = 0,
    this.bonus = 0,
    this.deduction = 0,
    this.total = 0,
    this.isPaid = false,
    this.paidDate,
  });

  factory WageRecord.fromJson(Map<String, dynamic> json) {
    return WageRecord(
      id: json['id'],
      workerId: json['worker'] ?? 0,
      workerName: json['worker_name'] ?? '',
      workerAvatar: json['worker_avatar'] ?? '👤',
      date: json['date'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      bonus: double.tryParse(json['bonus']?.toString() ?? '0') ?? 0,
      deduction: double.tryParse(json['deduction']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      isPaid: json['is_paid'] ?? false,
      paidDate: json['paid_date'],
    );
  }
}

class DashboardData {
  final int totalWorkers;
  final int presentToday;
  final int absentToday;
  final int lateToday;
  final int unmarkedToday;
  final double attendanceRate30d;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final int totalTasks;
  final double taskCompletionRate;
  final double totalPayable;
  final double totalPaid30d;

  DashboardData({
    this.totalWorkers = 0,
    this.presentToday = 0,
    this.absentToday = 0,
    this.lateToday = 0,
    this.unmarkedToday = 0,
    this.attendanceRate30d = 0,
    this.pendingTasks = 0,
    this.inProgressTasks = 0,
    this.completedTasks = 0,
    this.totalTasks = 0,
    this.taskCompletionRate = 0,
    this.totalPayable = 0,
    this.totalPaid30d = 0,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final today = json['today'] ?? {};
    final tasks = json['tasks'] ?? {};
    final wages = json['wages'] ?? {};
    return DashboardData(
      totalWorkers: json['total_workers'] ?? 0,
      presentToday: today['present'] ?? 0,
      absentToday: today['absent'] ?? 0,
      lateToday: today['late'] ?? 0,
      unmarkedToday: today['unmarked'] ?? 0,
      attendanceRate30d: (json['attendance_rate_30d'] as num?)?.toDouble() ?? 0,
      pendingTasks: tasks['pending'] ?? 0,
      inProgressTasks: tasks['in_progress'] ?? 0,
      completedTasks: tasks['completed'] ?? 0,
      totalTasks: tasks['total'] ?? 0,
      taskCompletionRate: (tasks['completion_rate'] as num?)?.toDouble() ?? 0,
      totalPayable: (wages['total_payable'] as num?)?.toDouble() ?? 0,
      totalPaid30d: (wages['total_paid_30d'] as num?)?.toDouble() ?? 0,
    );
  }
}

// ─── API Service ─────────────────────────────────────────

class LaborApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/labor';
  static const _headers = {'Content-Type': 'application/json'};

  // ── Dashboard ──
  static Future<DashboardData> getDashboard() async {
    final r = await http.get(Uri.parse('$_baseUrl/dashboard/'));
    if (r.statusCode == 200) return DashboardData.fromJson(json.decode(r.body));
    throw Exception('Failed to load dashboard');
  }

  // ── Workers ──
  static Future<List<Worker>> getWorkers() async {
    final r = await http.get(Uri.parse('$_baseUrl/workers/'));
    if (r.statusCode == 200) {
      return (json.decode(r.body) as List).map((j) => Worker.fromJson(j)).toList();
    }
    throw Exception('Failed to load workers');
  }

  static Future<Worker> addWorker(Worker worker) async {
    final r = await http.post(Uri.parse('$_baseUrl/workers/'), headers: _headers, body: json.encode(worker.toJson()));
    if (r.statusCode == 201) return Worker.fromJson(json.decode(r.body));
    print('Add Worker Failed: ${r.body}');
    throw Exception('Failed to add worker: ${r.body}');
  }

  static Future<void> deleteWorker(int id) async {
    final r = await http.delete(Uri.parse('$_baseUrl/workers/$id/'));
    if (r.statusCode != 204) {
      print('Delete Worker Failed: ${r.body}');
      throw Exception('Failed to delete worker');
    }
  }

  // ── Attendance ──
  static Future<List<AttendanceRecord>> getTodayAttendance() async {
    final r = await http.get(Uri.parse('$_baseUrl/attendance/today/'));
    if (r.statusCode == 200) {
      return (json.decode(r.body) as List).map((j) => AttendanceRecord.fromJson(j)).toList();
    }
    throw Exception('Failed to load attendance');
  }

  static Future<void> bulkMarkAttendance(String date, List<Map<String, dynamic>> records) async {
    final r = await http.post(
      Uri.parse('$_baseUrl/attendance/mark/'),
      headers: _headers,
      body: json.encode({'date': date, 'records': records}),
    );
    if (r.statusCode != 200) {
      print('Mark Attendance Failed: ${r.body}');
      throw Exception('Failed to mark attendance: ${r.body}');
    }
  }

  // ── Schedules ──
  static Future<List<WorkScheduleModel>> getSchedules() async {
    final r = await http.get(Uri.parse('$_baseUrl/schedules/'));
    if (r.statusCode == 200) {
      return (json.decode(r.body) as List).map((j) => WorkScheduleModel.fromJson(j)).toList();
    }
    throw Exception('Failed to load schedules');
  }

  static Future<WorkScheduleModel> addSchedule(WorkScheduleModel schedule) async {
    final r = await http.post(Uri.parse('$_baseUrl/schedules/'), headers: _headers, body: json.encode(schedule.toJson()));
    if (r.statusCode == 201) return WorkScheduleModel.fromJson(json.decode(r.body));
    print('Add Schedule Failed: ${r.body}');
    throw Exception('Failed to add schedule: ${r.body}');
  }

  static Future<WorkScheduleModel> updateSchedule(int id, Map<String, dynamic> data) async {
    final r = await http.patch(Uri.parse('$_baseUrl/schedules/$id/'), headers: _headers, body: json.encode(data));
    if (r.statusCode == 200) return WorkScheduleModel.fromJson(json.decode(r.body));
    print('Update Schedule Failed: ${r.body}');
    throw Exception('Failed to update schedule: ${r.body}');
  }

  static Future<void> deleteSchedule(int id) async {
    final r = await http.delete(Uri.parse('$_baseUrl/schedules/$id/'));
    if (r.statusCode != 204) {
      print('Delete Schedule Failed: ${r.body}');
      throw Exception('Failed to delete schedule');
    }
  }

  // ── Tasks ──
  static Future<List<TaskItem>> getTasks({String? status}) async {
    String url = '$_baseUrl/tasks/';
    if (status != null) url += '?status=$status';
    final r = await http.get(Uri.parse(url));
    if (r.statusCode == 200) {
      return (json.decode(r.body) as List).map((j) => TaskItem.fromJson(j)).toList();
    }
    throw Exception('Failed to load tasks');
  }

  static Future<TaskItem> addTask(TaskItem task) async {
    final body = task.toJson();
    if (task.dueDate == null) body.remove('due_date');
    final r = await http.post(Uri.parse('$_baseUrl/tasks/'), headers: _headers, body: json.encode(body));
    if (r.statusCode == 201) return TaskItem.fromJson(json.decode(r.body));
    print('Add Task Failed: ${r.body}');
    throw Exception('Error: ${r.body}');
  }

  static Future<void> updateTaskStatus(int id, String newStatus) async {
    final r = await http.patch(
      Uri.parse('$_baseUrl/tasks/$id/'),
      headers: _headers,
      body: json.encode({'status': newStatus}),
    );
    if (r.statusCode != 200) {
      print('Update Task Failed: ${r.body}');
      throw Exception('Update failed: ${r.body}');
    }
  }

  // ── Wages ──
  static Future<List<WageRecord>> getWages({bool? isPaid}) async {
    String url = '$_baseUrl/wages/';
    if (isPaid != null) url += '?is_paid=$isPaid';
    final r = await http.get(Uri.parse(url));
    if (r.statusCode == 200) {
      return (json.decode(r.body) as List).map((j) => WageRecord.fromJson(j)).toList();
    }
    throw Exception('Failed to load wages');
  }

  static Future<void> markWagePaid(int id) async {
    final r = await http.post(Uri.parse('$_baseUrl/wages/$id/pay/'));
    if (r.statusCode != 200) throw Exception('Failed to mark wage paid');
  }
}
