import 'dart:collection';
import 'package:flutter/material.dart';
import '../../widgets/loading_view.dart';
import '../../data/api/dream_api.dart';
import '../../data/models/dream_model.dart';
import '../../widgets/network_imge_view.dart';

class DreamsPage extends StatefulWidget {
  const DreamsPage({super.key});

  @override
  State<DreamsPage> createState() => _DreamsPageState();
}

class _DreamsPageState extends State<DreamsPage> {
  List<Dream> _allDreams = [];
  List<Dream> _filteredDreams = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDreams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDreams() async {
    try {
      // Load JSON from assets
      final response = await DreamApi.get();

      if (response.status) {
        _allDreams = response.data;
        setState(() {
          _filteredDreams = _allDreams;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading dreams: $e')));
      }
    }
  }

  void _filterDreams(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDreams = _allDreams;
      } else {
        _filteredDreams = _allDreams.where((dream) {
          // Search by name
          final nameMatch = dream.name.toLowerCase().contains(
            query.toLowerCase(),
          );

          // Search by numbers
          final numberMatch = dream.numbers.any(
            (number) => number.toString().contains(query),
          );

          return nameMatch || numberMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'အိပ်မက်များ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDreams,
              decoration: InputDecoration(
                hintText: 'အမည် သို့မဟုတ် နံပါတ်ဖြင့် ရှာရန်...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterDreams('');
                        },
                      )
                    : null,
                filled: true,
                // fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Results count
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ရလဒ် ${_filteredDreams.length} ခု',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    Text(
                      'စုစုပေါင်း ${_allDreams.length} ခု',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                ],
              ),
            ),

          // Dreams Grid
          Expanded(
            child: _isLoading
                ? LoadingView()
                : _filteredDreams.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ရလဒ်မရှိပါ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'အခြားသော စကားလုံးဖြင့် ရှာကြည့်ပါ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _filteredDreams.length,
                    itemBuilder: (context, index) {
                      final dream = _filteredDreams[index];
                      return _DreamCard(dream: dream);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DreamCard extends StatelessWidget {
  final Dream dream;

  const _DreamCard({required this.dream});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          child: Column(
            children: [
              Expanded(
                child: NetworkImageView(url: dream.cover, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  dream.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    height: 1,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(
                dream.numbers.length,
                (idx) => Text(
                  dream.numbers[idx].toString().padLeft(3, "0"),
                  style: TextStyle(
                    color: Colors.black,
                    shadows: outlinedText(strokeColor: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Shadow> outlinedText({
    double strokeWidth = 2,
    Color strokeColor = Colors.black,
    int precision = 5,
  }) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
      }
    }
    return result.toList();
  }
}
