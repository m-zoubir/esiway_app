import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/constant.dart';
import '../../widgets/text_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex = 0;
  int _selectedindex = 0;

  late double rating;

  String user_picture = "Assets/Images/photo_profile.png";
  @override
  void initState() {
    super.initState();
  }

  TextEditingController feedbackcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        unselectedIconTheme: const IconThemeData(color: bleu_bg),
        selectedIconTheme: const IconThemeData(color: vert),
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.user,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedindex = index;
          });
          if (_selectedindex != _currentindex)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return tab[_selectedindex];
              }),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Rate tour trip",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                            child: Image.asset(user_picture),
                            radius: 59,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "User Name",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RatingBar.builder(
                            initialRating: 2.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Iconsax.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              this.rating = rating;
                              print(rating);
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text_Field(
                            title: "Feedback",
                            hinttext: "Write your comment here  ",
                            validate: true,
                            textfieldcontroller: feedbackcontroller,
                            suffixicon: const Icon(
                              Icons.send,
                              color: vert,
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.lightBlueAccent,
        ),
      ),

      /// page containing the floating button
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60.0, left: 30.0, bottom: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Text('Modal bottom sheet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
