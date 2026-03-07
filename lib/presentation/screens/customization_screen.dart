import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/providers/equipped_items_provider.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';

class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equippedAsync = ref.watch(equippedItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('꾸미기')),
      body: FutureBuilder(
        future: ref.watch(shopRepositoryProvider).getOwnedItems(),
        builder: (context, ownedSnapshot) {
          if (!ownedSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final owned = ownedSnapshot.data!;
          if (owned.isEmpty) {
            return const Center(
              child: Text('아이템을 구매하고 토끼를 꾸며보세요!'),
            );
          }

          final equippedIds = equippedAsync.valueOrNull
                  ?.map((i) => i.id)
                  .toSet() ??
              {};

          return ListView.builder(
            itemCount: owned.length,
            itemBuilder: (context, index) {
              final item = owned[index];
              final isEquipped = equippedIds.contains(item.id);

              return ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(item.name),
                subtitle: Text(item.category),
                trailing: isEquipped
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Chip(label: Text('장착 중')),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => ref
                                .read(equipNotifierProvider.notifier)
                                .unequip(itemId: item.id),
                            child: const Text('해제'),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () => ref
                            .read(equipNotifierProvider.notifier)
                            .equip(itemId: item.id),
                        child: const Text('장착'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
