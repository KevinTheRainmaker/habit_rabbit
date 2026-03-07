import 'package:equatable/equatable.dart';

class ShopItem extends Equatable {
  final String id;
  final String name;
  final int price;
  final String category;
  final bool isOwned;

  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.isOwned = false,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    int? price,
    String? category,
    bool? isOwned,
  }) =>
      ShopItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category ?? this.category,
        isOwned: isOwned ?? this.isOwned,
      );

  @override
  List<Object> get props => [id];
}
