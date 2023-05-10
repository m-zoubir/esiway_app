import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileTripCard extends StatelessWidget {
  final String name;
  final String staff;
  final double rating;
  final String? profileImage;
  final Color color;

  ProfileTripCard({
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
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0,
                color: bleu_bg,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidth * 0.4,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$name\n",
                      style: TextStyle(
                        fontSize: "$name".length < 20 ? 16 : 14,
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
            ),
            RatingBarIndicator(
              rating: rating,
              itemCount: 5,
              itemSize: 12.0,
              unratedColor: orange.withOpacity(0.25),
              itemBuilder: (context, _) => SvgPicture.asset(
                'Assets/Icons/starFilled.svg',
                width: 8,
                height: 8,
              ),
            ),
          ],
        )
      ],
    );
  }
}
