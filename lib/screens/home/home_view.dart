import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/news_controller.dart';
import '../../controllers/saved_controller.dart';
import '../../models/article.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsC = Get.put(NewsController());
    final savedC = Get.put(SavedController());

    const categories = [
      "technology",
      "business",
      "sports",
      "science",
      "entertainment",
      "health"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCategorySection(newsC, categories),
          Expanded(
            child: _buildArticleList(newsC, savedC),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'News Feed',
        style: TextStyle(
          color: Color(0xFF212121),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _buildActionButton(
          Icons.favorite,
          Colors.pink.shade50,
          Colors.pink.shade400,
              () => Get.toNamed('/saved'),
        ),
        _buildActionButton(
          Icons.settings,
          Colors.blue.shade50,
          Colors.blue.shade600,
              () => Get.toNamed('/preferences'),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, Color bgColor, Color iconColor, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCategorySection(NewsController newsC, List<String> categories) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _buildCategoryChip(cat, newsC);
          },
        )
      ),
    );
  }

  Widget _buildCategoryChip(String category, NewsController controller) {
    return GestureDetector(
      onTap: () => controller.changeCategory(category),
      child: Obx(() {
        final isSelected = controller.category.value == category;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isSelected ? null : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Center(
            child: Text(
              category.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF616161),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }),
    );
  }


  Widget _buildArticleList(NewsController newsC, SavedController savedC) {
    return Obx(() {
      if (newsC.loading.value) {
        return _buildLoadingState();
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: newsC.articles.length,
        itemBuilder: (context, index) {
          return ArticleItem(
            article: newsC.articles[index],
            savedC: savedC,
          );
        },
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading articles...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleItem extends StatelessWidget {
  final Article article;
  final SavedController savedC;

  const ArticleItem({
    super.key,
    required this.article,
    required this.savedC,
  });

  @override
  Widget build(BuildContext context) {
    final isSaved = savedC.saved.any((e) => e.url == article.url);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/detail', arguments: article),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildArticleImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildArticleContent(),
                ),
                const SizedBox(width: 8),
                _buildBookmarkButton(isSaved),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: article.image == null
          ? _buildPlaceholder()
          : Image.network(
        article.image!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: const Color(0xFFEEEEEE),
      child: Icon(
        Icons.image,
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            height: 1.3,
          ),
        ),
        if (article.description != null && article.description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            article.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBookmarkButton(bool isSaved) {
    return Container(
      decoration: BoxDecoration(
        color: isSaved ? Colors.amber.shade50 : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? Colors.amber.shade700 : Colors.grey.shade400,
          size: 22,
        ),
        onPressed: () => savedC.toggleSave(article),
      ),
    );
  }
}