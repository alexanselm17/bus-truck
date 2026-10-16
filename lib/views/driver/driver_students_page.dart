import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/operation_status.dart';
import '../../models/driver_trip.dart';
import '../../providers/driver_provider.dart';
import '../../utils/constants.dart';
import '../student_dispatch_list.dart';

class DriverStudentsPage extends StatelessWidget {
  const DriverStudentsPage({super.key, required this.onOpenTrips});

  final VoidCallback onOpenTrips;

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, driverProvider, child) {
        if (driverProvider.getDriverTripStatus == OperationStatus.Loading &&
            driverProvider.driverTrips.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final activeTrip = driverProvider.driverTrips.firstWhere(
          (trip) => trip.endAt == null,
          orElse: Trip.new,
        );

        if (activeTrip.id == null) {
          return _NoActiveTrip(onOpenTrips: onOpenTrips);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7CF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFFE16A)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppConstants.navy,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: AppConstants.colorPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeTrip.dispatch?.name ?? 'Active trip',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppConstants.navy,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            activeTrip.type == 1
                                ? 'Students scheduled for pickup'
                                : 'Students scheduled for drop-off',
                            style: const TextStyle(
                              color: Color(0xFF5E6674),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DispatchList(
                embedded: true,
                trip: activeTrip,
                tripType: activeTrip.type == 1 ? TripType.PICK : TripType.DROP,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NoActiveTrip extends StatelessWidget {
  const _NoActiveTrip({required this.onOpenTrips});

  final VoidCallback onOpenTrips;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3B0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.groups_outlined,
                size: 52,
                color: AppConstants.navy,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No active trip',
              style: TextStyle(
                color: AppConstants.navy,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Students assigned to your route will appear here after you start a trip.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onOpenTrips,
              icon: const Icon(Icons.route_rounded),
              label: const Text('Open Trips'),
            ),
          ],
        ),
      ),
    );
  }
}
