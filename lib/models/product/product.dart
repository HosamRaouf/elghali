import 'package:equatable/equatable.dart';

class ProductSize extends Equatable {
  final String label;
  final double price;

  const ProductSize({required this.label, required this.price});

  @override
  List<Object?> get props => [label, price];
}

class Product extends Equatable {
  final String id;
  final String name;
  final String nameEn;
  final String category;
  final double price;
  final String image;
  final String description;
  final String sensory;
  final List<String> tags;
  final bool isNew;
  final bool isFeatured;
  final List<ProductSize>? sizes;
  final int? calories;

  const Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    required this.sensory,
    required this.tags,
    this.isNew = false,
    this.isFeatured = false,
    this.sizes,
    this.calories,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        nameEn,
        category,
        price,
        image,
        description,
        sensory,
        tags,
        isNew,
        isFeatured,
        sizes,
        calories,
      ];
}
