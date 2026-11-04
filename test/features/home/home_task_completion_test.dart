import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/home/data/models/home_response.dart';

HomeTask _task({
  String status = 'ASSIGNED',
  String assignmentStatus = 'ASSIGNED',
}) {
  return HomeTask(
    id: 1,
    title: 'مهمة اختبار',
    date: '2026-11-03',
    status: status,
    location: const TaskLocation(
      id: 1,
      name: 'موقع',
      latitude: 0,
      longitude: 0,
      city: 'دمياط',
      area: 'دمياط',
    ),
    campaign: const TaskCampaign(id: 1, title: 'حملة'),
    assignment: TaskAssignment(status: assignmentStatus),
  );
}

void main() {
  test('recognizes completed mission and assignment states', () {
    for (final status in [
      'COMPLETED',
      'DONE',
      'FINISHED',
      'REPORT_SUBMITTED',
    ]) {
      expect(_task(status: status).isCompleted, isTrue);
    }

    expect(_task(assignmentStatus: 'CHECKED_OUT').isCompleted, isTrue);
    expect(_task(assignmentStatus: 'SUBMITTED').isCompleted, isTrue);
  });

  test('keeps assigned tasks active', () {
    expect(_task().isCompleted, isFalse);
  });
}
