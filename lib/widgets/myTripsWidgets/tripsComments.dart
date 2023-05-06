import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class Comment {
  final String text;
  final String name;
  final String photoProfile;
  final DateTime timestamp;
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
          CircleAvatar(
            backgroundImage:
                AssetImage('Assets/Images/${comment.photoProfile}.jpg'),
            radius: 25.0,
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
                  children: [
                    SizedBox(
                      width: screenWidth * 0.3,
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
                      width: screenWidth * 0.4,
                      child: AutoSizeText(
                        '${comment.timestamp.toString()}',
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
  final List<Comment> comments;
  CommentsList({required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int index) {
          return CommentCard(comment: (comments[index]));
        });
  }
}