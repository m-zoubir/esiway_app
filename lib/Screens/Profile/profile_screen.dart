import 'package:esiway/SignIn_Up/login_page.dart';
import 'package:esiway/shared/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../shared/constant.dart';
import '../../shared/text_validation.dart';
import '../../shared/tile_list.dart';
import '../home/rating.dart';
import 'car_information_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'verification_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with UserValidation {
  @override
  int _currentindex = 3;
  int _selectedindex = 3;

  String user_name = "ZAIDI Yasmine";
  String user_picture = "Assets/Images/vehicle.jpeg";
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        unselectedIconTheme: IconThemeData(color: bleu_bg),
        selectedIconTheme: IconThemeData(color: vert),
        items: [
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
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: 8),
          child: Center(
            child: Image.asset(LOGO),
          ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.info_circle,
              color: orange,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 77,
                width: 77,
                child: CircleAvatar(
                  backgroundImage: AssetImage(user_picture),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                child: Text(
                  user_name,
                  style: TextStyle(
                    color: bleu_bg,
                    fontFamily: "Montserrat",
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) => Icon(
                  Iconsax.star1,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 25.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(
                height: 21.0,
              ),
              Listbox(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditProfileInfo();
                      },
                    ),
                  );
                },
                title: "My informations",
                iconleading: const Icon(
                  Iconsax.user,
                  color: vert,
                ),
              ),
              Listbox(
                onPressed: () {},
                subtitle: "{Home , work , ...}",
                title: "My adresses",
                iconleading: const Icon(
                  Iconsax.home_2,
                  color: vert,
                ),
              ),
              Listbox(
                onPressed: () {},
                title: "History",
                iconleading: const Icon(
                  Icons.history,
                  color: vert,
                ),
              ),
              Listbox(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CarInformation();
                      },
                    ),
                  );
                },
                title: "My car",
                iconleading: const Icon(
                  Iconsax.car,
                  color: vert,
                ),
              ),
              Listbox(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Verification();
                      },
                    ),
                  );
                },
                subtitle: "(Email,phone number)",
                title: "Verify my account",
                iconleading: const Icon(
                  Iconsax.verify5,
                  color: vert,
                ),
              ),
              Listbox(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Settings();
                      },
                    ),
                  );
                },
                title: "Settings",
                iconleading: const Icon(
                  Icons.settings,
                  color: vert,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Button(
                  color: orange,
                  title: "Log out",
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((value) => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return LogInPage();
                              }),
                            ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
