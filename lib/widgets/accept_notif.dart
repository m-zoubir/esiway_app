import 'package:auto_size_text/auto_size_text.dart';
import 'package:esiway/Screens/Trips/mytrips.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/simple_button.dart';
import 'package:flutter/material.dart';

class AcceptB extends StatelessWidget {
  final String user_name;
  final String? path;

  const AcceptB({required this.user_name, required this.path});

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Container(
      height: 82,
      margin: EdgeInsets.only(bottom: 14, left: 5, right: 5, top: 5),
      padding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: bleu_bg.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(children: <Widget>[
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
              image: path == null
                  ? DecorationImage(
                      image: AssetImage("Assets/Images/photo_profile.png"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(path!),
                      fit: BoxFit.cover,
                    )),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: largeur * 0.45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user_name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: bleu_bg,
                  fontFamily: 'Montserrat',
                ),
                overflow: TextOverflow.fade,
              ),
              Text(
                "has accepted your ride request",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: bleu_bg.withOpacity(0.8),
                  fontFamily: 'Montserrat',
                ),
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
        Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
            BoxShadow(
              color: bleu_bg.withOpacity(0.2),
            ),
          ]),
          width: 75,
          height: 30,
          child: SimpleButton(
              backgroundcolor: orange,
              size: Size(75, 30),
              radius: 5,
              text: "More",
              textcolor: bleu_bg,
              fontsize: 13,
              fct: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyTrips()));
              }),
        )
      ]),
    );
  }
}
