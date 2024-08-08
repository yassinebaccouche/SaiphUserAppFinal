import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/article_card.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),

      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('articles')
                  .snapshots(),
              builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading articles'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No articles available'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => ArticleCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void postImage(String uid, String pseudo, String profImage) async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethodes().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        pseudo,
        profImage,
      );

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(context, 'Published!');
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, err.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
