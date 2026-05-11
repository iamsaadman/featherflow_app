import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';
import '../../services/feed_service.dart';
import '../../services/flock_service.dart';



class FeedManagementScreen extends StatefulWidget {
  const FeedManagementScreen({super.key});

  @override
  State<FeedManagementScreen> createState() => _FeedManagementScreenState();
}

class _FeedManagementScreenState extends State<FeedManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FeedService _feedService = FeedService();
  final FlockService _flockService = FlockService();
  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _breeds = [];


  List<Map<String, dynamic>> _feedStock = [];
  List<Map<String, dynamic>> _schedules = [];
  List<Map<String, dynamic>> _nutritionPlans = [];
  List<Map<String, dynamic>> _feedTypes = [];
  List<Map<String, dynamic>> _consumptionLogs = [];
  List<Map<String, dynamic>> _purchaseOrders = [];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final types = await _feedService.getFeedTypes();
      final stockRaw = await _feedService.getFeedStock();
      final schedulesRaw = await _feedService.getFeedSchedules();
      final nutritionRaw = await _feedService.getFeedNutritionPlans();
      final logsRaw = await _feedService.getFeedConsumptionLogs();
      final ordersRaw = await _feedService.getFeedPurchaseOrders();
      final breedsRaw = await _flockService.getBreeds();

      setState(() {
        _breeds = breedsRaw;
        _feedTypes = types;

        
        _feedStock = stockRaw.map((s) {
          final type = _feedTypes.firstWhere((t) => t['id'] == s['feed_type'], orElse: () => {});
          return {
            'id': s['id'],
            'name': type['name'] ?? 'Unknown',
            'brand': type['brand'] ?? '',
            'stock': (double.parse(s['current_stock'].toString())).toInt(),
            'unit': type['unit'] ?? 'kg',
            'reorder': (double.parse(s['reorder_level'].toString())).toInt(),
            'color': Color(int.parse(type['color']?.replaceAll('#', '0xFF') ?? '0xFF4CAF82')),
            'icon': _getIconData(type['icon_name'] ?? 'grass_rounded'),
          };
        }).toList();

        _schedules = schedulesRaw.map((s) {
          return {
            'id': s['id'],
            'time': s['time'],
            'type': s['feed_type_name'],
            'amount': '${s['amount']} kg',
            'flock': s['flock_name'],
            'done': s['is_done'],
          };
        }).toList();

        _nutritionPlans = nutritionRaw.map((n) {
          return {
            'id': n['id'],
            'name': n['name'],
            'feed_type': n['feed_type_name'],
            'data': [
              {'label': 'Protein', 'value': double.parse(n['protein_percent'].toString()), 'unit': '%', 'target': 22.0, 'color': const Color(0xFF4CAF82)},
              {'label': 'Energy', 'value': double.parse(n['energy_kcal'].toString()), 'unit': 'kcal', 'target': 3200, 'color': const Color(0xFFF4C552)},
              {'label': 'Calcium', 'value': double.parse(n['calcium_percent'].toString()), 'unit': '%', 'target': 1.0, 'color': const Color(0xFF29B6F6)},
              {'label': 'Phosphorus', 'value': double.parse(n['phosphorus_percent'].toString()), 'unit': '%', 'target': 0.50, 'color': const Color(0xFFE53935)},
            ],
          };
        }).toList();

        _consumptionLogs = logsRaw.map((l) {
          return {
            'id': l['id'],
            'date': l['date'],
            'type': l['feed_type_name'],
            'amount': '${l['amount']} kg',
            'flock': l['flock_name'],
          };
        }).toList();

        _purchaseOrders = ordersRaw.map((o) {
          return {
            'id': o['id'],
            'supplier': o['supplier_name'],
            'type': o['feed_type_name'],
            'qty': '${o['quantity']} kg',
            'total': '\$${o['total_price']}',
            'status': o['status'],
            'date': o['order_date'],
          };
        }).toList();

        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'grass_rounded': return Icons.grass_rounded;
      case 'eco_rounded': return Icons.eco_rounded;
      case 'grain_rounded': return Icons.grain_rounded;
      case 'science_rounded': return Icons.science_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.feed),
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Feed Management',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentLight,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Types'),
            Tab(text: 'Schedules'),
            Tab(text: 'Logs'),
            Tab(text: 'Stock'),
            Tab(text: 'Nutrition'),
            Tab(text: 'Orders'),
          ],

        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text('Error: $_error'))
          : Column(
              children: [
                _buildDashboardSummary(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTypesTab(),
                      _buildScheduleTab(),
                      _buildConsumptionTab(),
                      _buildStockTab(),
                      _buildNutritionTab(),
                      _buildPurchasesTab(),
                    ],
                  ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          switch (_tabController.index) {
            case 0: _showAddTypeSheet(); break;
            case 1: _showAddScheduleSheet(); break;
            case 2: _showAddConsumptionSheet(); break;
            case 3: _showAddStockSheet(); break;
            case 4: _showAddNutritionSheet(); break;
            case 5: _showAddOrderSheet(); break;
          }
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Record',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

    );
  }

  Widget _buildDashboardSummary() {
    int totalBirds = _breeds.fold(0, (sum, item) => sum + (item['total_birds'] as int));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FARM OVERVIEW',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$totalBirds Birds Total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: _breeds.length,
              itemBuilder: (context, index) {
                final breed = _breeds[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        index % 2 == 0 ? AppTheme.primary : const Color(0xFF024A37),
                        index % 2 == 0 ? const Color(0xFF024A37) : AppTheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        breed['name'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${breed['total_birds']} birds',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {

    // Daily consumption summary
    const totalConsumed = 185; // kg
    const totalBirds = 6500;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF024A37)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statChip('Today\'s Total', '$totalConsumed kg', Icons.scale_rounded),
                _statChip('Birds', '$totalBirds', Icons.egg_outlined),
                _statChip('Per Bird', '${(totalConsumed * 1000 / totalBirds).toStringAsFixed(0)}g', Icons.restaurant_outlined),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'TODAY\'S FEEDING SCHEDULE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ..._schedules.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return _scheduleCard(s, i);
          }),
          const SizedBox(height: 20),
          Text(
            'WEEKLY CONSUMPTION',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0EC)),
            ),
            child: Column(
              children: [
                ...[
                  {'day': 'Mon', 'kg': 180.0},
                  {'day': 'Tue', 'kg': 192.0},
                  {'day': 'Wed', 'kg': 178.0},
                  {'day': 'Thu', 'kg': 200.0},
                  {'day': 'Fri', 'kg': 195.0},
                  {'day': 'Sat', 'kg': 185.0},
                  {'day': 'Today', 'kg': 130.0},
                ].map((d) {
                  final ratio = (d['kg'] as double) / 210;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            d['day'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 10,
                              backgroundColor: const Color(0xFFE8F0EC),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.accent),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${d['kg']}kg',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alerts
          ..._feedStock.where((f) => (f['stock'] as int) <= (f['reorder'] as int)).map((f) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppTheme.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${f['name']} is low! Only ${f['stock']}${f['unit']} remaining.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Text(
            'FEED INVENTORY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ..._feedStock.map((f) => _stockCard(f)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTypesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _feedTypes.length,
      itemBuilder: (context, index) {
        final t = _feedTypes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8F0EC)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(int.parse(t['color'].replaceAll('#', '0xFF'))).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIconData(t['icon_name']), 
                    color: Color(int.parse(t['color'].replaceAll('#', '0xFF')))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    Text(t['brand'], style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Text(t['unit'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._nutritionPlans.map((plan) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLAN: ${plan['name']} (${plan['feed_type']})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              ...(plan['data'] as List).map((n) => _nutritionCard(n)),
              const SizedBox(height: 20),
            ],
          )),
        ],
      ),
    );
  }


  Widget _buildPurchasesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _purchaseOrders.length,
      itemBuilder: (context, index) {
        final o = _purchaseOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8F0EC)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o['supplier'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    Text('${o['type']} • ${o['qty']}', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
                    Text(o['date'], style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(o['total'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: o['status'] == 'delivered' ? AppTheme.accent.withOpacity(0.1) : AppTheme.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(o['status'].toString().toUpperCase(), style: TextStyle(fontSize: 10, color: o['status'] == 'delivered' ? AppTheme.accent : AppTheme.warning, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildConsumptionTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _consumptionLogs.length,
      itemBuilder: (context, index) {
        final l = _consumptionLogs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8F0EC)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l['type'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    Text(l['flock'], style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
                    Text(l['date'], style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Text(l['amount'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSuppliersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FEED SUPPLIERS',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          // Placeholder for suppliers
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0EC)),
            ),
            child: Center(
              child: Text('Supplier management and low stock alerts will be displayed here',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: AppTheme.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FEED REPORTS',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          // Placeholder for reports
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0EC)),
            ),
            child: Center(
              child: Text('Monthly, yearly, and lifetime feed reports with export options will be displayed here',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: AppTheme.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FEED PAYMENTS',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          // Placeholder for payments
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0EC)),
            ),
            child: Center(
              child: Text('Feed payment section and cost tracking will be displayed here',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: AppTheme.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentLight, size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10, color: Colors.white60)),
      ],
    );
  }

  Widget _scheduleCard(Map<String, dynamic> s, int i) {
    final done = s['done'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFF0FAF5) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: done ? AppTheme.accent.withOpacity(0.4) : const Color(0xFFE8F0EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: done
                  ? AppTheme.accent.withOpacity(0.15)
                  : const Color(0xFFF0F6F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              done ? Icons.check_circle_rounded : Icons.schedule_rounded,
              color: done ? AppTheme.accent : AppTheme.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['time'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                Text('${s['type']} • ${s['amount']}',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: AppTheme.textSecondary)),
                Text(s['flock'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          if (!done)
            GestureDetector(
              onTap: () async {
                try {
                  await _feedService.updateScheduleStatus(s['id'], true);
                  _fetchData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating status: $e')),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Done',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            )
          else
            Text('Done',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent)),
        ],
      ),
    );
  }


  Widget _stockCard(Map<String, dynamic> f) {
    final stock = f['stock'] as int;
    final reorder = f['reorder'] as int;
    final isLow = stock <= reorder;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLow
              ? AppTheme.warning.withOpacity(0.4)
              : const Color(0xFFE8F0EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (f['color'] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(f['icon'] as IconData,
                size: 22, color: f['color'] as Color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f['name'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                Text(f['brand'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$stock ${f['unit']}',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          isLow ? AppTheme.warning : AppTheme.textPrimary)),
              Text('Reorder: $reorder ${f['unit']}',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionCard(Map<String, dynamic> n) {
    final ratio = (n['value'] as num) / (n['target'] as num);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8F0EC)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(n['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${n['value']}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: n['color'] as Color),
                    ),
                    TextSpan(
                      text: ' / ${n['target']} ${n['unit']}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE8F0EC),
              valueColor:
                  AlwaysStoppedAnimation<Color>(n['color'] as Color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formulaRow(String ingredient, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(ingredient,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500)),
          ),
          Text(percent,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
  void _showAddTypeSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final unitController = TextEditingController(text: 'kg');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Feed Type', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Feed Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
              const SizedBox(height: 16),
              TextFormField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit (e.g. kg)')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await _feedService.createFeedType({
                        'name': nameController.text,
                        'brand': brandController.text,
                        'unit': unitController.text,
                        'icon_name': 'grass_rounded',
                        'color': '#4CAF82',
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Create Type'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddScheduleSheet() {
    final formKey = GlobalKey<FormState>();
    final timeController = TextEditingController(text: '08:00');
    final amountController = TextEditingController();
    final flockController = TextEditingController();
    int? selectedFeedTypeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Schedule', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                items: _feedTypes.map((t) => DropdownMenuItem(value: t['id'] as int, child: Text(t['name']))).toList(),
                onChanged: (v) => selectedFeedTypeId = v,
                decoration: const InputDecoration(labelText: 'Feed Type'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: timeController, decoration: const InputDecoration(labelText: 'Time (HH:mm)')),
              const SizedBox(height: 16),
              TextFormField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount (kg)'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: flockController, decoration: const InputDecoration(labelText: 'Flock Name')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && selectedFeedTypeId != null) {
                    try {
                      await _feedService.createFeedSchedule({
                        'feed_type': selectedFeedTypeId,
                        'time': timeController.text,
                        'amount': double.parse(amountController.text),
                        'flock_name': flockController.text,
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Add Schedule'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddConsumptionSheet() {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final flockController = TextEditingController();
    int? selectedFeedTypeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Log Consumption', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                items: _feedTypes.map((t) => DropdownMenuItem(value: t['id'] as int, child: Text(t['name']))).toList(),
                onChanged: (v) => selectedFeedTypeId = v,
                decoration: const InputDecoration(labelText: 'Feed Type'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: amountController, decoration: const InputDecoration(labelText: 'Quantity (kg)'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: flockController, decoration: const InputDecoration(labelText: 'Flock Name')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && selectedFeedTypeId != null) {
                    try {
                      await _feedService.addFeedConsumptionLog({
                        'feed_type': selectedFeedTypeId,
                        'amount': double.parse(amountController.text),
                        'flock_name': flockController.text,
                        'date': DateTime.now().toIso8601String().split('T')[0],
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Log Feed'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddStockSheet() {
    final formKey = GlobalKey<FormState>();
    final stockController = TextEditingController();
    final reorderController = TextEditingController(text: '100');
    int? selectedFeedTypeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Initialize Stock', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                items: _feedTypes.map((t) => DropdownMenuItem(value: t['id'] as int, child: Text(t['name']))).toList(),
                onChanged: (v) => selectedFeedTypeId = v,
                decoration: const InputDecoration(labelText: 'Feed Type'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: stockController, decoration: const InputDecoration(labelText: 'Current Stock'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: reorderController, decoration: const InputDecoration(labelText: 'Reorder Level'), keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && selectedFeedTypeId != null) {
                    try {
                      await _feedService.createFeedStock({
                        'feed_type': selectedFeedTypeId,
                        'current_stock': double.parse(stockController.text),
                        'reorder_level': double.parse(reorderController.text),
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Add Stock'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNutritionSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final proteinController = TextEditingController();
    final energyController = TextEditingController();
    int? selectedFeedTypeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Nutrition Plan', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Plan Name')),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                items: _feedTypes.map((t) => DropdownMenuItem(value: t['id'] as int, child: Text(t['name']))).toList(),
                onChanged: (v) => selectedFeedTypeId = v,
                decoration: const InputDecoration(labelText: 'Target Feed'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: proteinController, decoration: const InputDecoration(labelText: 'Protein %'), keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && selectedFeedTypeId != null) {
                    try {
                      await _feedService.createFeedNutritionPlan({
                        'name': nameController.text,
                        'feed_type': selectedFeedTypeId,
                        'protein_percent': double.parse(proteinController.text),
                        'energy_kcal': double.parse(energyController.text.isEmpty ? '0' : energyController.text),
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Create Plan'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOrderSheet() {
    final formKey = GlobalKey<FormState>();
    final supplierController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    int? selectedFeedTypeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('New Purchase Order', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(controller: supplierController, decoration: const InputDecoration(labelText: 'Supplier Name')),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                items: _feedTypes.map((t) => DropdownMenuItem(value: t['id'] as int, child: Text(t['name']))).toList(),
                onChanged: (v) => selectedFeedTypeId = v,
                decoration: const InputDecoration(labelText: 'Feed Type'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: priceController, decoration: const InputDecoration(labelText: 'Total Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && selectedFeedTypeId != null) {
                    try {
                      await _feedService.createFeedPurchaseOrder({
                        'feed_type': selectedFeedTypeId,
                        'supplier_name': supplierController.text,
                        'quantity': double.parse(qtyController.text),
                        'total_price': double.parse(priceController.text),
                        'order_date': DateTime.now().toIso8601String().split('T')[0],
                        'status': 'pending',
                      });
                      Navigator.pop(ctx);
                      _fetchData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Submit Order'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
