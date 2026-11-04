import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/account/data/models/get_user_card/profile_response.dart'
    show ProfileVolunteer;
import 'package:sanad/features/account/data/models/volunteer_title.dart';
import 'package:sanad/features/account/ui/Widgets/leaderboard/data/models/leaderboard_response.dart';
import 'package:sanad/features/account/ui/Widgets/volunteer_title_badge.dart';

void main() {
  const titleJson = {
    'id': 2,
    'name': 'صانع الخير',
    'level': 2,
    'description': 'مساهمات تطوعية موثقة وبداية أثر ملموس.',
    'icon': 'heart',
  };

  test('profile volunteer parses its backend title', () {
    final volunteer = ProfileVolunteer.fromJson({
      'id': 1,
      'fullName': 'AHMED',
      'nationalId': '123',
      'email': 'ahmed@example.com',
      'phone': '01000000000',
      'status': 'ACTIVE',
      'joinDate': '2026-01-01',
      'volunteerTitle': titleJson,
    });

    expect(volunteer.volunteerTitle?.name, 'صانع الخير');
    expect(volunteer.volunteerTitle?.level, 2);
  });

  test('leaderboard volunteer parses its backend title', () {
    final volunteer = LeaderboardUser.fromJson({
      'rank': 2,
      'id': 1,
      'fullName': 'AHMED',
      'avatarUrl': null,
      'isCurrentUser': true,
      'status': 'ACTIVE',
      'points': 100,
      'totalHours': 1,
      'completedCampaigns': 1,
      'reportsCount': 1,
      'volunteerTitle': titleJson,
    });

    expect(volunteer.volunteerTitle?.name, 'صانع الخير');
    expect(volunteer.volunteerTitle?.icon, 'heart');
  });

  test('missing or incomplete backend title is ignored', () {
    expect(volunteerTitleFromJson(null), isNull);
    expect(volunteerTitleFromJson({'name': 'بدون مستوى'}), isNull);
  });

  testWidgets('renders all five levels with distinct icons and colors', (
    tester,
  ) async {
    final colors = <Color>{};
    final icons = <IconData>{};

    for (var level = 1; level <= 5; level++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VolunteerTitleBadge(
              title: VolunteerTitle(
                id: level,
                name: 'لقب $level',
                level: level,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('لقب $level'), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      colors.add(icon.color!);
      icons.add(icon.icon!);
    }

    expect(colors, hasLength(5));
    expect(icons, hasLength(5));
  });

  testWidgets('hides the badge when no title is available', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: VolunteerTitleBadge(title: null))),
    );

    expect(find.byType(Icon), findsNothing);
  });
}
