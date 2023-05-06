import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RefuseB extends StatelessWidget {
  const RefuseB({Key? key}) : super(key: key);
  static const bleu = Color(0xff20236C);
  static const blanc = Color(0xffF9F8FF);
  static const vert = Color(0xffAED6DC);
  static const rose = Color(0xffFFA18E);
  final String user_name = 'Yasmine Zaidi';
  final String path = "Assets/Images/slider1.png";
  final String request = 'requested to go with youuuu';
  final String refuse = 'Refuse';
  final String refused = 'has refused your ride request ';
  final String accepted = 'has accepted your ride request ';
  final String more = 'See more';
  final String search = 'Search';

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Container(
        //     child: Text(
        //       'Notifcations',
        //       style: TextStyle(
        //           fontSize: 24,
        //           fontWeight: FontWeight.bold,
        //           color: bleu,
        //           fontFamily: 'mont'),
        //     ),
        //     margin: EdgeInsets.fromLTRB(23, 85, 0, 0)),
        // Container(
        //   child: Text(
        //     'Today',
        //     style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //         color: bleu,
        //         fontFamily: 'mont'),
        //   ),
        //   padding: EdgeInsets.fromLTRB(23, 12, 0, 0),
        // ),
        Container(
          width: largeur * 0.925,
          height: hauteur * 0.0975,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: bleu.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          margin: EdgeInsets.fromLTRB(12, 14, 12, 20),
          child: Row(children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(13, 16, 5, 16),
                child: CircleAvatar(
                  backgroundImage: AssetImage(path),
                  radius: largeur * 0.06,
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user_name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: bleu,
                        fontFamily: 'Montserrat'),
                  ),
                  Text(
                    refused,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: bleu.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 0, 12, 0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        search,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: bleu,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: rose, // Background color
                        minimumSize: Size(66, 28),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ],
    )
        ////add here an element for list view
        );
  }
}
