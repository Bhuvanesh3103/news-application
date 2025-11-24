import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/article.dart';
import '../../controllers/saved_controller.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Article article = Get.arguments;
    final savedController = Get.find<SavedController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(article),
          SliverToBoxAdapter(
            child: _ArticleContent(article: article, savedController: savedController),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(Article article) {
    return SliverAppBar(
      expandedHeight: article.image != null ? 260 : 140,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Get.back(),
      ),
      actions: [
        _buildIconButton(
          icon: Icons.share,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderImage(article),
      ),
    );
  }

  Widget _buildHeaderImage(Article article) {
    if (article.image == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F8FED), Color(0xFF356AC3)],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          article.image!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade300,
            child: Icon(Icons.broken_image, size: 60, color: Colors.grey.shade600),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.65),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }
}


class _ArticleContent extends StatelessWidget {
  final Article article;
  final SavedController savedController;

  const _ArticleContent({
    required this.article,
    required this.savedController,
  });

  @override
  Widget build(BuildContext context) {
    final isSaved = savedController.saved.any((a) => a.url == article.url);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSourceChip(article.source),
          const SizedBox(height: 16),
          _buildTitle(article.title),
          const SizedBox(height: 20),
          _buildActionButtons(isSaved),
          const SizedBox(height: 28),
          _buildArticleBody(),
          const SizedBox(height: 32),
          _buildReadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildSourceChip(String source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.source, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(
            source.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  Widget _buildActionButtons(bool isSaved) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => savedController.toggleSave(article),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSaved ? Colors.amber[600] : Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, size: 20),
            label: Text(isSaved ? "Saved" : "Save"),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget _buildArticleBody() {
    final body = article.content ?? article.description ?? "No content available";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        body,
        style: const TextStyle(
          fontSize: 15.5,
          height: 1.55,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildReadMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => launchUrl(Uri.parse(article.url)),
        icon: const Icon(Icons.open_in_new, size: 20),
        label: const Text("Read Full Article"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
