import 'package:esiway/widgets/myTripsWidgets/tripsCards.dart';
import 'package:flutter/material.dart';

class ReservedTrip {
  final String departure;
  final String arrival;
  final String date;

  ReservedTrip({
    required this.departure,
    required this.arrival,
    required this.date,
  });
}

class MyTripsReservedCard extends StatelessWidget {
  final List<ReservedTrip> trips;

  MyTripsReservedCard({required this.trips});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return DefaultCard(
        defaultText:
            'We apologize, but there are currently no trips reserved under your account. Please book a new trip.  ',
        buttonText: 'Search',
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trips
            .map((trip) => MyTripsReserved(
                  departure: trip.departure,
                  arrival: trip.arrival,
                  date: trip.date,
                  text: 'you have reserved this trip',
                  buttonText: 'View Trip',
                  press: () {},
                ))
            .toList(),
      ),
    );
  }
}
