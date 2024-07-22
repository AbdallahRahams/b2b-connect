import 'dart:async';
import 'dart:developer';
import 'package:b2b_connect/icon_fonts/icon_pack_bold_icons.dart';
import 'package:b2b_connect/icon_fonts/icon_pack_outline_icons.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/screens/home_pages/wholesalers_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import '../cart/cart.dart';
import '../orders/my_orders.dart';
import 'more_page.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  ValueNotifier<int> _activeTab1 = ValueNotifier(0);
  DateTime? currentBackPressTime;
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  _setActiveTab({required int index}) {
    if (_activeTab1.value == index) return;
    _activeTab1.value = index;
  }

  List<Widget> _pages = [
    const WholesalersPage(),
    const Cart(),
    const MyOrders(),
    const MorePage(),
  ];




  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    //_printAppSignature();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future<void> _printAppSignature() async {
    String signature = await SmsAutoFill().getAppSignature;
    print('App Signature: $signature');
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cText2,
        timeInSecForIosWeb: 2,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ChangeNotifierProvider(
        create: (_) => HomeActiveTabProvider(),
        child: Consumer<AuthenticationProvider>(
          builder: (context, AuthenticationProvider auth, child) {
            return SizedBox(
              child: ValueListenableBuilder(
                valueListenable: _activeTab1,
                builder: (context, int active, _) {
                  return Scaffold(
                    body: _pages[active],
                    bottomNavigationBar: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 100,
                        minHeight: 40,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: divider4, width: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            navigationItem(
                              context,
                              index: 0,
                              icon: IconPackOutline.home,
                              iconSelected: IconPackBold.home,
                              label: "Wholesales",
                              selectedLabel: '"Wholesales',
                              selected: active == 0,
                            ),
                            navigationItem(
                              context,
                              index: 1,
                              icon: IconPackOutline.shopping_cart,
                              iconSelected: IconPackBold.shopping_cart,
                              label: "Cart",
                              selectedLabel: '"Cart',
                              selected: active == 1,
                            ),
                            navigationItem(
                              context,
                              index: 2,
                              icon: Icons.list,
                              iconSelected: Icons.list,
                              label: "My Orders",
                              selectedLabel: '"My Orders',
                              selected: active == 2,
                            ),
                            navigationItem(
                              context,
                              index: 3,
                              icon: Icons.more,
                              iconSelected: Icons.more,
                              label: "More",
                              selectedLabel: '"More',
                              selected: active == 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget navigationItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData iconSelected,
    double iconSize = 20,
    required String label,
    bool selected = false,
    String selectedLabel = "",
  }) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () {
            _setActiveTab(index: index);
          },
          splashColor: bgColor,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            runAlignment: WrapAlignment.center,
            children: [
              const SizedBox(height: p2),
              Container(
                decoration: BoxDecoration(
                  color: selected ? Colors.blue.shade50 : null,
                  borderRadius: BorderRadius.circular(p2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: p4,
                  vertical: p2,
                ),
                child: SizedBox(
                  height: iconSize,
                  child: FittedBox(
                    child: Icon(
                      selected ? iconSelected : icon,
                      color: selected ? cPrimary : cText3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: p1),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: selected ? cPrimary : cText3,
                    ),
              ),
              const SizedBox(height: p2),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.onTap,
    required this.selected,
    required this.icon,
    this.tooltip,
  }) : super(key: key);
  final VoidCallback onTap;
  final bool selected;
  final IconData icon;
  final String? tooltip;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      splashColor: cTransparent,
      highlightColor: cTransparent,
      icon: Icon(
        icon,
        size: 18,
        color: selected ? iconSelected : iconUnselected,
      ),
    );
  }
}
