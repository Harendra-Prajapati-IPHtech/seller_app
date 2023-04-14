import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "My Orders",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("orders")
            .where("status", isEqualTo: "Normal")
            .orderBy("orderTime", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("items")
                          .where("itemId",
                              whereIn: separateOrderItemIds(
                                  (snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>)["porductIds"]))
                          .where("orderedBy",
                              whereIn: (snapshot.data!.docs[index].data()!
                                  as Map<List, dynamic>)["uid"])
                          .orderBy("publishedDate", descending: true)
                          .get(),
                      builder: (context, snap) {
                        return snap.hasData
                            ? OrderCard(
                                itemCount: snap.data!.docs.length,
                                data: snap.data!.docs,
                                orderId: snapshot.data!.docs[index].id,
                                seperateQuantitiesList:
                                    separateOrderItemQuantities((snapshot
                                            .data!.docs[index]
                                            .data()!
                                        as Map<List, dynamic>)["productId"]),
                              )
                            : Center(
                                child: circularProgress(),
                              );
                      },
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                )
              : Center(
                  child: circularProgress(),
                );
        },
      ),
    );
  }
}
