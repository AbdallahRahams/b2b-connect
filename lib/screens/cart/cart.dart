import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<Cart> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        elevation: 0.5,
        shadowColor: divider4,
      ),
      body: ListView(
        children: const [

        ],
      ),
    );
  }
}
