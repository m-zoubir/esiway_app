import 'package:carousel_slider/carousel_slider.dart';
import 'package:esiway/Screens/SignIn_Up/signup_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/constant.dart';
import '../../widgets/simple_button.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  List imageList = [
    {"id": 1, "image_path": "Assets/Images/slider1.png"},
    {"id": 2, "image_path": "Assets/Images/slider2.png"},
    {"id": 3, "image_path": "Assets/Images/slider3.png"},
    {"id": 4, "image_path": "Assets/Images/slider4.png"},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void signup() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }

    void login() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LogInPage()));
    }

    final largeur = MediaQuery.of(context).size.width;
    final hauteur = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Assets/Images/Register.png'),
                fit: BoxFit.fill),
          ),
          child: Scaffold(
            backgroundColor: color3,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: CarouselSlider(
                            items: imageList
                                .map((item) => Image.asset(item['image_path']))
                                .toList(),
                            carouselController: carouselController,
                            options: CarouselOptions(
                              scrollPhysics: const BouncingScrollPhysics(),
                              autoPlay: true,
                              // aspectRatio: 1,
                              height: hauteur * 0.37,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.011 * hauteur,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 22 : 7,
                                height: 7.0,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentIndex == entry.key
                                        ? const Color(0xFF20236C)
                                        : const Color(0xFFDFE1E2)),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: hauteur * 0.07,
                ),
                Column(
                  children: [
                    SimpleButton(
                        backgroundcolor: const Color(0xFFFFA18E),
                        size: Size(largeur * 0.77777777777, hauteur * 0.073),
                        radius: 15,
                        text: 'Sign Up',
                        textcolor: const Color(0xFF20236C),
                        weight: FontWeight.w700,
                        fontsize: 18,
                        fct: signup),
                    SimpleButton(
                        backgroundcolor: const Color(0x00F9F8FF),
                        size: Size(largeur * 0.77777777777, hauteur * 0.073),
                        radius: 15,
                        text: 'Log In',
                        textcolor: const Color(0xFF20236C),
                        weight: FontWeight.w700,
                        fontsize: 18,
                        fct: login),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
