import 'package:flutter/material.dart';

class DiyScreen extends StatelessWidget {
  const DiyScreen({super.key});

  Widget buildDIYItemCard() {
    return Container(
      width: 358,
      height: 370,
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
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.brown.withOpacity(0.1),
          highlightColor: Colors.brown.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                  child: SizedBox(
                    height: 192,
                    width: 358,
                    child: Image(
                      image:
                          AssetImage("assets/images/Old_Chair_Bookshelf.png"),
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Turn an Old Chair into a Bookshelf",
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
                        "Repurpose an old chair into functional storage with this creative upcycling guide.",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            minimumSize: Size(double.infinity, 38),
                            backgroundColor: Color(0xff694A38),
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "View Guide",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ],
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
              return buildDIYItemCard();
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
