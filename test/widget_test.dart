import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_tracker/enums/operation_status.dart';
import 'package:school_tracker/providers/driver_provider.dart';
import 'package:school_tracker/utils/app_theme.dart';
import 'package:school_tracker/utils/constants.dart';

void main() {
  test('driver state starts with safe empty collections', () {
    final provider = DriverProvider();

    expect(provider.driverTrips, isEmpty);
    expect(provider.pendingStudents, isEmpty);
    expect(provider.pendingStudent, isEmpty);
    expect(provider.pendingStudentLoadingStatus, OperationStatus.Loaded);
  });

  testWidgets('school bus theme uses the yellow and navy design system',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: Text('School Track')),
      ),
    );

    final context = tester.element(find.text('School Track'));
    final theme = Theme.of(context);

    expect(theme.colorScheme.primary, AppConstants.colorPrimary);
    expect(theme.colorScheme.onPrimary, AppConstants.navy);
    expect(theme.scaffoldBackgroundColor, AppConstants.background);
  });
}
