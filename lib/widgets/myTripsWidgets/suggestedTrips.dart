import 'package:esiway/widgets/myTripsWidgets/tripsCards.dart';
import 'package:flutter/material.dart';

class SuggestedTrip {
  final String departure;
  final String arrival;
  final String date;

  SuggestedTrip({
    required this.departure,
    required this.arrival,
    required this.date,
  });
}

class MyTripsSuggeestedCard extends StatelessWidget {
  final List<SuggestedTrip> trips;

  const MyTripsSuggeestedCard({
    super.key,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return DefaultCard(
        defaultText:
            'We apologize, but there are currently no trips suggested under your account. Please create a new trip.  ',
        buttonText: 'Create',
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trips
            .map((trip) => MyTripsSuggested(
                  departure: trip.departure,
                  arrival: trip.arrival,
                  date: trip.date,
                  text: 'you have suggested this trip',
                  buttonText: 'View Trip',
                  press: () {},
                ))
            .toList(),
      ),
    );
  }
}
