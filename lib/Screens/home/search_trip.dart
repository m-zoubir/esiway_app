import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/text_field.dart';
import '../../widgets/title_text_field.dart';

class SearchTrip extends StatefulWidget {
  const SearchTrip({super.key});

  @override
  State<SearchTrip> createState() => _SearchTripState();
}

class _SearchTripState extends State<SearchTrip> {
  @override
  void initState() {
    super.initState();
    date = "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
    minute = TimeNow.minute >= 10 ? "${TimeNow.minute}" : "0${TimeNow.minute}";
    hour = TimeNow.hour >= 10 ? "${TimeNow.hour}" : "0${TimeNow.hour}";
    time = hour! + " : " + minute!;
  }

  int _currentindex = 0;
  int _selectedindex = 0;

  late double rating;

  TextEditingController depart = TextEditingController();
  TextEditingController arrivee = TextEditingController();

  bool departvalidate = true;
  bool arriveevalidate = true;

  DateTime selectedDate = DateTime.now();
  String? date;
  TimeOfDay TimeNow =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  String? time;
  String? minute;
  String? hour;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialTime: TimeNow,
      context: context,
    );
    if (picked != null) {
      setState(() {
        TimeNow = picked;
        minute =
            TimeNow.minute >= 10 ? "${TimeNow.minute}" : "0${TimeNow.minute}";
        hour = TimeNow.hour >= 10 ? "${TimeNow.hour}" : "0${TimeNow.hour}";
        time = hour! + " : " + minute!;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        date =
            "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        unselectedIconTheme: const IconThemeData(color: bleu_bg),
        selectedIconTheme: const IconThemeData(color: vert),
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.user,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedindex = index;
          });
          if (_selectedindex != _currentindex)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return tab[_selectedindex];
              }),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        children: [
                          Text_Field(
                            title: "Departure",
                            validate: departvalidate,
                            error: "Value can't be Empty",
                            hinttext: 'Enter your  address of departure ',
                            prefixicon: Icon(
                              Iconsax.home_2,
                              color: vert,
                            ),
                            textfieldcontroller: depart,
                          ),
                          Text_Field(
                            title: "Arrival",
                            validate: arriveevalidate,
                            error: "Value can't be Empty",
                            hinttext: 'Enter your  address of  arrival ',
                            prefixicon: Icon(
                              Iconsax.home_2,
                              color: vert,
                            ),
                            textfieldcontroller: arrivee,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                // optional flex property if flex is 1 because the default flex is 1
                                flex: 3,
                                child: Column(
                                  children: [
                                    TitleTextFeild(title: "Date"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(5),
                                      shadowColor:
                                          Color.fromRGBO(32, 35, 108, 0.15),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          height: 47,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      32, 35, 108, 0.15),
                                                  spreadRadius: 2,
                                                  blurRadius: 18,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: GestureDetector(
                                            onTap: () => _selectDate(context),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_calendar,
                                                  color: vert,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    date!,
                                                    style: const TextStyle(
                                                      color: bleu_bg,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                // optional flex property if flex is 1 because the default flex is 1
                                flex: 2,
                                child: Column(
                                  children: [
                                    TitleTextFeild(title: "Time"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(5),
                                      shadowColor:
                                          Color.fromRGBO(32, 35, 108, 0.15),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          height: 47,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      32, 35, 108, 0.15),
                                                  spreadRadius: 2,
                                                  blurRadius: 18,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: GestureDetector(
                                            onTap: () => _selectTime(context),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                Icon(
                                                  Iconsax.clock,
                                                  color: vert,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    time!,
                                                    style: const TextStyle(
                                                      color: bleu_bg,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28.0,
                          ),
                          Container(
                            height: 47,
                            width: double.infinity,
                            child: Button(
                                color: orange,
                                title: "Search",
                                onPressed: () async {}),
                          ),
//*****************************************************************************/
                        ],
                      ),
                    ),
                  ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.lightBlueAccent,
        ),
      ),

      /// page containing the floating button
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60.0, left: 30.0, bottom: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Text('Modal bottom sheet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
