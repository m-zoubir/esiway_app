import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TripInfoResume extends StatelessWidget {
  TripInfoResume({
    super.key,
    this.profile_picture,
    required this.arrival,
    required this.departure,
    required this.color,
    required this.date,
    required this.name,
    required this.price,
    required this.familyName,
    required this.time,
  });
  String price;
  String time;
  String date;
  String departure;
  String arrival;
  String name;
  String familyName;
  Color color;
  String? profile_picture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 120,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ProfileTripCard(
                  familyName: familyName,
                  name: name,
                  profileImage: profile_picture,
                  color: bleu_bg,
                ),
              ),
              Expanded(
                flex: 4,
                child: InfoTripBox(
                  departure: departure,
                  arrival: arrival,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRichText(
                  title: "date",
                  value: date,
                  titlesize: 12,
                  valuesize: 10,
                ),
                CustomRichText(
                  title: "time",
                  value: time,
                  titlesize: 12,
                  valuesize: 10,
                ),
                CustomRichText(
                  title: "price",
                  value: price,
                  titlesize: 12,
                  valuesize: 10,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTripCard extends StatelessWidget {
  String name;
  String familyName;
  String? profileImage;
  Color color;

  ProfileTripCard({
    Key? key,
    required this.name,
    required this.familyName,
    this.profileImage,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              shape: BoxShape.circle,
              image: profileImage == null
                  ? DecorationImage(
                      image: AssetImage("Assets/Images/photo_profile.png"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(profileImage!),
                      fit: BoxFit.cover,
                    )),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        ),
        CustomRichText(
          title: familyName,
          value: name,
          titlesize: 16,
          valuesize: 14,
        )
      ],
    );
  }
}

class InfoTripBox extends StatelessWidget {
  final String departure, arrival;
  const InfoTripBox({
    super.key,
    required this.departure,
    required this.arrival,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'Assets/Icons/tripshape.svg',
          semanticsLabel: 'My SVG Image',
          width: 2, // Set the size of the SVG image
          height: 42,
        ),
        SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$departure",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              SizedBox(
                height: 17,
              ),
              Text(
                '$arrival',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
