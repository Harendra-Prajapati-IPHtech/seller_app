import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/items_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
        title: const Text(
          "iFood",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          Positioned(
              child: Stack(
            children: const [
              Icon(
                Icons.brightness_1,
                size: 20,
                color: Colors.green,
              ),
              Positioned(
                top: 3,
                right: 4,
                child: Center(
                  child: Text(
                    "0",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            // pinned: true,
            delegate: TextWidgetHeader(title: ""),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length);
            },
          ),
        ],
      ),
    );
  }
}
