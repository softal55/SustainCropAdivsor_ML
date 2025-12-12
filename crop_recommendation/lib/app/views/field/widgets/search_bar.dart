import 'dart:async';
import 'dart:convert';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class SearchBar extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  const SearchBar({super.key, required this.onLocationSelected});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _suggestionsController =
      StreamController.broadcast();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _suggestionsController.close();
    super.dispose();
  }

  Future<void> _searchSuggestions(String query) async {
    if (query.isEmpty) {
      _suggestionsController.add([]);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> suggestions =
            data
                .map(
                  (item) => {
                    'display_name': item['display_name'],
                    'lat': item['lat'],
                    'lon': item['lon'],
                  },
                )
                .toList();
        _suggestionsController.add(suggestions);
      } else {
        _suggestionsController.add([]);
      }
    } catch (_) {
      _suggestionsController.add([]);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _suggestionsController.stream,
          builder: (context, snapshot) {
            if (_isLoading) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.background,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              );
            }

            final results = snapshot.data ?? [];
            if (results.isEmpty) {
              return const SizedBox.shrink();
            }
            return Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final displayName = result['display_name'];
                      final lat = double.parse(result['lat']);
                      final lon = double.parse(result['lon']);
                      return ListTile(
                        title: Text(
                          displayName,
                          style: const TextStyle(color: AppColors.secondary),
                        ),
                        onTap: () {
                          widget.onLocationSelected(LatLng(lat, lon));
                          FocusScope.of(context).unfocus(); // Collapse keyboard
                          if (!_suggestionsController.isClosed) {
                            _suggestionsController.add([]);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.search,
      onChanged: (query) => _searchSuggestions(query),
      onSubmitted: (query) {
        _searchSuggestions(query);
        FocusScope.of(context).unfocus(); // Collapse keyboard
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
      ),
    );
  }
}
