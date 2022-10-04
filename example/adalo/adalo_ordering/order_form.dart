import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/ui.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_ordering.dart';

class OrderFormScreen extends DocFormScreen {
  OrderFormScreen(
    super.doc, {
    super.title,
    required super.submitFunction,
    super.hiddenFields = const [],
    super.shownFields = const [],
    super.submitButtonText = "Submit",
    super.key,
  });

  @override
  State<DocFormScreen> createState() => OrderFormScreenState();
}

class OrderFormScreenState extends DocFormScreenState<OrderFormScreen> {
  late SQDoc orderDoc;
  late SQDocRefField foodTruckRef;
  late List<MenuItemDoc> foodTruckMenuItems;
  late List<SQDocRefField> orderItemsRefFields;

  int _stepperIndex = 1;

  double totalBeforeTaxAndTip = 0;
  double taxAmount = 0;
  double totalWithTaxAndTip = 0;

  late SQCollection orderItems;

  @override
  void initState() {
    orderDoc = widget.doc;
    foodTruckRef = orderDoc.getField("Food Truck")! as SQDocRefField;
    foodTruckMenuItems =
        menuItems.filter([DocRefFilter("Food Truck", foodTruckRef.value)]);
    orderItemsRefFields = (orderDoc.value("Order Items") as List<SQDocField>)
        .whereType<SQDocRefField>()
        .toList();
    orderItems = FirestoreCollection(
        id: "Order Items",
        parentDoc: widget.doc,
        fields: [
          SQStringField("Name"),
          SQDocRefField("Menu Item", collection: menuItems),
          SQDocRefField("Order", collection: orders),
          SQDoubleField("Price"),
        ],
        singleDocName: "Order Item");
    super.initState();
  }

  List<SQDoc> get thisOrderItems {
    List<SQDoc> ret = [];
    for (var refField in orderItemsRefFields) {
      SQDoc orderItem =
          orderItems.docs.firstWhere((doc) => doc.id == refField.value!.docId);
      ret.add(orderItem);
    }

    return ret;
  }

  void recalculate() {
    print("recalculating");
    totalBeforeTaxAndTip = 0;

    for (var orderItem in thisOrderItems) {
      totalBeforeTaxAndTip += orderItem.value("Price") ?? 0;
    }

    totalBeforeTaxAndTip =
        double.parse(totalBeforeTaxAndTip.toStringAsPrecision(4));

    taxAmount = totalBeforeTaxAndTip * 0.06875;

    taxAmount = double.parse(taxAmount.toStringAsPrecision(3));

    double tipAmount = (orderDoc.value("Tip Amount") ?? 0);

    totalWithTaxAndTip = totalBeforeTaxAndTip + taxAmount + tipAmount;

    totalWithTaxAndTip =
        double.parse(totalWithTaxAndTip.toStringAsPrecision(4));

    orderDoc.setDocFieldByName("Total Paid", totalWithTaxAndTip);
    orderDoc.setDocFieldByName("Tip Amount", tipAmount);
  }

  @override
  void refreshScreen() {
    recalculate();
    super.refreshScreen();
  }

  void addMenuItem(MenuItemDoc menuItem) {
    SQDoc newOrderItem = orderItems.newDoc(initialFields: [
      SQStringField("Name", value: menuItem.name),
      SQDocRefField("Menu Item", value: menuItem.ref, collection: menuItems),
      SQDocRefField("Order", value: orderDoc.ref, collection: orders),
      SQDoubleField(
        "Price",
        value: menuItem.price,
      ),
    ]);

    orderItemsRefFields.add(
        SQDocRefField("", value: newOrderItem.ref, collection: orderItems));

    refreshScreen();
  }

  void deleteOrderItem(SQDoc orderItem) {
    orderItemsRefFields
        .removeWhere((field) => field.value!.docId == orderItem.id);
    refreshScreen();
  }

  int orderItemCount(SQDoc menuItem) {
    return orderItemsRefFields
        .whereType<SQDocRefField>()
        .where((orderItemRef) =>
            (orderItems.docs
                    .firstWhere((doc) => doc.id == orderItemRef.value!.docId)
                    .value("Menu Item") as SQDocRef)
                .docId ==
            menuItem.id)
        .length;
  }

  void placeOrder() async {
    for (SQDoc orderItemDoc in orderItems.docs) {
      await orderItemDoc.saveDoc();
    }

    orderDoc.setDocFieldByName("Order Items", orderItemsRefFields);
    submitForm();
  }

  @override
  Widget screenBody(BuildContext context) {
    return Stepper(
      physics: ClampingScrollPhysics(),
      currentStep: _stepperIndex,
      controlsBuilder: (context, details) {
        return Row(
          children: [
            if (_stepperIndex == 2)
              SQButton("Pay and Place Order", onPressed: placeOrder)
            else
              SQButton("Continue", onPressed: details.onStepContinue),
            SQButton("Back", onPressed: details.onStepCancel),
          ],
        );
      },
      onStepCancel: () {
        if (_stepperIndex == 0) return exitScreen(context);
        _stepperIndex -= 1;
        refreshScreen();
      },
      onStepContinue: () {
        if (_stepperIndex <= 1) _stepperIndex += 1;
        refreshScreen();
      },
      onStepTapped: (int index) {
        _stepperIndex = index;
        refreshScreen();
      },
      steps: <Step>[
        Step(
          title: Text('Setup Pickup Time'),
          content: Column(
            children: [
              foodTruckRef.formField(),
              orderDoc.getField("Pick up time")!.formField()
            ],
          ),
        ),
        selectMenuItemsStep(),
        Step(
          title: Text("Pay for Your Food"),
          content: Column(
            children: [
              Text("Items Ordered"),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  itemCount: orderItemsRefFields.length,
                  itemBuilder: ((context, index) {
                    SQDoc orderItem = thisOrderItems[index];
                    return ListTile(
                      title: Text(orderItem.identifier),
                      subtitle: Text("US\$${orderItem.value("Price")}"),
                      dense: true,
                      trailing: IconButton(
                          onPressed: () => deleteOrderItem(orderItem),
                          icon: Icon(Icons.delete)),
                    );
                  }),
                ),
              ),
              orderDoc.getField("Notes")!.formField(),
              Text("Cost"),
              Text("Total Before Tax & Tip: US\$$totalBeforeTaxAndTip"),
              Text("Tax Amount: US\$$taxAmount"),
              orderDoc
                  .getField("Tip Amount")!
                  .formField(onChanged: refreshScreen),
              Text("Total with Tip and Tax: US\$$totalWithTaxAndTip"),
              // orderDoc.getFieldByName("Total Paid")!.formField(),
            ],
          ),
        )
      ],
    );
  }

  Step selectMenuItemsStep() {
    return Step(
        title: Text('Select Your Order'),
        subtitle: Text("Add Items to Your Order"),
        content: SingleChildScrollView(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: foodTruckMenuItems.length,
              itemBuilder: ((context, index) {
                MenuItemDoc menuItem = foodTruckMenuItems[index];
                int menuItemCount = orderItemCount(menuItem);
                return ListTile(
                  title: Text(menuItem.identifier),
                  subtitle: Text("US\$${menuItem.price}"),
                  dense: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (menuItemCount > 0) Text(menuItemCount.toString()),
                      IconButton(
                          onPressed: () => addMenuItem(menuItem),
                          icon: Icon(Icons.add_shopping_cart)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ));
  }
}
