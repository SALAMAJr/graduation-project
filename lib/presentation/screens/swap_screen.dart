import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/swapDetailsScreen.dart';

class SwapScreen extends StatelessWidget {
  const SwapScreen({super.key});

  Widget buildSwapItemCard(BuildContext context) {
    return Container(
      width: 358,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SwapDetailsScreen()));
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.brown.withOpacity(0.1),
          highlightColor: Colors.brown.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/Avatar.png"),
                      radius: 23,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emma Wilson",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4A3F35)),
                        ),
                        Text(
                          "Posted 2 hours ago",
                          style:
                              TextStyle(color: Color(0xff6B7280), fontSize: 11),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 192,
                      width: 326,
                      child: Image(
                        image: AssetImage(
                            "assets/images/Vintage_Leather_Armchair.png"),
                        fit: BoxFit.cover,
                      ),
                    )),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Vintage Leather Armchair",
                    style: TextStyle(
                      color: Color(0xff2C1810),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Excellent condition, genuine leather. Minor wear on armrests. Perfect for reading corner.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      elevation: 0,
                      backgroundColor: Color(0xffF8F5F1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        MyFlutterApp.sync_icon,
                        color: Colors.black,
                        size: 15,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          "Looking for: Modern sofa set or equivalent",
                          style:
                              TextStyle(color: Color(0xff4A3F35), fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (context, index) {
              return buildSwapItemCard(context);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 15);
            },
          ),
        ),
      ),
    );
  }
}
