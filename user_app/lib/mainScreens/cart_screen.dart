import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/widgets/cart_item_design.dart';
import 'package:user_app/widgets/progress_bar.dart';

import '../assistant_methods/cart_item_counter.dart';
import '../widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  CartScreen({this.sellerUID});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  @override
  void initState() {
    super.initState();
    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              clearCartNow(context);
            },
            icon: const Icon(Icons.clear_all)),
        title: const Text(
          "iFood",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: () {
                clearCartNow(context);
              },
              label: const Text("Clear Cart"),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Check Out"),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            // pinned: true,
            delegate: TextWidgetHeader(title: "Totoal Ammount=100"),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("itemId", whereIn: separateItemIds())
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : snapshot.data!.docs.length == 0
                        ? Container()
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, index) {
                            Items model = Items.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>,
                            );
                            return CartItemDesign(
                              model: model,
                              context: context,
                              quanNumber: separateItemQuantityList![index],
                            );
                          },
                                childCount: snapshot.hasData
                                    ? snapshot.data!.docs.length
                                    : 0));
              }),
        ],
      ),
    );
  }
}
