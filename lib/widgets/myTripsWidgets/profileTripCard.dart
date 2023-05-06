import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileTripCard extends StatelessWidget {
  final String name;
  final String staff;
  final double rating;
  final String profileImage;
  final Color color;

  const ProfileTripCard({
    Key? key,
    required this.name,
    required this.staff,
    required this.rating,
    required this.profileImage,
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
        CircleAvatar(
          backgroundImage: AssetImage('Assets/Images/${profileImage}.jpg'),
          radius: 30.0,
        ),
        SizedBox(
          width: screenWidth * 0.02,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$name\n",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              TextSpan(
                text: '$staff',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: screenWidth * 0.26),
        RatingBar.builder(
          initialRating: rating,
          ignoreGestures: true,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 12.0,
          unratedColor: orange.withOpacity(0.25),
          itemBuilder: (context, _) => SvgPicture.asset(
            'Assets/Icons/starFilled.svg',
            width: 8,
            height: 8,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
      ],
    );
  }
}
