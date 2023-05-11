import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class Comment {
  final String text;
  final String name;
  final String? photoProfile;
  final String timestamp;
  Comment(
      {required this.text,
      required this.name,
      required this.timestamp,
      required this.photoProfile});
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0,
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
                image: comment.photoProfile == null
                    ? DecorationImage(
                        image: AssetImage("Assets/Images/photo_profile.png"),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: NetworkImage(comment.photoProfile!),
                        fit: BoxFit.cover,
                      )),
          ),
          SizedBox(
            width: screenWidth * 0.01,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.009),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7 - 70,
                      child: AutoSizeText(
                        '${comment.name}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: bleu_bg,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: AutoSizeText(
                        '${comment.timestamp}',
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: bleu_bg,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.72,
                child: AutoSizeText(
                  '${comment.text}',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: bleu_bg,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<Comment>? comments;
  CommentsList({required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments != null) {
      return ListView.builder(
          itemCount: comments!.length,
          itemBuilder: (BuildContext context, int index) {
            return CommentCard(comment: (comments![index]));
          });
    }
    return Container();
  }
}
