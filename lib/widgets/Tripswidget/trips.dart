import 'package:esiway/widgets/Tripswidget/tripsCards.dart';
import 'package:flutter/material.dart';

class Trip {
  final String departure;
  final String arrival;
  final String date;
  final String uid;
  String price;
  String preferences;
  List<dynamic>? passager;

  Trip(
      {required this.departure,
      required this.passager,
      required this.price,
      required this.preferences,
      required this.arrival,
      required this.date,
      required this.uid});
}

class MyTripsCard extends StatelessWidget {
  final List<Trip> trips;
  final bool reserved;

  MyTripsCard({required this.trips, required this.reserved});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      if (reserved) {
        return DefaultCard(
          defaultText:
              'We apologize, but there are currently no trips reserved under your account. Please book a new trip.  ',
          buttonText: 'Search',
        );
      } else {
        return DefaultCard(
          defaultText:
              'We apologize, but there are currently no trips suggested under your account. Please create a new trip.  ',
          buttonText: 'Create',
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trips
            .map((trip) => AllMyTrips(
                  price: trip.price,
                  preferences: trip.preferences,
                  passager: trip.passager,
                  departure: trip.departure,
                  arrival: trip.arrival,
                  date: trip.date,
                  uid: trip.uid,
                  text: 'you have reserved this trip',
                  buttonText: 'View Trip',
                  press: () {},
                ))
            .toList(),
      ),
    );
  }
}
