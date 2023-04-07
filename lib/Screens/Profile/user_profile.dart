import 'package:esiway/Screens/Profile/user_car_info.dart';
import 'package:esiway/shared/button.dart';
import 'package:esiway/shared/constant.dart';
import 'package:esiway/shared/title_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../SignIn_Up/widgets/prefixe_icon_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void back() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("Assets/Images/vehicle.jpeg"),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20 , left: 20),
                    width: 80,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PrefixeIconButton(
                            size: const Size(73, 34),
                            color: Colors.white,
                            radius: 8,
                            text: "Back",
                            textcolor: Color(0xFF20236C),
                            weight: FontWeight.w600,
                            fontsize: 14,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF72D2C2),
                              size: 18,
                            ),
                            espaceicontext: 5.0,
                            fct:  back),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.175,
                  ),
                  Container(
                    height: 50,
                    color: Colors.black.withOpacity(0.66),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 25 , vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        Row(
                          children: [
                            Text("Sisaber Rania" , style: TextStyle(color: Colors.white , fontSize: 20 , fontFamily: "Montserrat" , fontWeight: FontWeight.bold),) ,
                            SizedBox(
                              width:10 ,
                            ) ,

                            RatingBarIndicator(
                              rating: 2.5,
                              itemBuilder: (context, index) => Icon(
                                Iconsax.star1,
                                color: orange,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        Text("Student", style: TextStyle(color: Colors.white , fontSize: 12  , fontFamily: "Montserrat" , fontWeight: FontWeight.normal),),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 , horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleTextFeild(title: "Email" ),
                  SizedBox(height: 5,),
                  Text("Email", style:TextStyle(color: bleu_bg , fontSize: 12 , fontWeight: FontWeight.normal , fontFamily: "Montserat"),),
                  SizedBox(height: 20,),
                  TitleTextFeild(title: "Phone" ),
                  SizedBox(height: 5,),
                  Text("Phone", style:TextStyle(color: bleu_bg , fontSize: 12 , fontWeight: FontWeight.normal , fontFamily: "Montserat"),),
                  SizedBox(height: 25,),
                  Container(child: Button(color: orange, title: "title", onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserCarInfo())) ;
                  }), height: 34,width: double.infinity,) ,
                  SizedBox(height: 20,),
                  TitleTextFeild(title: "Review" ),


                ],
              ),
            ) ,


          ],
        ),
      ),
    );
  }
}