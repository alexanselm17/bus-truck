import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/response_dialog.dart';
import '../../common_widgets/roundedTrackerBtn.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../models/parent/my_student_list.dart';
import '../../models/payment_plans_model.dart';
import '../../providers/app_state.dart';
import '../../providers/payment_provider.dart';
import '../../utils/constants.dart';
import '../../utils/conversion_util.dart';

class PaymentPage extends StatefulWidget {
  final Student? student;

  const PaymentPage({Key? key, @required this.student, int? studentId})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<PaymentProvider>(context, listen: false).getPaymentPlans();
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.colorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Payment"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Select Payment Plans",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            VerticalSpacing(),
            Container(
              height: 150.0,
              child: Consumer<PaymentProvider>(
                builder: (context, paymentPlan, child) =>
                    paymentPlan.paymentPlanStatus == OperationStatus.Loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: paymentPlan.paymentPlan.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _showPaymentPlan(
                                  paymentPlan.paymentPlan[index],
                                  context,
                                  paymentPlan);
                            },
                          ),
              ),
            ),
            VerticalSpacing(),
            Consumer<PaymentProvider>(
              builder: (context, paymentProvider, child) => Container(
                child: paymentProvider.makePaymentStatus ==
                        OperationStatus.Loading
                    ? Loading()
                    : appState.selectedPlanId != 0
                        ? RoundedTrackerBtn(
                            text: "Make Payment",
                            press: () async {
                              int planId =
                                  Provider.of<AppState>(context, listen: false)
                                      .selectedPlanId;
                              bool res = await Provider.of<PaymentProvider>(
                                      context,
                                      listen: false)
                                  .makePayment(
                                      studentId: widget.student!.id,
                                      planId: planId);
                              res
                                  ? ResponseDialog(
                                      context: context, response: res)
                                  : ResponseDialog(
                                      context: context,
                                      response: res,
                                      success: false);
                            },
                          )
                        : RoundedTrackerBtn(
                            press: () {
                              return null;
                            },
                            color: Colors.grey,
                            text: "Make Payment",
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _showPaymentPlan(
    Plan plan, BuildContext context, PaymentProvider paymentPlan) {
  final appState = Provider.of<AppState>(context);
  final _isSelectedPlan = appState.selectedPlanId == plan.id;
  return GestureDetector(
    onTap: () {
      if (!_isSelectedPlan &&
          paymentPlan.makePaymentStatus != OperationStatus.Loading) {
        appState.updateSelectedPlanId(plan.id!);
      }
    },
    child: Card(
      child: Container(
        width: 200.0,
        color: _isSelectedPlan ? AppConstants.colorPrimary : Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              plan.name!,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _isSelectedPlan ? Colors.white : Colors.black),
            ),
            VerticalSpacing(),
            Text(
              plan.description!,
              style: TextStyle(
                  color: _isSelectedPlan ? Colors.white : Colors.black),
            ),
            VerticalSpacing(),
            Text(ConversionUtils.formatCurrency(plan.amount) + ' /=',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isSelectedPlan ? Colors.white : Colors.black))
          ],
        ),
      ),
    ),
  );
}
