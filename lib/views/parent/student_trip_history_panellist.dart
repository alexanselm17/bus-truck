import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/loading.dart';
import '../../enums/operation_status.dart';
import '../../models/trip_history.dart';
import '../../providers/trip_history_provider.dart';
import '../../utils/conversion_util.dart';

class StudentTripHistory extends StatefulWidget {
  final int? studentId;

  const StudentTripHistory({Key? key, @required this.studentId})
      : super(key: key);

  @override
  _StudentTripHistoryState createState() => _StudentTripHistoryState();
}

class _StudentTripHistoryState extends State<StudentTripHistory> {
  int expandedIndex = 0;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Provider.of<TripHistory>(context, listen: false)
        .fetchTrips(widget.studentId!);
  }

  Widget _buildFilterChips(List<History> trips) {
    List<String> filters = ['All', 'Pick up', 'Drop off'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            bool isSelected = selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isSelected,
                selectedColor: Colors.blue[600],
                backgroundColor: Colors.grey[100],
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<History> _getFilteredTrips(List<History> trips) {
    if (selectedFilter == 'All') return trips;

    return trips.where((trip) {
      String tripType = trip.trip!.type == 1 ? 'Pick up' : 'Drop off';
      return tripType == selectedFilter;
    }).toList();
  }

  Widget _getTripIcon(int tripType) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: tripType == 1 ? Colors.green[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        tripType == 1 ? Icons.login_rounded : Icons.logout_rounded,
        color: tripType == 1 ? Colors.green[600] : Colors.blue[600],
        size: 20,
      ),
    );
  }

  Widget _showTripDetails(List<History> tripHistory) {
    List<History> filteredTrips = _getFilteredTrips(tripHistory);

    if (filteredTrips.isEmpty) {
      return Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No trips found for "$selectedFilter"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: filteredTrips.map((History item) {
          bool isExpanded = expandedIndex == item.id!;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: isExpanded,
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    if (expanded) {
                      expandedIndex = item.id!;
                    } else {
                      expandedIndex = 0;
                    }
                  });
                },
                leading: _getTripIcon(item.trip!.type!),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.trip!.type == 1
                                ? 'Pick up Trip'
                                : 'Drop off Trip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (item.trip!.vehicle != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.trip!.vehicle!.plateNo!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Text(
                        ConversionUtils.formatUtc(item.actionTime.toString()),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey[200]),
                        SizedBox(height: 8),
                        Text(
                          'Trip Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        _showTripActionData(item.data!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'boarding':
      case 'board':
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_bus, color: Colors.green[600], size: 16),
        );
      case 'arrival':
      case 'arrived':
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.location_on, color: Colors.blue[600], size: 16),
        );
      case 'departure':
      case 'departed':
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
          child:
              Icon(Icons.departure_board, color: Colors.orange[600], size: 16),
        );
      default:
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.event, color: Colors.grey[600], size: 16),
        );
    }
  }

  Widget _showTripActionData(List<Data> data) {
    if (data.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
            SizedBox(width: 8),
            Text(
              'No event details available',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          Data eventData = data[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _getEventIcon(eventData.eventType!),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData.eventType!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        eventData.name!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ConversionUtils.formatUtc(eventData.time.toString()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 48,
              color: Colors.blue[300],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Trip History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Trip history will appear here once\nthe student starts taking trips',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(List<History> trips) {
    int pickupCount = trips.where((trip) => trip.trip!.type == 1).length;
    int dropoffCount = trips.where((trip) => trip.trip!.type == 2).length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
                'Total Trips', trips.length.toString(), Icons.route),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatCard(
                'Pick ups', pickupCount.toString(), Icons.login_rounded),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatCard(
                'Drop offs', dropoffCount.toString(), Icons.logout_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<TripHistory>(context, listen: false)
              .fetchTrips(widget.studentId!);
        },
        color: Colors.blue[600],
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Consumer<TripHistory>(
            builder: (context, tripHistoryProvider, child) {
              if (tripHistoryProvider.tripHstoryStatus ==
                  OperationStatus.Loading) {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Loading(),
                        SizedBox(height: 16),
                        Text(
                          'Loading trip history...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (tripHistoryProvider.getTripHistory.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildEmptyState(),
                );
              }

              return _showTripDetails(tripHistoryProvider.getTripHistory);
            },
          ),
        ),
      ),
    );
  }
}
