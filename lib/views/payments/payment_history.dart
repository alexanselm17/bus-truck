import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/loading.dart';
import '../../enums/operation_status.dart';
import '../../providers/payment_provider.dart';
import '../../utils/constants.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key, this.embedded = false});

  final bool embedded;

  @override
  _PaymentHistory createState() => _PaymentHistory();
}

class _PaymentHistory extends State<PaymentHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<PaymentProvider>(context, listen: false)
            .getPaymentHistory();
      }
    });
  }

  String _formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);

      final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
      final DateFormat timeFormatter = DateFormat('h:mm a');

      final String formattedDate = dateFormatter.format(dateTime);
      final String formattedTime = timeFormatter.format(dateTime);

      return '$formattedDate at $formattedTime';
    } catch (e) {
      return dateTimeString;
    }
  }

  Widget _buildStatusBadge(int status) {
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 1:
        badgeColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = Icons.access_time;
        break;
      case 2:
        badgeColor = Colors.green;
        statusText = 'Successful';
        statusIcon = Icons.check_circle;
        break;
      default:
        badgeColor = Colors.red;
        statusText = 'Failed';
        statusIcon = Icons.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: badgeColor, size: 14),
          SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Transaction History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your payment transactions will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: widget.embedded
          ? null
          : AppBar(
              backgroundColor: AppConstants.colorPrimary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: AppConstants.navy, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Payment History',
                style: TextStyle(
                  color: AppConstants.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConstants.navy.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(Icons.refresh, color: AppConstants.navy, size: 18),
                  ),
                  onPressed: () {
                    Provider.of<PaymentProvider>(context, listen: false)
                        .getPaymentHistory();
                  },
                ),
                SizedBox(width: 12),
              ],
            ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentHistory, child) => paymentHistory
                    .makePaymentStatus ==
                OperationStatus.Loading
            ? Center(child: Loading())
            : paymentHistory.paymentHistory.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: paymentHistory.paymentHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      final payment = paymentHistory.paymentHistory[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Student Avatar
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppConstants.colorPrimary,
                                          AppConstants.colorPrimaryDark,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppConstants.colorPrimary
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        payment!.student!.name!
                                            .split(' ')
                                            .map((name) => name[0])
                                            .take(2)
                                            .join('')
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 16),

                                  // Transaction Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Payment for ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                payment.student!.name!,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'M-PESA',
                                                style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Ref: ${payment.referenceId}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Amount and Status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'KSh ${double.parse(payment.amount!).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      _buildStatusBadge(payment.status!),
                                    ],
                                  ),
                                ],
                              ),

                              // Date/Time section
                              if (payment.createdAt != null) ...[
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 6),
                                      Text(
                                        _formatDateTime(payment.createdAt!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    })
                : _buildEmptyState(),
      ),
    );
  }
}
