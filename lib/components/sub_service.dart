import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

class SubService extends StatelessWidget {
  final String emoji;
  final Color color;
  final String subServiceName;
  const SubService({
    Key? key,required this.emoji, required this.color,required this.subServiceName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              Row(
                children: [
                  Container(
                    child: Text('$emoji'),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                  ),
                  SizedBox(
                    width: p2,
                  ),
                  Text(
                    '$subServiceName',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: p1,)
      ],
    );
  }
}
