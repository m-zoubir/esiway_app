import 'package:esiway/Screens/Home/home_page.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';

class RefuseB extends StatelessWidget {
  final String user_name;
  //final String path;

  const RefuseB({
    required this.user_name, // required this.path
  });

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: largeur * 0.925,
          height: hauteur * 0.0975,
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
          margin: EdgeInsets.fromLTRB(12, 14, 12, 20),
          child: Row(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(13, 16, 5, 16),
              child: CircleAvatar(
                //   backgroundImage: AssetImage(path),
                radius: largeur * 0.06,
              ),
            ),
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
                      color: bleu_bg,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    "has refused your ride request",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: bleu_bg.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 0, 12, 0),
                    padding: EdgeInsets.zero,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: bleu_bg,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: orange, // Background color
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







/* import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AcceptB extends StatelessWidget {
  const AcceptB({Key? key}) : super(key: key);

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
        Container(
          width: largeur * 0.925,
          height: hauteur * 0.0975,
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
                        color: bleu_bg,
                        fontFamily: 'Montserrat'),
                  ),
                  Text(
                    accepted,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: bleu_bg.withOpacity(0.8),
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
                    padding: EdgeInsets.zero,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        more,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: bleu_bg,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: orange, // Background color
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
 */