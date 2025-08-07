import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;
  bool _showHeatmap = true;
  bool _showDiscounts = true;
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _hotspots = [
    {
      'name': '학식당',
      'position': const NLatLng(35.8907, 128.6114),
      'popularity': 95,
      'category': 'food',
      'color': const Color(0xFFEF4444),
    },
    {
      'name': '스타벅스 경북대점',
      'position': const NLatLng(35.8927, 128.6134),
      'popularity': 87,
      'category': 'cafe',
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'GS25 경북대점',
      'position': const NLatLng(35.8897, 128.6104),
      'popularity': 72,
      'category': 'convenience',
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': '교보문고',
      'position': const NLatLng(35.8917, 128.6144),
      'popularity': 68,
      'category': 'shopping',
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));
    _overlayController.forward();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kyungpookUniv = NLatLng(35.8917, 128.6124);
    final safeAreaPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          NaverMap(
            options: NaverMapViewOptions(
              contentPadding: safeAreaPadding,
              initialCameraPosition: NCameraPosition(
                target: kyungpookUniv,
                zoom: 16,
              ),
              mapType: NMapType.basic,
              nightModeEnable: false,
            ),
            onMapReady: (controller) {
              // Add main university marker
              final universityMarker = NMarker(
                id: "kyungpook_univ",
                position: kyungpookUniv,
                caption: NOverlayCaption(
                  text: "경북대학교",
                  textSize: 14,
                  color: Colors.white,
                  haloColor: const Color(0xFF346DFF),
                ),
                icon: const NOverlayImage.fromAssetImage(
                  'assets/university_marker.png',
                ),
              );
              controller.addOverlay(universityMarker);

              // Add hotspot markers
              for (int i = 0; i < _hotspots.length; i++) {
                final hotspot = _hotspots[i];
                final marker = NMarker(
                  id: "hotspot_$i",
                  position: hotspot['position'],
                  caption: NOverlayCaption(
                    text: "${hotspot['name']}\n인기도: ${hotspot['popularity']}%",
                    textSize: 12,
                    color: Colors.white,
                    haloColor: hotspot['color'],
                  ),
                );
                controller.addOverlay(marker);

                // Add circle overlay for popularity visualization
                final circle = NCircleOverlay(
                  id: "circle_$i",
                  center: hotspot['position'],
                  radius: hotspot['popularity'] * 2.0,
                  color: hotspot['color'].withOpacity(0.3),
                  outlineColor: hotspot['color'],
                  outlineWidth: 2,
                );
                controller.addOverlay(circle);
              }

              print("Enhanced naver map is ready!");
            },
          ),

          // Top Search Bar
          Positioned(
            top: safeAreaPadding.top + 16,
            left: 16,
            right: 16,
            child: FadeTransition(
              opacity: _overlayAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        '캠퍼스 내 장소를 검색해보세요',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF346DFF),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Filter
          Positioned(
            top: safeAreaPadding.top + 80,
            left: 16,
            right: 16,
            child: FadeTransition(
              opacity: _overlayAnimation,
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('all', '전체', Icons.apps),
                    _buildCategoryChip('food', '음식', Icons.restaurant),
                    _buildCategoryChip('cafe', '카페', Icons.local_cafe),
                    _buildCategoryChip('convenience', '편의점', Icons.store),
                    _buildCategoryChip('shopping', '쇼핑', Icons.shopping_bag),
                  ],
                ),
              ),
            ),
          ),

          // Live Rankings Card
          Positioned(
            top: safeAreaPadding.top + 140,
            right: 16,
            child: FadeTransition(
              opacity: _overlayAnimation,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'LIVE 인기 순위',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D29),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._hotspots.take(3).map((hotspot) {
                      final index = _hotspots.indexOf(hotspot);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? const Color(0xFFEF4444)
                                    : index == 1
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF6B7280),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hotspot['name'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1A1D29),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Control Panel
          Positioned(
            bottom: 120,
            right: 16,
            child: FadeTransition(
              opacity: _overlayAnimation,
              child: Column(
                children: [
                  _buildControlButton(
                    icon: _showHeatmap ? Icons.visibility : Icons.visibility_off,
                    label: '히트맵',
                    isActive: _showHeatmap,
                    onTap: () {
                      setState(() {
                        _showHeatmap = !_showHeatmap;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    icon: _showDiscounts ? Icons.local_offer : Icons.local_offer_outlined,
                    label: '할인정보',
                    isActive: _showDiscounts,
                    onTap: () {
                      setState(() {
                        _showDiscounts = !_showDiscounts;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    icon: Icons.my_location,
                    label: '내 위치',
                    isActive: false,
                    onTap: () {
                      // 내 위치로 이동
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Info Card
          Positioned(
            bottom: 16,
            left: 16,
            right: 80,
            child: FadeTransition(
              opacity: _overlayAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '실시간 업데이트',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '캠퍼스 히트맵',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D29),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '지금 가장 인기 있는 장소들을 확인하고\n특별한 할인 혜택도 놓치지 마세요!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '실시간 인기도 기반',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF346DFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'AI 분석',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF346DFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF346DFF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}