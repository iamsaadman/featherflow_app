import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  String _selectedRole = 'Farmer';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _consentTerms = false;
  bool _consentBackground = false;
  bool _consentConfidentiality = false;

  // All 6 roles — same as login
  final List<String> roles = [
    'Farmer',
    'Admin',
    'Doctor',
    'Delivery',
    'Pharmacy',
    'Researcher',
  ];

  final Map<String, String> _roleRoutes = {
    'Farmer': AppRoutes.userDashboard,
    'Admin': AppRoutes.adminDashboard,
    'Doctor': AppRoutes.doctorDashboard,
    'Delivery': AppRoutes.deliveryDashboard,
    'Pharmacy': AppRoutes.pharmacyDashboard,
    'Researcher': AppRoutes.researcherDashboard,
  };

  final Map<String, IconData> _roleIcons = {
    'Farmer': Icons.agriculture_rounded,
    'Admin': Icons.admin_panel_settings_rounded,
    'Doctor': Icons.medical_services_rounded,
    'Delivery': Icons.delivery_dining_rounded,
    'Pharmacy': Icons.local_pharmacy_rounded,
    'Researcher': Icons.science_rounded,
  };

  final Map<String, String> _roleDesc = {
    'Farmer': 'Manage your poultry farm, track health & sales',
    'Admin': 'Oversee platform operations and all users',
    'Doctor': 'Connect with farmers, provide vet consultations',
    'Delivery': 'Handle feed, medicine & product deliveries',
    'Pharmacy': 'Manage medicines and supply to farmers',
    'Researcher': 'Publish research, share disease discoveries',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _signup() {
    final route = _roleRoutes[_selectedRole] ?? AppRoutes.userDashboard;
    Navigator.pushReplacementNamed(context, route);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Widget _gap() => const SizedBox(height: 14);

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 6),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    bool showToggle = false,
    VoidCallback? onToggle,
  }) =>
      TextField(
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: showToggle
              ? GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                )
              : null,
          labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
      );

  Widget _dropdown(
          {required String label,
          required IconData icon,
          required List<String> items}) =>
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.accent, width: 2),
          ),
        ),
        hint: Text('Select...', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                ))
            .toList(),
        onChanged: (_) {},
      );

  // ─── Role-specific fields ──────────────────────────────────────────────────

  Widget _farmerFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('FARM DETAILS'),
          _field(label: 'Farm Name', hint: 'Green Valley Poultry', icon: Icons.home_work_outlined),
          _gap(),
          _field(label: 'Farm Owner/Manager Name', hint: 'Owner name', icon: Icons.person_outline_rounded),
          _gap(),
          _field(label: 'Farm Location and Exact Address', hint: 'District, full address', icon: Icons.location_on_outlined),
          _gap(),
          _dropdown(label: 'Farm Type', icon: Icons.category_outlined, items: ['Broiler', 'Layer', 'Breeder', 'Hatchery', 'Mixed', 'Backyard']),
          _gap(),
          _field(label: 'Number of Birds Currently Kept', hint: 'e.g. 5000', icon: Icons.egg_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Farm Registration/Licensing Number', hint: 'Registration number', icon: Icons.verified_outlined),
          _gap(),
          _field(label: 'Years in Poultry Farming', hint: 'e.g. 5', icon: Icons.timeline_outlined, keyboardType: TextInputType.number),
          _gap(),
          _dropdown(label: 'Experience Level', icon: Icons.star_outline, items: ['Beginner', 'Intermediate', 'Advanced', 'Expert']),
          _gap(),
          _field(label: 'Primary Disease/Issues Faced', hint: 'e.g. Newcastle, Coccidiosis', icon: Icons.sick_outlined),
          _gap(),
          _field(label: 'Feed Type and Sourcing Method', hint: 'e.g. Commercial, Local', icon: Icons.grass_rounded),
          _gap(),
          _field(label: 'Existing Vet or Consultant', hint: 'Vet name or N/A', icon: Icons.medical_services_rounded),
          _gap(),
          _field(label: 'Academic Background (Optional)', hint: 'Degree or N/A', icon: Icons.school_outlined),
          _gap(),
          _field(label: 'Number of Active Workers', hint: 'e.g. 10', icon: Icons.people_outlined, keyboardType: TextInputType.number),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentBackground,
                onChanged: (v) => setState(() => _consentBackground = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Consent for flock health and performance tracking',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _adminFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('ADMIN DETAILS'),
          _field(label: 'Account ID Number', hint: 'Admin ID', icon: Icons.account_circle_outlined),
          _gap(),
          _field(label: 'Job Title', hint: 'e.g. Operations Manager', icon: Icons.work_outline_rounded),
          _gap(),
          _field(label: 'Department', hint: 'e.g. IT, HR', icon: Icons.business_outlined),
          _gap(),
          _field(label: 'Reporting Manager', hint: 'Manager name', icon: Icons.supervisor_account_outlined),
          _gap(),
          _field(label: 'Work Location', hint: 'Office location', icon: Icons.location_city_outlined),
          _gap(),
          _dropdown(label: 'Employment Type', icon: Icons.schedule_outlined, items: ['Full-time', 'Part-time', 'Contract']),
          _gap(),
          _field(label: 'Start Date', hint: 'DD/MM/YYYY', icon: Icons.date_range_outlined),
          _gap(),
          _dropdown(label: 'Access Level Requested', icon: Icons.security_outlined, items: ['Basic', 'Standard', 'Admin', 'Super Admin']),
          _gap(),
          _field(label: 'Prior Admin/Operations Experience', hint: 'Years or description', icon: Icons.work_outline_rounded),
          _gap(),
          _dropdown(label: 'Basic Tech Skill Level', icon: Icons.computer_outlined, items: ['Beginner', 'Intermediate', 'Advanced']),
          _gap(),
          _field(label: 'Previous Work Experience', hint: 'Company and role', icon: Icons.history_outlined),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentConfidentiality,
                onChanged: (v) => setState(() => _consentConfidentiality = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Confidentiality agreement acceptance',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentBackground,
                onChanged: (v) => setState(() => _consentBackground = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Background check consent',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
          _gap(),
          _field(label: 'Approved by Admin Name and ID', hint: 'Approver details', icon: Icons.verified_user_outlined),
        ],
      );

  Widget _doctorFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('PROFESSIONAL DETAILS'),
          _field(label: 'Clinic/Hospital Name', hint: 'Clinic name', icon: Icons.local_hospital_outlined),
          _gap(),
          _field(label: 'Practice Address', hint: 'Full address', icon: Icons.location_on_outlined),
          _gap(),
          _field(label: 'Veterinary Degree', hint: 'Degree name', icon: Icons.school_outlined),
          _gap(),
          _field(label: 'University Name', hint: 'University', icon: Icons.account_balance_outlined),
          _gap(),
          _field(label: 'Graduation Year', hint: 'e.g. 2015', icon: Icons.calendar_view_day_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'License/Registration Number', hint: 'License number', icon: Icons.badge_outlined),
          _gap(),
          _field(label: 'License Issuing Authority', hint: 'Authority name', icon: Icons.gavel_outlined),
          _gap(),
          _field(label: 'License Expiry Date', hint: 'DD/MM/YYYY', icon: Icons.date_range_outlined),
          _gap(),
          _field(label: 'Specialty or Poultry Focus Area', hint: 'e.g. Poultry Health', icon: Icons.biotech_outlined),
          _gap(),
          _field(label: 'Years of Experience', hint: 'e.g. 5', icon: Icons.workspace_premium_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Current Workplace', hint: 'Workplace name', icon: Icons.business_center_outlined),
          _gap(),
          _dropdown(label: 'Consultation Mode', icon: Icons.video_call_outlined, items: ['Online', 'Offline', 'Both']),
          _gap(),
          _field(label: 'Consultation Fees', hint: 'Fee amount', icon: Icons.attach_money_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Prescription Authority', hint: 'Yes/No', icon: Icons.edit_outlined),
          _gap(),
          _field(label: 'Emergency/On-call Availability', hint: 'Yes/No', icon: Icons.access_time_outlined),
          _gap(),
          _field(label: 'Referral Network', hint: 'Network details', icon: Icons.group_outlined),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentTerms,
                onChanged: (v) => setState(() => _consentTerms = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Consent to treatment guidelines',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _deliveryFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('DELIVERY DETAILS'),
          _field(label: 'Driver\'s License Number', hint: 'License number', icon: Icons.drive_eta_outlined),
          _gap(),
          _field(label: 'License Expiry Date', hint: 'DD/MM/YYYY', icon: Icons.date_range_outlined),
          _gap(),
          _dropdown(label: 'Vehicle Type', icon: Icons.local_shipping_outlined, items: ['Motorcycle', 'Van', 'Truck', 'Car']),
          _gap(),
          _field(label: 'Vehicle Registration Number', hint: 'e.g. DHA-12-3456', icon: Icons.directions_car_outlined),
          _gap(),
          _field(label: 'Vehicle Insurance Details', hint: 'Insurance info', icon: Icons.shield_outlined),
          _gap(),
          _field(label: 'Proof of Right to Work', hint: 'Document details', icon: Icons.verified_outlined),
          _gap(),
          _field(label: 'Emergency Contact', hint: 'Name and phone', icon: Icons.contact_phone_outlined),
          _gap(),
          _field(label: 'Prior Delivery Experience', hint: 'Years or description', icon: Icons.delivery_dining_rounded),
          _gap(),
          _field(label: 'Area Coverage', hint: 'Areas served', icon: Icons.map_outlined),
          _gap(),
          _field(label: 'Availability/Schedule', hint: 'e.g. Full-time, Weekends', icon: Icons.schedule_outlined),
          _gap(),
          _field(label: 'Banking/Mobile Wallet Details', hint: 'Account details', icon: Icons.account_balance_wallet_outlined),
          _gap(),
          _field(label: 'Previous Work Experience', hint: 'Company and role', icon: Icons.history_outlined),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentBackground,
                onChanged: (v) => setState(() => _consentBackground = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Background check consent',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
          _gap(),
          _field(label: 'Approved by Admin Name and ID', hint: 'Approver details', icon: Icons.verified_user_outlined),
        ],
      );

  Widget _pharmacyFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('PHARMACY DETAILS'),
          _field(label: 'Business/Organization Name', hint: 'Pharmacy name', icon: Icons.business_outlined),
          _gap(),
          _field(label: 'Authorized Contact Person', hint: 'Contact name', icon: Icons.person_outline_rounded),
          _gap(),
          _field(label: 'Business Registration Number', hint: 'Registration number', icon: Icons.verified_outlined),
          _gap(),
          _field(label: 'Trade License', hint: 'License number', icon: Icons.description_outlined),
          _gap(),
          _field(label: 'Tax/VAT/TIN Number', hint: 'Tax number', icon: Icons.account_balance_outlined),
          _gap(),
          _field(label: 'Business and Warehouse Address', hint: 'Full address', icon: Icons.location_on_outlined),
          _gap(),
          _field(label: 'Number of Pharmacists', hint: 'e.g. 5', icon: Icons.people_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Responsible Pharmacist Name', hint: 'Pharmacist name', icon: Icons.medical_services_rounded),
          _gap(),
          _field(label: 'Pharmacist License/Registration Number', hint: 'License number', icon: Icons.badge_outlined),
          _gap(),
          _field(label: 'Pharmacy Council Registration Number', hint: 'Council number', icon: Icons.gavel_outlined),
          _gap(),
          _field(label: 'Professional License Expiry Date', hint: 'DD/MM/YYYY', icon: Icons.date_range_outlined),
          _gap(),
          _field(label: 'List of Permitted Products', hint: 'Products list', icon: Icons.list_alt_outlined),
          _gap(),
          _field(label: 'Storage/Cold-Chain Capability', hint: 'Yes/No details', icon: Icons.ac_unit_outlined),
          _gap(),
          _field(label: 'Delivery Coverage Area', hint: 'Areas covered', icon: Icons.map_outlined),
          _gap(),
          _field(label: 'Returns/Expiry Handling Policy', hint: 'Policy details', icon: Icons.policy_outlined),
          _gap(),
          _field(label: 'Bank Account for Settlement', hint: 'Account details', icon: Icons.account_balance_outlined),
          _gap(),
          _field(label: 'Authorized Signatory Details', hint: 'Signatory info', icon: Icons.edit_outlined),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentTerms,
                onChanged: (v) => setState(() => _consentTerms = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Agreement to product quality and prescription rules',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _researcherFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('RESEARCH PROFILE'),
          _field(label: 'Institution/Company Name', hint: 'Institution name', icon: Icons.business_outlined),
          _gap(),
          _field(label: 'Institutional Email', hint: 'email@institution.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          _gap(),
          _field(label: 'Phone Number', hint: '+880 1700 000000', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          _gap(),
          _field(label: 'Department', hint: 'Department name', icon: Icons.business_center_outlined),
          _gap(),
          _field(label: 'Highest Academic Degree', hint: 'e.g. PhD', icon: Icons.school_outlined),
          _gap(),
          _field(label: 'Field of Study', hint: 'Study field', icon: Icons.science_outlined),
          _gap(),
          _field(label: 'University/College Name', hint: 'University name', icon: Icons.account_balance_outlined),
          _gap(),
          _field(label: 'Year of Graduation', hint: 'e.g. 2010', icon: Icons.calendar_view_day_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Areas of Expertise', hint: 'Expertise areas', icon: Icons.lightbulb_outlined),
          _gap(),
          _field(label: 'Years of Research Experience', hint: 'e.g. 10', icon: Icons.timeline_outlined, keyboardType: TextInputType.number),
          _gap(),
          _field(label: 'Poultry-Specific Experience', hint: 'Experience details', icon: Icons.egg_alt_rounded),
          _gap(),
          _field(label: 'Software/Data Analysis Skills', hint: 'Skills list', icon: Icons.computer_outlined),
          _gap(),
          _field(label: 'Access to Lab/Institution', hint: 'Yes/No', icon: Icons.location_city_outlined),
          _gap(),
          _field(label: 'Research Role Type', hint: 'e.g. Researcher, Professor', icon: Icons.person_outline_rounded),
          _gap(),
          _field(label: 'Ethics/Training Certificate', hint: 'Certificate details', icon: Icons.verified_outlined),
          _gap(),
          _field(label: 'Reference Information', hint: 'References', icon: Icons.group_outlined),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentTerms,
                onChanged: (v) => setState(() => _consentTerms = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Publication consent and IP agreement',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
          _gap(),
          Row(
            children: [
              Checkbox(
                value: _consentBackground,
                onChanged: (v) => setState(() => _consentBackground = v ?? false),
              ),
              Expanded(
                child: Text(
                  'Conflict of interest declaration',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildRoleSpecificFields() {
    switch (_selectedRole) {
      case 'Farmer':     return _farmerFields();
      case 'Admin':      return _adminFields();
      case 'Doctor':     return _doctorFields();
      case 'Delivery':   return _deliveryFields();
      case 'Pharmacy':   return _pharmacyFields();
      case 'Researcher': return _researcherFields();
      default:           return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Top green gradient header
          Container(
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF011810), AppTheme.primary, Color(0xFF024A37)],
              ),
            ),
            child: Stack(children: [
              Positioned(
                top: -60, left: -60,
                child: Container(
                  width: 220, height: 220,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.03)),
                ),
              ),
              Positioned(
                bottom: 30, right: -20,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.accent.withOpacity(0.08)),
                ),
              ),
            ]),
          ),
          // White surface underlay
          Positioned(
            top: size.height * 0.31, left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
            ),
          ),
          // Content
          FadeTransition(
            opacity: _fadeIn,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Back button
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.egg_alt_rounded, size: 44, color: AppTheme.accentLight),
                    const SizedBox(height: 8),
                    Text('Join Featherflow',
                        style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Create your free account today',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                    SizedBox(height: size.height * 0.055),

                    // ── Form card with green glow border ──
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: AppTheme.accent.withOpacity(0.35), blurRadius: 0, spreadRadius: 2),
                          BoxShadow(color: AppTheme.accent.withOpacity(0.18), blurRadius: 20, spreadRadius: 4),
                          BoxShadow(color: AppTheme.primary.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.accent.withOpacity(0.4), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create Account',
                                style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                            const SizedBox(height: 4),
                            Text('Choose your role to get started',
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
                            const SizedBox(height: 20),

                            // ── Role chips ──
                            Text('SIGN UP AS',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.8)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: roles.map((role) {
                                final selected = _selectedRole == role;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedRole = role),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: selected ? AppTheme.primary : const Color(0xFFF0F6F3),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: selected ? AppTheme.primary : const Color(0xFFD4E4DF)),
                                      boxShadow: selected
                                          ? [BoxShadow(color: AppTheme.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_roleIcons[role], size: 14, color: selected ? Colors.white : AppTheme.textSecondary),
                                        const SizedBox(width: 6),
                                        Text(role,
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.textSecondary)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),

                            // Role description banner
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Container(
                                key: ValueKey(_selectedRole),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.accent.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(_roleIcons[_selectedRole]!, size: 16, color: AppTheme.accent),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(_roleDesc[_selectedRole]!,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Personal Info ──
                            _sectionLabel('PERSONAL INFO'),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'First Name', hintText: 'John',
                                      labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Last Name', hintText: 'Doe',
                                      labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            _field(label: 'Email Address', hint: 'you@example.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                            _gap(),
                            _field(label: 'Phone Number', hint: '+880 1700 000000', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                            _gap(),
                            _sectionLabel('ADDITIONAL INFO'),
                            _field(label: 'National ID or Passport Number', hint: 'Enter ID number', icon: Icons.badge_outlined),
                            _gap(),
                            _field(label: 'Date of Birth', hint: 'DD/MM/YYYY', icon: Icons.calendar_today_outlined),
                            _gap(),
                            _field(label: 'Present Address', hint: 'Full address', icon: Icons.location_on_outlined),
                            _gap(),
                            _dropdown(label: 'Preferred Language', icon: Icons.language_outlined, items: ['English', 'Bengali', 'Hindi']),
                            _gap(),
                            _field(label: 'Emergency Contact', hint: 'Name and phone', icon: Icons.contact_phone_outlined),
                            _gap(),
                            _field(label: 'Bank/Mobile Payment Details', hint: 'Account or mobile number', icon: Icons.account_balance_outlined),
                            _gap(),
                            _field(label: 'Location/Service Area', hint: 'e.g. Dhaka, Gazipur', icon: Icons.map_outlined),
                            _gap(),
                            // Consents
                            Row(
                              children: [
                                Checkbox(
                                  value: _consentTerms,
                                  onChanged: (v) => setState(() => _consentTerms = v ?? false),
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to the terms, privacy policy, and background verification',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _consentBackground,
                                  onChanged: (v) => setState(() => _consentBackground = v ?? false),
                                ),
                                Expanded(
                                  child: Text(
                                    'Consent for background check',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),

                            // ── Role-specific fields ──
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                              child: KeyedSubtree(key: ValueKey(_selectedRole), child: _buildRoleSpecificFields()),
                            ),
                            _gap(),

                            // ── Security ──
                            _sectionLabel('ACCOUNT SECURITY'),
                            _field(
                              label: 'Password', hint: '••••••••', icon: Icons.lock_outline,
                              obscure: _obscurePassword, showToggle: true,
                              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            _gap(),
                            _field(
                              label: 'Confirm Password', hint: '••••••••', icon: Icons.lock_outline,
                              obscure: _obscureConfirm, showToggle: true,
                              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Create Account as $_selectedRole',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account? ',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                                  child: Text('Sign In',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}