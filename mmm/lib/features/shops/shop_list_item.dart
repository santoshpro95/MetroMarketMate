import 'package:flutter/material.dart';
import 'package:mmm/model/get_shops_response.dart';

// region shopListItem
Widget shopListItem(Result shop) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          width: double.maxFinite,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Image border
            child: SizedBox.fromSize(
                child: Image.network(
              'https://swarajya.gumlet.io/swarajya/2019-05/6985b1de-36c1-4839-8091-01f3db8d63c9/3983494030_77afbe2c3a_z.jpg',
              fit: BoxFit.cover,
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("${shop.name}", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
// endregion
