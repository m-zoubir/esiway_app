import 'package:esiway/SignIn_Up/widgets/prefixe_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'signup_page.dart';
import 'widgets/login_text.dart';
import 'widgets/simple_button.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage({Key? key}) : super(key: key);
  bool yban = true;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  void signup() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
  void test(){}


  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    double x = 00;
    TextEditingController pincontroller = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage( image: AssetImage("lib/images/verfication.png"), fit: BoxFit.cover,)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: x, left: 0, right: 0, bottom: 0,
              child: SizedBox(
                height: hauteur,

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: hauteur*0.05),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PrefixeIconButton(size: const Size(73, 34), color: Colors.white, radius: 10, text: "Back", textcolor: const Color(0xFF20236C), weight: FontWeight.w600, fontsize: 14, icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Color(0xFF72D2C2),size: 18,),espaceicontext: 0.0, fct: signup),
                          ],
                        ),
                      ),
                      SizedBox(height: hauteur*0.15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: largeur*0.075),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            MyText(largeur: largeur*0.8, text: "OTP Verfication", weight: FontWeight.w700, fontsize: 50, color: const Color(0xff20236C)),

                            SizedBox(height: hauteur*0.03),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Column(
                                  children: [
                                    const Image(image: AssetImage("lib/images/verfication_password.png")),
                                    const Text(
                                      "Enter the OTP sent to your email",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF20236C),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    SizedBox(height: hauteur*0.02,),
                                    SizedBox(
                                      width: largeur*0.6,
                                      child: PinCodeTextField(
                                        appContext: context,
                                        boxShadows: const [ BoxShadow(blurRadius: 20, color: Color.fromRGBO(32, 35, 108, 0.2))],
                                        length: 4,
                                        controller: pincontroller,
                                        cursorHeight: 20,
                                        cursorColor: Colors.black,
                                        enableActiveFill: true,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(4),
                                          fieldWidth: 50,
                                          inactiveColor: Colors.white,
                                          activeColor: Colors.grey.shade50,
                                          selectedColor: Colors.grey.shade200,
                                          activeFillColor: Colors.grey.shade50,
                                          selectedFillColor: Colors.grey.shade100,
                                          inactiveFillColor: Colors.white,
                                          borderWidth: 1,
                                        ),
                                        onChanged:((value){}),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Didn’t recieve the verification OTP?",
                                          style: TextStyle(fontSize: 10, color: Color(0xFF20236C), fontWeight: FontWeight.w500, fontFamily: 'Montserrat'),
                                        ),
                                        TextButton(
                                            onPressed: (){},
                                            child: const Text(
                                              "Resend again",
                                              style: TextStyle(fontSize: 10, color: Color(0xFF20236C), fontWeight: FontWeight.w700, decoration: TextDecoration.underline, fontFamily: 'Montserrat',),
                                            ),
                                        )
                                      ],
                                    )
                                  ],
                                ),

                              ],
                            ),

                            SizedBox(height: hauteur*0.05,),

                            SimpleButton(
                              backgroundcolor: const Color(0xFFFFA18E), size: Size(largeur, hauteur * 0.06), radius: 10,
                              text: 'Verify',
                              textcolor: const Color(0xff20236C), weight: FontWeight.w700, fontsize: 20, fct: test,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
