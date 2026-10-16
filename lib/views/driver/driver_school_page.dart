import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/operation_status.dart';
import '../../models/school_list.dart';
import '../../providers/driver_provider.dart';
import '../../utils/constants.dart';

class DriverSchoolPage extends StatefulWidget {
  const DriverSchoolPage({super.key});

  @override
  State<DriverSchoolPage> createState() => _DriverSchoolPageState();
}

class _DriverSchoolPageState extends State<DriverSchoolPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DriverProvider>().getAttachedSchool();
    });
  }

  String _initials(String? name) {
    final words = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'SC';
    return words.take(2).map((word) => word[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        if (provider.fetchingSchoolStatus == OperationStatus.Loading &&
            provider.school.id == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.fetchingSchoolStatus == OperationStatus.Error &&
            provider.school.id == null) {
          return _SchoolMessage(
            icon: Icons.cloud_off_rounded,
            title: 'Could not load school',
            message: 'Check your connection and try again.',
            actionLabel: 'Try Again',
            onAction: provider.getAttachedSchool,
          );
        }

        if (provider.school.id == null) {
          return _SchoolMessage(
            icon: Icons.school_outlined,
            title: 'No school assigned',
            message:
                'The school you transport children for will appear here once assigned.',
            actionLabel: 'Refresh',
            onAction: provider.getAttachedSchool,
          );
        }

        return RefreshIndicator(
          color: AppConstants.navy,
          onRefresh: provider.getAttachedSchool,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Assigned school',
                style: TextStyle(
                  color: AppConstants.navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your current transport assignment',
                style: TextStyle(color: Color(0xFF667085), fontSize: 14),
              ),
              const SizedBox(height: 18),
              _SchoolCard(
                school: provider.school,
                initials: _initials(provider.school.name),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SchoolCard extends StatelessWidget {
  const _SchoolCard({required this.school, required this.initials});

  final Schools school;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EBF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D172033),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppConstants.colorPrimary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: AppConstants.navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name ?? 'Assigned school',
                      style: const TextStyle(
                        color: AppConstants.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            color: Color(0xFF16A34A), size: 17),
                        SizedBox(width: 5),
                        Text(
                          'Active assignment',
                          style: TextStyle(
                            color: Color(0xFF16803A),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SchoolDetail(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: school.address ?? 'No address provided',
          ),
          if ((school.phone ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            _SchoolDetail(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: school.phone!,
            ),
          ],
          if ((school.email ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            _SchoolDetail(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              value: school.email!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SchoolDetail extends StatelessWidget {
  const _SchoolDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7CF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppConstants.navy, size: 19),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF7A8495),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppConstants.navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SchoolMessage extends StatelessWidget {
  const _SchoolMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3B0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(icon, size: 52, color: AppConstants.navy),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppConstants.navy,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
