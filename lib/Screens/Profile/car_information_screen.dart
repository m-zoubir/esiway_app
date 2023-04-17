import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/button.dart';
import '../../shared/constant.dart';
import '../../shared/text_field.dart';
import '../../shared/text_validation.dart';
import '../../shared/title_text_field.dart';
import 'profile_screen.dart';

class CarInfo extends StatelessWidget {
  CarInfo({super.key}) {
    _reference = FirebaseFirestore.instance
        .collection('Cars')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;

  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
  late Future<DocumentSnapshot> _futureData;
  late Map data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            try {
              data = documentSnapshot.data() as Map;
              //display the data
              return CarInformation(
                Brand: data["brand"],
                Model: data["model"],
                Registrationnumber: data["registrationNumber"],
                CarURL: data["CarPicture"],
                PolicyURL: data["Policy"],
              );
            } catch (e) {
              return CarInformation();
            }
          }

          return Column();
        },
      ),
    );
  }
}

class CarInformation extends StatefulWidget {
  CarInformation(
      {super.key,
      this.Brand,
      this.CarURL,
      this.Model,
      this.PolicyURL,
      this.Registrationnumber});

  String? Brand;
  String? Model;
  String? Registrationnumber;
  String? CarURL;
  String? PolicyURL;

  @override
  State<CarInformation> createState() => _CarInformationState();
}

class _CarInformationState extends State<CarInformation> with UserValidation {
  int _currentindex = 3;
  int _selectedindex = 3;

  bool modelvalidate = true;
  bool brandvalidate = true;
  bool registrationnumbervalidate = true;

  File? policy;
  File? carpicture;

  String? policyURL;
  String? carpictureURL;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker(String type, source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        if (type == "policy")
          policy = File(pickedImage.path);
        else
          carpicture = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.Model == null
        ? modelcontroller.text = "206"
        : modelcontroller.text = widget.Model!;
    widget.Brand == null
        ? brandcontroller.text = "Peugeot"
        : brandcontroller.text = widget.Brand!;
    widget.Registrationnumber == null
        ? registrationNumbercontroller.text = "12014-112-31"
        : registrationNumbercontroller.text = widget.Registrationnumber!;

    carpictureURL = widget.CarURL;
    policyURL = widget.PolicyURL;
  }

  TextEditingController modelcontroller = TextEditingController();
  TextEditingController brandcontroller = TextEditingController();
  TextEditingController registrationNumbercontroller = TextEditingController();

  updateCar() async {
    if (widget.Brand != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("Cars").doc(uid).update({
        "brand": brandcontroller.text,
        "model": modelcontroller.text,
        "registrationNumber": registrationNumbercontroller.text,
      }).then((value) =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Profile();
          })));
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("Cars").doc(uid).set({
        "brand": brandcontroller.text,
        "model": modelcontroller.text,
        "registrationNumber": registrationNumbercontroller.text,
      }).then((value) =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Profile();
          })));
    }
  }

  bool carPicrtureExist() {
    return (carpicture != null || carpictureURL != null);
  }

  bool policyExist() {
    return (policy != null || policyURL != null);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        unselectedIconTheme: IconThemeData(color: bleu_bg),
        selectedIconTheme: IconThemeData(color: vert),
        items: [
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return tab[_selectedindex];
            }),
          );
        },
      ),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Iconsax.back_square,
            color: vert,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Profile();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "Car information",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.info_circle,
              color: orange,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//*****************************************************************************/
              SizedBox(
                height: 20.0,
              ),
              TitleTextFeild(title: "Car's picture"),
              SizedBox(
                height: 10.0,
              ),
              carpicture == null && carpictureURL == null
                  ? SizedBox(
                      height: 2,
                    )
                  : Container(
                      height: 200,
                      width: 310,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      child: carpicture != null
                          ? Image.file(
                              carpicture!,
                            )
                          : Image.network(carpictureURL!),
                    ),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: Text("choose your source"),
                      children: [
                        ListTile(
                          title: Text(
                            "Import a picture",
                            style: TextStyle(
                                color: bleu_bg,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserrat"),
                          ),
                          onTap: () => _openImagePicker(
                              "carpicture", ImageSource.gallery),
                          leading: Icon(
                            Icons.upload,
                            color: vert,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Take a picture",
                            style: TextStyle(
                                color: bleu_bg,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserrat"),
                          ),
                          onTap: () => _openImagePicker(
                              "carpicture", ImageSource.camera),
                          leading: Icon(
                            Icons.camera,
                            color: vert,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  "Add a picture",
                  style: TextStyle(
                      fontSize: 10,
                      color: bleu_bg,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
//*****************************************************************************/

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: Text_Field(
                      title: "Brand",
                      validate: brandvalidate,
                      error: "Value can't be Empty",
                      hinttext: 'Peugeot',
                      prefixicon: Icon(
                        Iconsax.car,
                        color: vert,
                      ),
                      textfieldcontroller: brandcontroller,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: Text_Field(
                      title: "Model",
                      validate: modelvalidate,
                      error: "Value can't be Empty",
                      hinttext: '206',
                      prefixicon: Icon(
                        Iconsax.car,
                        color: vert,
                      ),
                      textfieldcontroller: modelcontroller,
                    ),
                  )
                ],
              ),

//*****************************************************************************/

              Text_Field(
                title: "Registration Number",
                validate: registrationnumbervalidate,
                error: "Value can't be Empty",
                type: TextInputType.number,
                hinttext: '00984-118-16',
                prefixicon: Icon(
                  Iconsax.car,
                  color: vert,
                ),
                textfieldcontroller: registrationNumbercontroller,
              ),

//*****************************************************************************/

              TitleTextFeild(title: "Insurance policy"),
              SizedBox(
                height: 10.0,
              ),

              policy != null || policyURL != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: policyURL == null
                              ? Image.file(
                                  //to show image, you type like this.
                                  File(policy!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                )
                              : Image.network(
                                  policyURL!,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                )),
                    )
                  : SizedBox(
                      height: 2,
                    ),
              SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(color6),
                      ),
                      onPressed: () =>
                          _openImagePicker("policy", ImageSource.gallery),
                      icon: Icon(
                        Iconsax.document_upload,
                        color: bleu_bg,
                      ),
                      label: Text(
                        "Upload",
                        style: TextStyle(
                          color: bleu_bg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
//*****************************************************************************/

              SizedBox(
                height: 17.0,
              ),
              Container(
                height: 47,
                width: double.infinity,
                child: Button(
                    color: orange,
                    title: "Save",
                    onPressed: () async {
                      if (isCar(brandcontroller.text) == false)
                        setState(() {
                          brandvalidate = false;
                        });
                      else {
                        setState(() {
                          brandvalidate = true;
                        });
                        print(brandcontroller.text);
                      }
                      if (isCar(modelcontroller.text) == false)
                        setState(() {
                          modelvalidate = false;
                        });
                      else {
                        setState(() {
                          modelvalidate = true;
                        });
                        print(modelcontroller.text);
                      }

                      if (isRegistrationNumber(
                              registrationNumbercontroller.text) ==
                          false)
                        setState(() {
                          registrationnumbervalidate = false;
                        });
                      else {
                        setState(() {
                          registrationnumbervalidate = true;
                        });
                        print(registrationNumbercontroller.text);
                        User? currentuser = FirebaseAuth.instance.currentUser;

                        if (registrationnumbervalidate &&
                            modelvalidate &&
                            brandvalidate &&
                            carPicrtureExist() &&
                            policyExist()) {
                          if (carpicture != null) {
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('Cars');
                            //Create a reference for the image to be stored
                            Reference referenceImageToUpload =
                                referenceDirImages.child(currentuser!.uid);

                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(carpicture!.path));
                              //Success: get the download URL

                              carpictureURL =
                                  await referenceImageToUpload.getDownloadURL();

                              print(carpictureURL);
                              await FirebaseFirestore.instance
                                  .collection("Cars")
                                  .doc(currentuser.uid)
                                  .update({
                                "CarPicture": carpictureURL,
                              });
                            } catch (error) {
                              print(error);
                            }
                          }
                          if (policy != null) {
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('Policy');
                            //Create a reference for the image to be stored
                            Reference referenceImageToUpload =
                                referenceDirImages.child(currentuser!.uid);

                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(policy!.path));
                              //Success: get the download URL

                              policyURL =
                                  await referenceImageToUpload.getDownloadURL();
                              await FirebaseFirestore.instance
                                  .collection("Cars")
                                  .doc(currentuser.uid)
                                  .update({
                                "Policy": policyURL,
                              });
                            } catch (error) {
                              print(error);
                            }
                          }

                          updateCar();
                        } else if (!carPicrtureExist() || !policyExist()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.white,
                              duration: Duration(
                                seconds: 3,
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              padding: EdgeInsets.all(12),
                              behavior: SnackBarBehavior.floating,
                              elevation: 2,
                              content: Center(
                                child: Text(
                                  "Car picture and Insurance policy picture are obligatory",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              )));
                        }
                      }
                    }),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
