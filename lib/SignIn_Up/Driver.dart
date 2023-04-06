// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_element
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/SignIn_Up/widgets/MyAppBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';




import 'CreateProfile.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    final firestoreInstance = FirebaseFirestore.instance;
    final _BrandController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isButtonEnabled = false;
    final _ModeleController = TextEditingController();
    final _RNController = TextEditingController();
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc('user123');
    @override
    void dispose() {
      _BrandController.dispose();
      _ModeleController.dispose();
      _RNController.dispose();
      super.dispose();
    }

    //text controllers
    String? _validator(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    void _updateButtonState() {
      setState(() {
        _isButtonEnabled = _BrandController.text.isNotEmpty &&
            _ModeleController.text.isNotEmpty &&
            _RNController.text.isNotEmpty;
      });
    }

    @override
    void initState() {
      super.initState();
      _BrandController.addListener(_updateButtonState);
      _ModeleController.addListener(_updateButtonState);
      _RNController.addListener(_updateButtonState);
    }

    void _Save(String Brand, String Modele, String RN) async {
      await FirebaseFirestore.instance.collection('douaa').add({
        'Brand': Brand,
        'Modele': Modele,
        'REFISTRATION_NB': RN,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _BrandController.clear();
      _ModeleController.clear();
      _RNController.clear();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      appBar: MyAppBar(
        context: context,
        backgroundImage: 'assets/background5.svg',
        onBackButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProfile(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // child: Padding(
          //  padding: const EdgeInsets.only(top: 9),
          child: Column(
            children: [
              const Text(
                'Car \ninformation ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFF20236C),
                ),
              ),
              SizedBox(height: height * 0.024),
              Row(
                children: [
                  const LabelText(
                    text: 'Brand',
                    color: Color(0xFF20236C),
                    paddingValue: 0.08,
                  ),
                  SizedBox(width: width * 0.038),
                  const LabelText(
                    text: 'Modele',
                    color: Color(0xFF20236C),
                    paddingValue: 0.30,
                  ),
                ],
              ),
              SizedBox(height: height * 0.012),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    hintText: 'TOYOTA', //optional
                    labelText: "Enter your car'/s brand ",
                    prefixIcon: const Icon(Icons.directions_car),
                    hintTextColor: Colors.grey,
                    labelTextColor: Colors.grey,
                    iconColor: const Color(0xFF72D2C2),
                    width: width * 0.402,
                    validator: _validator,
                    controller: _BrandController,
                  ),
                  SizedBox(width: width * 0.028),
                  CustomTextField(
                    hintText: 'Yaris', //optional
                    labelText: "Enter your car'/s model ",
                    prefixIcon: const Icon(Icons.directions_car),
                    hintTextColor: Colors.grey,
                    labelTextColor: Colors.grey,
                    iconColor: const Color(0xFF72D2C2),
                    width: width * 0.402,
                    validator: _validator,
                    controller: _ModeleController,
                  ),
                ],
              ),
              SizedBox(height: height * 0.028),
              const LabelText(
                text: 'Registration Number',
                color: Color(0xFF20236C),
                paddingValue: 0.088,
              ),
              SizedBox(height: height * 0.012),
              CustomTextField(
                // hintText: 'Esi', //optional
                labelText: "Enter your  car's registration",
                prefixIcon: const Icon(Icons.house_rounded),
                hintTextColor: Colors.grey,
                labelTextColor: Colors.grey,
                iconColor: const Color(0xFF72D2C2),
                width: width * 0.83,
                keyboardType: TextInputType.number,
                validator: _validator,
                controller: _RNController,
              ),
              SizedBox(height: height * 0.028),
              Row(
                children: [
                  const LabelText(
                    text: 'Brand',
                    color: Color(0xFF20236C),
                    paddingValue: 0.08,
                  ),
                  SizedBox(width: width * 0.038),
                  const LabelText(
                    text: 'Modele',
                    color: Color(0xFF20236C),
                    paddingValue: 0.30,
                  ),
                ],
              ),
              SizedBox(height: height * 0.012),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //the upload icon
                  //Padding(
                  //padding: EdgeInsets.only(left: width * 0.08),
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 35.0,
                      width: width * 0.402,
                      padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF99CFD7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icons_ESIWay(
                              icon: "upload", largeur: 20, hauteur: 20),
                          SizedBox(width: 5),
                          Text(
                            "Upload",
                            style: TextStyle(
                              color: Color(0xFF20236C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // positioned properties
                  // use Positioned widget if you need absolute positioning
                  // margin: EdgeInsets.only(left: 31, top: 503),
                  //),
                  SizedBox(width: width * 0.038),
                  // the second button
                  //Padding(
                  //padding: EdgeInsets.only(right: width * 0.08),
                  InkWell(
                    onTap: () {
                      _openCamera();
                    },
                    child: Container(
                      height: 35.0,
                      width: width * 0.402,
                      padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF99CFD7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icons_ESIWay(
                              icon: "camera", largeur: 20, hauteur: 20),
                          SizedBox(width: 5),
                          Text(
                            "Take",
                            style: TextStyle(
                              color: Color(0xFF20236C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.021),
              const LabelText(
                text: 'Insurance policy ',
                color: Color(0xFF20236C),
                paddingValue: 0.08,
              ),
              SizedBox(height: height * 0.012),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 35.0,
                  width: width * 0.84,
                  padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF99CFD7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icons_ESIWay(icon: "upload", largeur: 20, hauteur: 20),
                      SizedBox(width: 5),
                      Text(
                        "Upload",
                        style: TextStyle(
                          color: Color(0xFF20236C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //next buttom
              SizedBox(height: height * 0.038),
              SizedBox(
                width: width * 0.84,
                height: 50.0,
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _Save(_BrandController.text, _ModeleController.text,
                          _RNController.text);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => CreateProfile(),
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.84,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA18E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Next',
                          style: TextStyle(
                            color: Color(0xff20236C),
                            fontFamily: 'Montserrat',
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.027,
                        ),
                        // ignore: prefer_const_constructors

                        Icons_ESIWay(
                            icon: "arrow_right", largeur: 20, hauteur: 20),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.010),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.30,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Not ready Now?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Montserrat-Medium',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Color(0xFF20236C),
                      ),
                    ),
                    SizedBox(width: width * 0.012),
                    InkWell(
                      onTap: () {
                        // Navigate to Profile page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateProfile())); //just pour le test
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF20236C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//(WORK IN PROGRESS)
// ignore: duplicate_ignore
Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  // Do something with the picked image file
}

//(WORK IN PROGRESS)
Future<void> _openCamera() async {
  // ignore: deprecated_member_use
  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
}
*/