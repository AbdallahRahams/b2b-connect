import 'package:b2b_connect/providers/wholesalers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/wholesaler_screen.dart';
import 'wholesaler_horizontal.dart';

class WholesalersList extends StatefulWidget {
  const WholesalersList({Key? key}) : super(key: key);

  @override
  State<WholesalersList> createState() => _WholesalersListState();
}

class _WholesalersListState extends State<WholesalersList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WholesalersProvider>(
        builder: (context, wholesalerProvider, _) {
      return Column(
        children: [
          for (var wholesaler in wholesalerProvider.wholesalers)
            Material(
              child: InkWell(
                onTap: () {
                  wholesalerProvider.setActiveWholesaler(wholesaler);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const WholesalerScreen()));
                },
                child: WholesalerHorizontal(wholesaler: wholesaler),
              ),
            ),
        ],
      );
    });
  }
}
