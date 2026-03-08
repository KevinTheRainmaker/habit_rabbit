import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_detail_screen.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/providers/equipped_items_provider.dart';
import 'package:habit_rabbit/presentation/screens/notification_settings_screen.dart';
import 'package:habit_rabbit/presentation/screens/shop_screen.dart';
import 'package:habit_rabbit/presentation/screens/mission_screen.dart';
import 'package:habit_rabbit/presentation/screens/premium_gate_screen.dart';
import 'package:habit_rabbit/presentation/screens/statistics_screen.dart';
import 'package:habit_rabbit/presentation/widgets/empty_habit_state.dart';
import 'package:habit_rabbit/presentation/widgets/completion_rate_card.dart';

class MockHabitRepository extends Mock implements HabitRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockShopRepository extends Mock implements ShopRepository {}
class MockMissionRepository extends Mock implements MissionRepository {}

void main() {
  group('HabitListScreen', () {
    testWidgets('앱바에 "내 습관" 타이틀 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(null));
      when(() => mockHabit.getHabits(userId: any(named: 'userId')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('내 습관'), findsOneWidget);
    });

    testWidgets('습관 목록이 있으면 이름 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('매일 운동'), findsOneWidget);
    });

    testWidgets('습관이 없으면 빈 상태 메시지 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHabitState), findsOneWidget);
    });

    testWidgets('FAB 존재', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('습관 타일 스와이프로 삭제', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      expect(find.text('매일 운동'), findsNothing);
    });

    testWidgets('오늘 요일이 아닌 습관은 목록에서 숨김', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      // targetDays 빈 리스트 → 어떤 요일에도 표시 안 됨 (날짜 독립적)
      final neverShownHabit = Habit(
        id: 'h-1', userId: 'uid-1', name: '안보이는 습관',
        createdAt: DateTime(2026, 3, 7), isActive: true,
        targetDays: const [], // 어떤 요일도 아님
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [neverShownHabit]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('안보이는 습관'), findsNothing);
      expect(find.byType(EmptyHabitState), findsOneWidget);
    });

    testWidgets('무료 사용자 3개 초과 시 PremiumGateScreen 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      // 무료 사용자, 이미 3개 습관
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final habits = List.generate(3, (i) => Habit(
        id: 'h-$i', userId: 'uid-1', name: '습관 $i',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      ));
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => habits);
      for (final h in habits) {
        when(() => mockHabit.getCheckins(habitId: h.id, userId: 'uid-1'))
            .thenAnswer((_) async => []);
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // FAB 탭
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(PremiumGateScreen), findsOneWidget);
    });

    testWidgets('무료 사용자 업셀 3번 초과 시 PremiumGateScreen 미표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final habits = List.generate(3, (i) => Habit(
        id: 'h-$i', userId: 'uid-1', name: '습관 $i',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      ));
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => habits);
      for (final h in habits) {
        when(() => mockHabit.getCheckins(habitId: h.id, userId: 'uid-1'))
            .thenAnswer((_) async => []);
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // FAB 3번 탭 (업셀 닫고 반복)
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        // 바텀시트 닫기
        await tester.tapAt(const Offset(0, 0));
        await tester.pumpAndSettle();
      }

      // 4번째 탭 - 이번엔 미표시
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(PremiumGateScreen), findsNothing);
    });

    testWidgets('HabitListScreen에 CompletionRateCard 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CompletionRateCard), findsOneWidget);
    });

    testWidgets('롱프레스 시 편집 다이얼로그 열림', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.text('매일 운동'));
      await tester.pumpAndSettle();

      expect(find.text('습관 편집'), findsOneWidget);
    });

    testWidgets('체크인 후 스트릭 수 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: any(named: 'date'),
          )).thenAnswer((_) async => Checkin(
            id: 'c-1',
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
            streakDay: 6, // 7일차
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('매일 운동'));
      await tester.pumpAndSettle();

      expect(find.textContaining('7일 연속'), findsOneWidget);
    });

    testWidgets('장착된 아이템 이름이 AppBar 서브타이틀에 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      const equippedItem = ShopItem(
        id: 'hat-1',
        name: '토끼 모자',
        price: 100,
        category: '의상',
        isOwned: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
            equippedItemsProvider.overrideWith(
              (ref) async => [equippedItem],
            ),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('토끼 모자'), findsOneWidget);
    });

    testWidgets('당근 포인트 탭 시 ShopScreen으로 이동', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('🥕'));
      await tester.pumpAndSettle();

      expect(find.byType(ShopScreen), findsOneWidget);
    });

    testWidgets('설정 아이콘 탭 시 NotificationSettingsScreen으로 이동', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    });

    testWidgets('상세 버튼 탭 시 HabitDetailScreen으로 이동', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(find.byType(HabitDetailScreen), findsOneWidget);
    });

    testWidgets('오늘 진행률 텍스트 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('0 / 1'), findsOneWidget);
    });

    testWidgets('습관이 없으면 EmptyHabitState 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHabitState), findsOneWidget);
    });

    testWidgets('프리미엄 사용자가 통계 이동 시 PremiumTeaserBanner 미표시',
        (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: true);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
      expect(find.text('업그레이드하기'), findsNothing);
    });

    testWidgets('통계 아이콘 탭 시 StatisticsScreen으로 이동', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
    });

    testWidgets('미션 아이콘 탭 시 MissionScreen으로 이동', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.emoji_events_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(MissionScreen), findsOneWidget);
    });

    testWidgets('습관 타일 탭 시 당근 포인트 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: any(named: 'date'),
          )).thenAnswer((_) async => Checkin(
            id: 'c-1',
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
            streakDay: 0,
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('매일 운동'));
      await tester.pumpAndSettle();

      expect(find.textContaining('+10 획득'), findsOneWidget);
    });

    testWidgets('습관 스와이프 삭제 시 확인 다이얼로그 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('삭제하면 기록도 사라져요'), findsOneWidget);
    });

    testWidgets('삭제 확인 누르면 deleteHabit 호출', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);
      when(() => mockHabit.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      verify(() => mockHabit.deleteHabit(habitId: 'h-1', userId: 'uid-1')).called(1);
    });

    testWidgets('삭제 취소 누르면 deleteHabit 미호출', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      verifyNever(() => mockHabit.deleteHabit(habitId: any(named: 'habitId'), userId: any(named: 'userId')));
    });

    testWidgets('체크인 후 5일 마일스톤이면 메시지 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: any(named: 'date'),
          )).thenAnswer((_) async => Checkin(
            id: 'c-1',
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
            streakDay: 4, // streakDay=4 → streak=5 (마일스톤)
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('매일 운동'));
      await tester.pumpAndSettle();

      expect(find.textContaining('불꽃이 타오르고 있어요'), findsOneWidget);
    });

    testWidgets('준비 제안 카드 추가하기 탭 시 AddHabitDialog 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '매일 운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      // 7일치 체크인 → rate = 1.0 >= 0.8 → HabitReadinessCard 표시
      final checkins = List.generate(
        7,
        (i) => Checkin(
          id: 'c-$i', habitId: 'h-1', userId: 'uid-1',
          date: today.subtract(Duration(days: i)),
          streakDay: i,
        ),
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('추가하기'), findsOneWidget);
      await tester.tap(find.text('추가하기'));
      await tester.pumpAndSettle();

      expect(find.text('새 습관 추가'), findsOneWidget);
    });

    testWidgets('"아직은 괜찮아" 탭 시 HabitReadinessCard 숨김', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '매일 운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      final checkins = List.generate(
        7,
        (i) => Checkin(
          id: 'c-$i', habitId: 'h-1', userId: 'uid-1',
          date: today.subtract(Duration(days: i)),
          streakDay: i,
        ),
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('아직은 괜찮아'), findsOneWidget);
      await tester.tap(find.text('아직은 괜찮아'));
      await tester.pumpAndSettle();

      expect(find.text('아직은 괜찮아'), findsNothing);
    });

    testWidgets('프리미엄 사용자 설정 화면에 유료 전용 안내 미표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: true);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
      expect(find.textContaining('유료 전용'), findsNothing);
    });

    testWidgets('습관 목록에 아이콘이 있으면 아이콘 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
              icon: '🏃',
            ),
          ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🏃'), findsOneWidget);
    });

    testWidgets('기존 체크인이 있으면 당근 포인트 합산 잔액 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 1),
        isActive: true,
      );
      final checkin1 = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 1),
        streakDay: 1,
      );
      final checkin2 = Checkin(
        id: 'c-2',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 2),
        streakDay: 2,
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => [checkin1, checkin2]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final expectedTotal = checkin1.carrotPoints + checkin2.carrotPoints;
      expect(find.textContaining('$expectedTotal'), findsWidgets);
    });

    testWidgets('구매한 아이템 가격만큼 당근 포인트 차감해서 잔액 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      final mockShop = MockShopRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 1),
        isActive: true,
      );
      // 10 checkins = 100 carrot points earned
      final checkins = List.generate(
        10,
        (i) => Checkin(
          id: 'c-$i',
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, i + 1),
          streakDay: i,
        ),
      );
      const ownedItem = ShopItem(
        id: 'acc-1',
        name: '당근 목걸이',
        price: 80,
        category: '액세서리',
        isOwned: true,
      );

      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);
      when(() => mockShop.getItems()).thenAnswer((_) async => [ownedItem]);
      when(() => mockShop.getOwnedItems()).thenAnswer((_) async => [ownedItem]);
      when(() => mockShop.getEquippedItems()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
            shopRepositoryProvider.overrideWithValue(mockShop),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // earned = 100, spent = 80, balance = 20
      final earned = checkins.fold(0, (s, c) => s + c.carrotPoints);
      final balance = earned - ownedItem.price;
      expect(find.textContaining('$balance'), findsWidgets);
    });

    testWidgets('첫 체크인 완료 시 mission-first-checkin 미션 자동 완료', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      final mockMission = MockMissionRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 1),
        isActive: true,
        targetDays: [0, 1, 2, 3, 4, 5, 6],
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);
      when(() => mockHabit.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: any(named: 'date'),
          )).thenAnswer((_) async => Checkin(
            id: 'c-1',
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime.now(),
            streakDay: 0,
          ));
      when(() => mockMission.getMissions()).thenAnswer((_) async => []);
      when(() => mockMission.completeMission(missionId: any(named: 'missionId')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
            missionRepositoryProvider.overrideWithValue(mockMission),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('운동'));
      await tester.pumpAndSettle();

      verify(() => mockMission.completeMission(missionId: 'mission-first-checkin'))
          .called(1);
    });
  });
}
