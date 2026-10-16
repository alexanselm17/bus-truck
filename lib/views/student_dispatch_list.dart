import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../common_widgets/app_card.dart';
import '../common_widgets/loading.dart';
import '../common_widgets/tracker_divider.dart';
import '../common_widgets/vertical_spacing.dart';
import '../enums/operation_status.dart';
import '../models/driver_trip.dart';
import '../models/pending_students.dart';
import '../providers/driver_provider.dart';
import '../providers/location_provider.dart';
import '../utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DispatchList extends StatefulWidget {
  final TripType? tripType;
  final Trip? trip;
  final bool embedded;

  DispatchList({
    Key? key,
    @required this.tripType,
    @required this.trip,
    this.embedded = false,
  }) : super(key: key);
  @override
  _DispatchListState createState() => _DispatchListState();
}

class _DispatchListState extends State<DispatchList> {
  final TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  late DriverProvider _driverProvider;
  bool _isSearchStudent = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _driverProvider = Provider.of<DriverProvider>(context, listen: false);
    searchController.addListener(searchListener);
    _scrollController.addListener(scrollControllerListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tripId = widget.trip?.id;
      if (mounted && tripId != null) {
        _driverProvider.getPendingStudents(tripId: tripId);
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    searchNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollControllerListener() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      await _driverProvider.getPendingStudentsPaginated(
          tripId: widget.trip!.id);
    }
  }

  Future refresh() async {
    await _driverProvider.getPendingStudents(tripId: widget.trip!.id!);
  }

  void searchListener() {
    search(searchController.text);
  }

  void search(String query) async {
    if (query.isEmpty) {
      return;
    } else {
      await _driverProvider.searchPendingStudents(
          searchQuery: query, tripId: widget.trip!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: widget.embedded
          ? null
          : AppBar(
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearchStudent = true;
                        searchNode.requestFocus();
                      });
                    },
                    icon: Icon(Icons.search))
              ],
              backgroundColor: AppConstants.colorPrimary,
              title: Text("Dispatch List"),
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _isSearchStudent
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search student by name or admission',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 16,
                          ),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        labelStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.grey.shade50, width: 1.0),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                    controller: searchController,
                    focusNode: searchNode,
                    autofocus: true,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // setState(() {
                        //   controller.users.clear();
                        // });
                      }
                    },
                    textInputAction: TextInputAction.search,
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Consumer<DriverProvider>(
              builder: (context, driverProvider, child) => ((driverProvider
                                  .searchingPendingStudent ==
                              OperationStatus.Loading &&
                          driverProvider.pendingStudent.isEmpty) ||
                      driverProvider.pendingStudentLoadingStatus ==
                          OperationStatus.Loading ||
                      driverProvider.dispatchRefresh == OperationStatus.Loading)
                  ? Loading()
                  : driverProvider.pendingStudent.isEmpty
                      ? const _EmptyDispatchList()
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              itemCount:
                                  driverProvider.pendingStudent.length + 1,
                              itemBuilder: (context, i) {
                                if (i < driverProvider.pendingStudent.length) {
                                  return DispatchItem(
                                    student: driverProvider.pendingStudent[i],
                                    tripType: widget.tripType!,
                                    trip: widget.trip!,
                                    onStudentDrop: () {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(content: Text("on drop")));
                                    },
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32),
                                    child: Center(
                                        child:
                                            driverProvider.hasMoreStudentsOnTrip
                                                ? CircularProgressIndicator()
                                                : Text('No more data to load')),
                                  );
                                }
                              }),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDispatchList extends StatelessWidget {
  const _EmptyDispatchList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3B0),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.how_to_reg_outlined,
                size: 44,
                color: AppConstants.navy,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No students waiting',
              style: TextStyle(
                color: AppConstants.navy,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'There are no remaining students for this trip.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class DispatchItem extends StatefulWidget {
  final PendingStudents? student;
  final TripType? tripType;
  final Trip? trip;
  final Function? onStudentDrop;

  const DispatchItem(
      {Key? key,
      this.student,
      @required this.tripType,
      this.trip,
      @required this.onStudentDrop})
      : super(key: key);

  _DispatchItem createState() => _DispatchItem();
}

class _DispatchItem extends State<DispatchItem> {
  final TextEditingController skipReasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int actioningId = 0;
  @override
  Widget build(BuildContext context) {
    LocationProvider _locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    return Consumer<DriverProvider>(
      builder: (context, driverProvider, child) => AppCard(
        child: actioningId == widget.student!.id &&
                (driverProvider.dropStudentStatus == OperationStatus.Loading ||
                    driverProvider.pickStudentStatus == OperationStatus.Loading)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loading(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Image.asset(
                            'assets/images/studentIcon.png',
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.student!.name!,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              height: 33.0,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  widget.student!.locationName ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacing(),
                  TrackerDivider(),
                  VerticalSpacing(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Text(
                          'Guardian Details',
                          style: TextStyle(
                              color: AppConstants.colorPrimaryDark,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (dialogContext) => GuardianDetails(
                              parent: widget.student!.parent,
                            ),
                          );
                        },
                      ),
                      InkWell(
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: AppConstants.colorPrimaryDark,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () async {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () => addSkipComment(
                              context,
                              onTap: () async {
                                Navigator.pop(context);
                                setState(() {
                                  actioningId = widget.student!.id!;
                                });
                                bool res = await driverProvider.skipStudent(
                                    reason: skipReasonController.text.trim(),
                                    studentId: widget.student!.id,
                                    tripId: widget.trip!.id,
                                    lat: _locationProvider
                                        .userCurrentLocation.latitude,
                                    long: _locationProvider
                                        .userCurrentLocation.longitude);

                                if (res) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    "Student Skipped Successfully",
                                  )));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    "Unable to skip student",
                                  )));
                                }
                              },
                            ),
                          );
                        },
                      ),
                      InkWell(
                        child: Text(
                          widget.tripType == TripType.DROP ? 'Drop' : 'Pick',
                          style: TextStyle(
                              color: AppConstants.colorPrimaryDark,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () async {
                          debugPrint(widget.tripType.toString());
                          setState(() {
                            actioningId = widget.student!.id!;
                          });
                          bool res = widget.tripType == TripType.DROP
                              ? await driverProvider.dropStudent(
                                  studentId: widget.student!.id,
                                  tripId: widget.trip!.id,
                                  lat: _locationProvider
                                      .userCurrentLocation.latitude,
                                  long: _locationProvider
                                      .userCurrentLocation.longitude)
                              : await driverProvider.pickStudent(
                                  studentId: widget.student!.id,
                                  tripId: widget.trip!.id,
                                  lat: _locationProvider
                                      .userCurrentLocation.latitude,
                                  long: _locationProvider
                                      .userCurrentLocation.longitude);

                          if (res) {
                            // reload the pending student details

                            widget.onStudentDrop!();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              widget.tripType == TripType.DROP
                                  ? "Student Dropped Successfully"
                                  : "Student Picked Successfully",
                            )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              widget.tripType == TripType.DROP
                                  ? "Unable to Drop student"
                                  : "Unable to Picked student",
                            )));
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<dynamic> addSkipComment(BuildContext context,
      {required VoidCallback onTap}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter reason why you skipped the student',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Reason is required";
                        }
                        return null;
                      },
                      controller: skipReasonController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text('Comment'),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            onTap();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Text(
                            'Send',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GuardianDetails extends StatelessWidget {
  final Parent? parent;

  const GuardianDetails({Key? key, this.parent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  parent!.name!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalSpacing(),
                Text(parent!.phone!),
                VerticalSpacing(),
                GestureDetector(
                  onTap: () => launch("tel://${parent!.phone}"),
                  child: Icon(
                    Icons.call,
                    size: 30.0,
                    color: AppConstants.colorPrimary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
