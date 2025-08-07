import 'package:flutter/material.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _discounts = [
    {
      'storeName': '셀프 마라탕',
      'discount': '20%',
      'description': '11시-14시 점심특가',
      'originalPrice': 12000,
      'discountPrice': 9600,
      'category': 'food',
      'distance': '50m',
      'timeLeft': '2시간 30분',
      'image': 'https://placehold.co/80x80/EF4444/FFFFFF?text=마라탕',
      'color': const Color(0xFFEF4444),
      'isPopular': true,
    },
    {
      'storeName': '스타벅스 경북대점',
      'discount': '15%',
      'description': '아메리카노 + 디저트 세트',
      'originalPrice': 8500,
      'discountPrice': 7225,
      'category': 'cafe',
      'distance': '120m',
      'timeLeft': '5시간 12분',
      'image': 'https://placehold.co/80x80/10B981/FFFFFF?text=스벅',
      'color': const Color(0xFF10B981),
      'isPopular': false,
    },
    {
      'storeName': 'GS25 경북대점',
      'discount': '1+1',
      'description': '삼각김밥 1+1 이벤트',
      'originalPrice': 3000,
      'discountPrice': 1500,
      'category': 'convenience',
      'distance': '80m',
      'timeLeft': '1일 5시간',
      'image': 'https://placehold.co/80x80/F59E0B/FFFFFF?text=GS',
      'color': const Color(0xFFF59E0B),
      'isPopular': true,
    },
    {
      'storeName': '교보문고 경북대점',
      'discount': '30%',
      'description': '참고서 할인 이벤트',
      'originalPrice': 25000,
      'discountPrice': 17500,
      'category': 'shopping',
      'distance': '200m',
      'timeLeft': '3일 2시간',
      'image': 'https://placehold.co/80x80/8B5CF6/FFFFFF?text=교보',
      'color': const Color(0xFF8B5CF6),
      'isPopular': false,
    },
    {
      'storeName': '맘스터치 경북대점',
      'discount': '25%',
      'description': '버거세트 할인',
      'originalPrice': 8900,
      'discountPrice': 6675,
      'category': 'food',
      'distance': '150m',
      'timeLeft': '4시간 45분',
      'image': 'https://placehold.co/80x80/EF4444/FFFFFF?text=맘터',
      'color': const Color(0xFFEF4444),
      'isPopular': false,
    },
    {
      'storeName': '투썸플레이스',
      'discount': '10%',
      'description': '케이크 할인',
      'originalPrice': 28000,
      'discountPrice': 25200,
      'category': 'cafe',
      'distance': '180m',
      'timeLeft': '6시간 20분',
      'image': 'https://placehold.co/80x80/10B981/FFFFFF?text=투썸',
      'color': const Color(0xFF10B981),
      'isPopular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDiscounts {
    if (_selectedCategory == 'all') return _discounts;
    return _discounts.where((discount) => discount['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          '할인 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1D29),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1D29)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header Stats
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF346DFF),
                    Color(0xFF6B8AFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF346DFF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '지금 사용 가능한 할인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '6개 매장에서 특별 할인 중!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '실시간',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
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

            const SizedBox(height: 16),

            // Discount List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredDiscounts.length,
                itemBuilder: (context, index) {
                  final discount = _filteredDiscounts[index];
                  return _buildDiscountCard(discount, index);
                },
              ),
            ),
          ],
        ),
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
              color: Colors.black.withOpacity(0.05),
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

  Widget _buildDiscountCard(Map<String, dynamic> discount, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Store Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(discount['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Store Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              discount['storeName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1D29),
                              ),
                            ),
                          ),
                          if (discount['isPopular'])
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'HOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        discount['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price Info
                      Row(
                        children: [
                          Text(
                            '${discount['originalPrice'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${discount['discountPrice'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: discount['color'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Distance and Time
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  discount['distance'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Color(0xFF346DFF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  discount['timeLeft'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF346DFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Discount Badge
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [discount['color'], discount['color'].withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                discount['discount'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}