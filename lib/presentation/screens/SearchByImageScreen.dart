import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/imageSearch/cubit/image_search_cubit.dart';
import 'package:image_picker/image_picker.dart';

class SearchByImageScreen extends StatefulWidget {
  @override
  State<SearchByImageScreen> createState() => _SearchByImageScreenState();
}

class _SearchByImageScreenState extends State<SearchByImageScreen> {
  File? _selectedImage;

  void _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
      // دلوقتي في امان لأن فيه BlocProvider حوالين الشاشة كلها
      context.read<ImageSearchCubit>().searchByImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("بحث بالصور")),
      body: Column(
        children: [
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text("اختار صورة"),
          ),
          if (_selectedImage != null)
            Image.file(_selectedImage!, width: 100, height: 100),
          Expanded(
            child: BlocBuilder<ImageSearchCubit, ImageSearchState>(
              builder: (context, state) {
                if (state is ImageSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageSearchSuccess) {
                  if (state.results.isEmpty) {
                    return const Center(child: Text("مفيش نتائج!"));
                  }
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (ctx, i) {
                      final item = state.results[i].imgInfo;
                      if (item.name.isEmpty) return const SizedBox();
                      return Card(
                        child: ListTile(
                          leading: item.imageUrl != null
                              ? Image.network(item.imageUrl!, width: 60)
                              : null,
                          title: Text(item.name),
                          subtitle: Text(item.price?.toString() ?? ''),
                        ),
                      );
                    },
                  );
                } else if (state is ImageSearchFailure) {
                  return Center(child: Text('فشل: ${state.message}'));
                }
                return const Center(child: Text("اختار صورة للبحث"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
