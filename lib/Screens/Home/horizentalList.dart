import 'package:auto_size_text/auto_size_text.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:esiway/widgets/simple_button.dart';
import 'package:esiway/widgets/trip_resume.dart';
import 'package:flutter/material.dart';

import 'user.dart';
class ListOfTrips extends StatefulWidget {
  final List<String> names;

  ListOfTrips({required this.names});

  @override
  State<ListOfTrips> createState() => _ListOfTripsState();
}

class _ListOfTripsState extends State<ListOfTrips> {
  @override

  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return PageView.builder(
      itemCount: widget.names.length,

      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0x30AED6DC),),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                /// pdp name statu row
                Row(
                  children: [
                    const CircleAvatar(backgroundImage: AssetImage("Assets/Images/logo_background.png"), radius: 40,),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        const SizedBox(child:  AutoSizeText("YASMINE Zaidi", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: bleu_bg,),),),
                        SizedBox(
                          width: largeur*0.14,
                          child:  const AutoSizeText("Status", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 12, color: bleu_bg,),),
                        ),
                      ],
                    ),
                  ],
                ),
                ///BOX TRIP
                Row(
                  children: [
                    SizedBox(width: largeur*0.2),
                    const InfoTripBox(
                      arrival: 'OUED SEMAR',
                      departure: 'EL HARRACH',
                    ),
                  ],
                ),
                SizedBox(height: hauteur*0.03),
                /// Row DATE TIME SEATS CAR
                Row(
                  children: [

                    SizedBox(
                      width: largeur*0.18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          AutoSizeText("Date", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 12, color: bleu_bg,),),
                          AutoSizeText("2023/08/08", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10, color: bleu_bg,),)
                        ],
                      ),
                    ),
                    SizedBox(width: largeur*0.1),
                    SizedBox(
                      width: largeur*0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          AutoSizeText("Time", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 12, color: bleu_bg,),),
                          AutoSizeText("21:18", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10, color: bleu_bg,),)
                        ],
                      ),
                    ),
                    SizedBox(width: largeur*0.1),


                    SizedBox(
                      width: largeur*0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          AutoSizeText("Seats", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 12, color: bleu_bg,),),
                          AutoSizeText("4", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10, color: bleu_bg,),)
                        ],
                      ),
                    ),
                    SizedBox(width: largeur*0.1),

                    SizedBox(
                      width: largeur*0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          AutoSizeText("Car", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 12, color: bleu_bg,),),
                          AutoSizeText("Megane", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10, color: bleu_bg,),)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(  height: hauteur*0.02),
                ///Preferences
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: largeur*0.21 ,
                            child: const AutoSizeText("Preferences", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: bleu_bg,),)
                        ),
                        SizedBox(  height: hauteur*0.005),
                        const AutoSizeText("Talking,Bgs,Smoking,Animals,other", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10, color: bleu_bg,),)
                      ],
                    )
                  ],
                ),
                SizedBox(  height: hauteur*0.02),
                /// Price
                Container(
                   height: hauteur*0.03,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0x77FFA18E),),
                  child: Row(
                    children: [
                      SizedBox(width: largeur*0.01),
                      const AutoSizeText("Price", style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 10, color: bleu_bg,),)
                    ],
                  ),
                ),
                SizedBox(  height: hauteur*0.01),
                /// Request & message Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleButton(backgroundcolor: orange, size: Size(largeur*0.67,hauteur*0.07), radius: 15, text: widget.names[index], textcolor: bleu_bg, fontsize: 16, fct: (){}),
                    ElevatedButton(
                      onPressed: () {/*    Navigator.push(context,MaterialPageRoute(builder: (context) => Notifpage())); */},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          elevation: 0.0,
                          fixedSize:
                          Size(largeur * 0.07, hauteur * 0.07),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                      ),
                      child: const Icons_ESIWay(
                          icon: "messages",
                          largeur: 100,
                          hauteur: 100),
                    ),
                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
