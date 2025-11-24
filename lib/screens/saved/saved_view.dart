import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/saved_controller.dart';
import '../../models/article.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final savedC = Get.find<SavedController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Articles')),

      body: Obx(() {
        if (savedC.saved.isEmpty) {
          return const Center(child: Text('No saved articles yet.'));
        }

        return ListView.builder(
          itemCount: savedC.saved.length,
          itemBuilder: (_, i) {
            final Article a = savedC.saved[i];
            return ListTile(
              onTap: () => Get.toNamed('/detail', arguments: a),
              title: Text(a.title),
              subtitle: Text(a.source),
            );
          },
        );
      }),
    );
  }
}