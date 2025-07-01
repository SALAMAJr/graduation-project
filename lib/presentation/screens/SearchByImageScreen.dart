import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/presentation/manager/imageSearch/cubit/image_search_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/presentation/screens/productDetailsScreen.dart';

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
      context.read<ImageSearchCubit>().searchByImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بحث بالصور"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffE8E0D5),
              foregroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("اختار صورة"),
          ),
          const SizedBox(height: 10),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.file(_selectedImage!, width: 120, height: 120),
            ),
          Expanded(
            child: BlocBuilder<ImageSearchCubit, ImageSearchState>(
              builder: (context, state) {
                if (state is ImageSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageSearchSuccess) {
                  if (state.results.isEmpty) {
                    return const Center(child: Text("مفيش نتائج!"));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: state.results.length,
                    itemBuilder: (ctx, i) {
                      final item = state.results[i].imgInfo;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: item.imageUrl != null
                                  ? Image.network(
                                      item.imageUrl!,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 120,
                                      color: Colors.grey[200],
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF5F1EA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.condition ?? 'new',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  final product = ProductItem(
                                    id: item.id ?? '',
                                    name: item.name,
                                    price: (item.price ?? 0).toDouble(),
                                    description: item.description ?? '',
                                    imageUrl: item.imageUrl ?? '',
                                    condition: item.condition ?? 'new',
                                    type: item.type ?? 'swap',
                                    status: 'available', // افتراضي
                                    userId: '', // افتراضي
                                    category: item.category?.toString(),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailsScreen(
                                          product: product),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff694A38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Swap",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
