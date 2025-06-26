import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/presentation/manager/productCubit/product_search_cubit.dart';
import 'package:furniswap/presentation/manager/category/cubit/category_products_cubit.dart';
import 'package:furniswap/presentation/screens/productDetailsScreen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final bool isCategory;

  const SearchResultsScreen({
    super.key,
    required this.query,
    this.isCategory = false,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.isCategory) {
      context.read<ProductSearchCubit>().searchProducts(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff694A38)),
        title: Text(
          widget.isCategory ? widget.query : "Search Results",
          style: const TextStyle(
            color: Color(0xff694A38),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: widget.isCategory
            ? BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                builder: (context, state) {
                  if (state is CategoryProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoryProductsError) {
                    return Center(child: Text("❌ ${state.message}"));
                  } else if (state is CategoryProductsLoaded) {
                    return _buildGrid(state.products);
                  }
                  return const SizedBox.shrink();
                },
              )
            : BlocBuilder<ProductSearchCubit, ProductSearchState>(
                builder: (context, state) {
                  if (state is ProductSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductSearchFailure) {
                    return Center(
                      child: Text("❌ ${state.message}",
                          style: const TextStyle(color: Colors.red)),
                    );
                  } else if (state is ProductSearchSuccess) {
                    return _buildGrid(state.products);
                  }
                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }

  Widget _buildGrid(List<ProductItem> products) {
    if (products.isEmpty) {
      return const Center(child: Text("🙁 No products found."));
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(product.condition,
                            style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff694A38),
                          minimumSize: const Size(double.infinity, 35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(product.type == "swap" ? "Swap" : "Buy"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
