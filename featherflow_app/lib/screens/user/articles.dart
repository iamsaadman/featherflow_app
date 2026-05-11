import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showSavedOnly = false;

  final List<String> _categories = ['All', 'Research Papers', 'News', 'Disease Studies', 'Feed Studies', 'Market Reports'];

  final List<Map<String, dynamic>> _articles = [
    {
      'title': 'Avian Influenza Outbreak Management',
      'summary': 'Comprehensive study on managing H5N1 outbreaks in poultry farms...',
      'author': 'Dr. Rahman Khan',
      'date': '2024-05-01',
      'category': 'Disease Studies',
      'verified': true,
      'saved': false,
      'views': 1250,
      'saves': 89,
      'status': 'Published',
    },
    {
      'title': 'Sustainable Feed Solutions for Layer Hens',
      'summary': 'Analysis of alternative feed sources reducing dependency on maize...',
      'author': 'Prof. Fatima Begum',
      'date': '2024-04-28',
      'category': 'Feed Studies',
      'verified': true,
      'saved': true,
      'views': 890,
      'saves': 156,
      'status': 'Published',
    },
    {
      'title': 'Market Trends in Poultry Export 2024',
      'summary': 'Current market analysis and future projections for poultry exports...',
      'author': 'Market Research Team',
      'date': '2024-04-25',
      'category': 'Market Reports',
      'verified': false,
      'saved': false,
      'views': 567,
      'saves': 34,
      'status': 'Published',
    },
  ];

  List<Map<String, dynamic>> get _filteredArticles {
    return _articles.where((article) {
      final matchesSearch = article['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           article['summary'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || article['category'] == _selectedCategory;
      final matchesSaved = !_showSavedOnly || article['saved'];
      return matchesSearch && matchesCategory && matchesSaved;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.articles),
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: Icon(_showSavedOnly ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
            onPressed: () => setState(() => _showSavedOnly = !_showSavedOnly),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.surface,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search articles...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final selected = _selectedCategory == category;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (bool selected) {
                            setState(() => _selectedCategory = selected ? category : 'All');
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primary.withOpacity(0.1),
                          checkmarkColor: AppTheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Articles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return _ArticleCard(
                  article: article,
                  onSave: () => setState(() => article['saved'] = !article['saved']),
                  onShare: () => _shareArticle(article),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewsletterDialog(context),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.email, color: Colors.white),
        label: Text('Newsletter', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _shareArticle(Map<String, dynamic> article) {
    // Placeholder for share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing: ${article['title']}')),
    );
  }

  void _showNewsletterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Newsletter Subscription', style: GoogleFonts.playfairDisplay()),
        content: Text('Subscribe to get notified about new articles and research updates.',
            style: GoogleFonts.plusJakartaSans()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Subscribe', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const _ArticleCard({
    required this.article,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    article['title'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (article['verified'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified, size: 14, color: AppTheme.accent),
                        const SizedBox(width: 4),
                        Text('Verified', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.accent)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article['summary'],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'By ${article['author']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  article['date'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.visibility, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${article['views']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.bookmark_border, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${article['saves']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.article, size: 16),
                    label: Text('Read Full', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    article['saved'] ? Icons.bookmark : Icons.bookmark_border,
                    color: article['saved'] ? AppTheme.accent : AppTheme.textMuted,
                  ),
                ),
                IconButton(
                  onPressed: onShare,
                  icon: Icon(Icons.share, color: AppTheme.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
