import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class CostManagementScreen extends StatefulWidget {
  const CostManagementScreen({super.key});

  @override
  State<CostManagementScreen> createState() => _CostManagementScreenState();
}

class _CostManagementScreenState extends State<CostManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.list_alt_rounded, 'color': AppTheme.primary},
    {'label': 'Feed', 'icon': Icons.grass_rounded, 'color': Color(0xFF4CAF82)},
    {'label': 'Medicine', 'icon': Icons.medication_rounded, 'color': Color(0xFF29B6F6)},
    {'label': 'Labor', 'icon': Icons.people_alt_rounded, 'color': Color(0xFFF4C552)},
    {'label': 'Utility', 'icon': Icons.bolt_rounded, 'color': Color(0xFFE53935)},
    {'label': 'Other', 'icon': Icons.more_horiz_rounded, 'color': Color(0xFF9E9E9E)},
  ];

  final List<Map<String, dynamic>> _expenses = [
    {
      'title': 'Broiler Feed Bag (50kg)',
      'category': 'Feed',
      'amount': 3200.0,
      'date': 'Today, 9:30 AM',
      'icon': Icons.grass_rounded,
      'color': Color(0xFF4CAF82),
    },
    {
      'title': 'Newcastle Vaccine',
      'category': 'Medicine',
      'amount': 850.0,
      'date': 'Today, 8:00 AM',
      'icon': Icons.medication_rounded,
      'color': Color(0xFF29B6F6),
    },
    {
      'title': 'Daily Labor (3 workers)',
      'category': 'Labor',
      'amount': 1500.0,
      'date': 'Yesterday',
      'icon': Icons.people_alt_rounded,
      'color': Color(0xFFF4C552),
    },
    {
      'title': 'Electricity Bill',
      'category': 'Utility',
      'amount': 4200.0,
      'date': '28 Apr',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'title': 'Vitamin Supplement',
      'category': 'Medicine',
      'amount': 620.0,
      'date': '27 Apr',
      'icon': Icons.medication_rounded,
      'color': Color(0xFF29B6F6),
    },
    {
      'title': 'Layer Feed (100kg)',
      'category': 'Feed',
      'amount': 5800.0,
      'date': '26 Apr',
      'icon': Icons.grass_rounded,
      'color': Color(0xFF4CAF82),
    },
  ];

  final Map<String, double> _budgetByCategory = {
    'Feed': 20000,
    'Medicine': 5000,
    'Labor': 15000,
    'Utility': 8000,
    'Other': 3000,
  };

  final Map<String, double> _spentByCategory = {
    'Feed': 9000,
    'Medicine': 1470,
    'Labor': 1500,
    'Utility': 4200,
    'Other': 0,
  };

  double get _totalBudget =>
      _budgetByCategory.values.fold(0, (a, b) => a + b);

  double get _totalSpent =>
      _spentByCategory.values.fold(0, (a, b) => a + b);

  List<Map<String, dynamic>> get _filteredExpenses {
    if (_selectedCategory == 0) return _expenses;
    final cat = _categories[_selectedCategory]['label'];
    return _expenses.where((e) => e['category'] == cat).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.cost),
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cost Management',
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
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    size: 14, color: AppTheme.gold),
                const SizedBox(width: 4),
                Text(
                  'Premium',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentLight,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Budget'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExpensesTab(),
          _buildBudgetTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseSheet,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Expense',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'Total Spent',
                  '৳${_totalSpent.toStringAsFixed(0)}',
                  'This Month',
                  Icons.trending_down_rounded,
                  AppTheme.danger,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _summaryCard(
                  'Remaining',
                  '৳${(_totalBudget - _totalSpent).toStringAsFixed(0)}',
                  'Budget Left',
                  Icons.savings_rounded,
                  AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Budget progress card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F0EC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Budget Usage',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${((_totalSpent / _totalBudget) * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _totalSpent / _totalBudget,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE8F0EC),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.accent),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '৳${_totalSpent.toStringAsFixed(0)} spent',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: AppTheme.textSecondary),
                    ),
                    Text(
                      '৳${_totalBudget.toStringAsFixed(0)} total',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Category filter
          Text(
            'FILTER BY CATEGORY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? (cat['color'] as Color)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? (cat['color'] as Color)
                            : const Color(0xFFD4E4DF),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 14,
                          color: selected
                              ? Colors.white
                              : (cat['color'] as Color),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Expense list
          Text(
            'RECENT EXPENSES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          ..._filteredExpenses.map((e) => _expenseTile(e)),
        ],
      ),
    );
  }

  Widget _buildBudgetTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF024A37)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 28),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Budget',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      '৳${_totalBudget.toStringAsFixed(0)}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'BUDGET BY CATEGORY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ..._budgetByCategory.entries.map((entry) {
            final cat = entry.key;
            final budget = entry.value;
            final spent = _spentByCategory[cat] ?? 0;
            final ratio = spent / budget;
            final catData = _categories.firstWhere(
                (c) => c['label'] == cat,
                orElse: () => _categories.last);
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
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: (catData['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(catData['icon'] as IconData,
                            size: 18, color: catData['color'] as Color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary)),
                            Text('৳$spent / ৳$budget',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Text(
                        '${(ratio * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: ratio > 0.8
                              ? AppTheme.danger
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ratio.clamp(0.0, 1.0),
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE8F0EC),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ratio > 0.8
                            ? AppTheme.danger
                            : catData['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, String sub, IconData icon,
      Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, color: AppTheme.textSecondary)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          Text(sub,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _expenseTile(Map<String, dynamic> e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8F0EC)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (e['color'] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(e['icon'] as IconData,
                size: 20, color: e['color'] as Color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                Text(e['date'] as String,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Text(
            '-৳${(e['amount'] as double).toStringAsFixed(0)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.danger,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseSheet() {
    String _selectedCat = 'Feed';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Add Expense',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g. Feed bag purchase',
                  prefixIcon:
                      const Icon(Icons.description_outlined, size: 20),
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (৳)',
                  hintText: '0.00',
                  prefixIcon:
                      const Icon(Icons.attach_money_rounded, size: 20),
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedCat,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined, size: 20),
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4E4DF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4E4DF)),
                  ),
                ),
                items: ['Feed', 'Medicine', 'Labor', 'Utility', 'Other']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style:
                                  GoogleFonts.plusJakartaSans(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) => setSheetState(() => _selectedCat = v!),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Save Expense',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}