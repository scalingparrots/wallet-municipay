import 'package:flutter/material.dart';

Widget menuCard(
  context, {
  @required String title,
  @required IconData icon,
  @required Function onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 6,
              child: Card(
                child: Icon(
                  icon,
                  size: MediaQuery.of(context).size.height / 8,
                  color: Colors.purple[400],
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.purple[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
