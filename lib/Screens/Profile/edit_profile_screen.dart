import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/button.dart';
import '../../shared/constant.dart';
import '../../shared/text_field.dart';
import '../../shared/text_validation.dart';
import '../../shared/tile_list.dart';
import '../../shared/title_text_field.dart';
import 'profile_screen.dart';

class EditProfileInfo extends StatelessWidget {
  EditProfileInfo({super.key}) {
    _reference = FirebaseFirestore.instance
        .collection('Users')
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
              return EditProfile(
                Name: data["Name"],
                Lastname: data["FamilyName"],
                Gender: data["Gender"],
                Status: data["Status"],
                ImageUrl: data.containsKey("ProfilePicture")
                    ? data["ProfilePicture"]
                    : null,
                Birth: data.containsKey("Birth") ? data["Birth"] : null,
              );
            } catch (e) {
              return EditProfile(
                Name: "Name",
                Lastname: "Family Name",
                Gender: "Male",
                Status: "Student",
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  EditProfile(
      {super.key,
      required this.Name,
      this.Birth,
      required this.Gender,
      required this.Status,
      required this.Lastname,
      this.ImageUrl});

  String Lastname;
  String Name;
  String? Birth;
  String Gender;
  String Status;
  String? ImageUrl;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with UserValidation {
  @override
  int _currentindex = 3;
  int _selectedindex = 3;

  bool namevalidate = true;
  bool lastNamevalidate = true;
  bool emailvalidate = true;
  bool phonevalidate = true;

  bool? gender = false;
  bool? staff = false;
  bool? student = false;
  bool? teacher = false;
  String? imageUrl;
  String? birth;

  String path = "Assets/Images/photo_profile.png";
  @override
  DateTime selectedDate = DateTime.now();

  void initState() {
    super.initState();
    namecontroller.text = widget.Name;
    lastNamecontroller.text = widget.Lastname;
    imageUrl = widget.ImageUrl;
    birth = widget.Birth;
    if (widget.Gender == "Male") gender = true;
    if (widget.Status == "Staff")
      staff = true;
    else if (widget.Status == "Teacher")
      teacher = true;
    else
      student = true;

    if (birth == null)
      birth =
          "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1912),
        lastDate: DateTime(DateTime.now().year - 18));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birth =
            "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
      });
    }
  }

  TextEditingController namecontroller = TextEditingController();
  TextEditingController lastNamecontroller = TextEditingController();

  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker(source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  String workget() {
    if (staff!)
      return "Staff";
    else if (student!)
      return "Student";
    else
      return "Teatcher";
  }

  String genderget() {
    if (gender!)
      return "Male";
    else
      return "Female";
  }

  storeUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Users").doc(uid).update({
      "Name": namecontroller.text,
      "FamilyName": lastNamecontroller.text,
      "Gender": genderget(),
      "Status": workget(),
      "Birth":
          "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
    }).then((value) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return Profile();
          }),
        ));
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
          "Edit my profile",
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
//*****************************************************************************/
              Stack(
                children: [
                  _image != null
                      ? Container(
                          height: 119,
                          width: 119,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 119,
                          width: 119,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              shape: BoxShape.circle,
                              image: imageUrl == null
                                  ? DecorationImage(
                                      image: AssetImage(path),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(imageUrl!),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
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
                                onTap: () =>
                                    _openImagePicker(ImageSource.gallery),
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
                                onTap: () =>
                                    _openImagePicker(ImageSource.camera),
                                leading: Icon(
                                  Icons.camera,
                                  color: vert,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: Container(
                            height: 35,
                            width: 35,
                            child:
                                Center(child: Icon(color: orange, Icons.add)),
                            decoration: BoxDecoration(
                                color: bleu_bg,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
//*****************************************************************************/

              Text_Field(
                  title: "Name",
                  hinttext: "Name",
                  validate: namevalidate,
                  error: "Value can't be Empty / value contains space",
                  suffixicon: Icon(Icons.edit, color: color6),
                  textfieldcontroller: namecontroller),
              SizedBox(
                height: 14.0,
              ),
//*****************************************************************************/

              Text_Field(
                  title: "Family name",
                  hinttext: "Family name",
                  error: "Value can't be Empty / value contains space",
                  validate: lastNamevalidate,
                  suffixicon: Icon(Icons.edit, color: color6),
                  textfieldcontroller: lastNamecontroller),
              SizedBox(
                height: 14.0,
              ),
//*****************************************************************************/
              TitleTextFeild(title: "Gender"),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Listbox(
                      iconleading: Icon(
                        Icons.male_rounded,
                        color: gender == false ? vert : Colors.white,
                      ),
                      title: "Male",
                      color: gender == false || gender == null
                          ? null
                          : const Color(0xFF99CFD7),
                      shadow: gender == false || gender == null
                          ? null
                          : const Color(0xFF99CFD7),
                      onPressed: () {
                        setState(() {
                          gender = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Listbox(
                      iconleading: Icon(
                        Icons.female_rounded,
                        color: gender == true ? vert : Colors.white,
                      ),
                      title: "Female",
                      color: gender == true || gender == null
                          ? null
                          : const Color(0xFF99CFD7),
                      shadow: gender == true || gender == null
                          ? null
                          : const Color(0xFF99CFD7),
                      onPressed: () {
                        setState(() {
                          gender = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
//*****************************************************************************/
              TitleTextFeild(title: "Status "),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Listbox(
                      title: "Teacher",
                      color: teacher == false || teacher == null
                          ? null
                          : const Color(0xFF99CFD7),
                      shadow: teacher == false || teacher == null
                          ? null
                          : const Color(0xFF99CFD7),
                      onPressed: () {
                        setState(() {
                          teacher = true;
                          staff = false;
                          student = false;
                        });
                      },
                      inCenter: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Listbox(
                      title: "Student",
                      color: student == false || student == null
                          ? null
                          : const Color(0xFF99CFD7),
                      shadow: student == false || student == null
                          ? null
                          : const Color(0xFF99CFD7),
                      onPressed: () {
                        setState(() {
                          student = true;
                          staff = false;
                          teacher = false;
                        });
                      },
                      inCenter: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Listbox(
                      title: "Staff",
                      color: staff == false || staff == null
                          ? null
                          : const Color(0xFF99CFD7),
                      shadow: staff == false || staff == null
                          ? null
                          : const Color(0xFF99CFD7),
                      onPressed: () {
                        setState(() {
                          teacher = false;
                          staff = true;
                          student = false;
                        });
                      },
                      inCenter: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
//*****************************************************************************/
              TitleTextFeild(title: "Birth"),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Button(
                    color: color6,
                    title: birth!,
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.edit_calendar),
                  )),

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
                      if (isName(namecontroller.text) == false)
                        setState(() {
                          namevalidate = false;
                        });
                      else {
                        setState(() {
                          namevalidate = true;
                        });
                        print(namecontroller.text);
                      }

                      if (isName(lastNamecontroller.text) == false)
                        setState(() {
                          lastNamevalidate = false;
                        });
                      else {
                        setState(() {
                          lastNamevalidate = true;
                        });
                        print(lastNamecontroller.text);
                      }

                      if (gender == true)
                        print("Male");
                      else if (gender == false) print("Female");

                      if (teacher == true)
                        print("Teacher");
                      else if (staff == true)
                        print("Staff");
                      else if (student == true) print("Student");

                      print(
                          "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}");

                      if (lastNamevalidate && namevalidate) {
                        User? currentuser = FirebaseAuth.instance.currentUser;

                        if (_image != null) {
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child('images');
                          //Create a reference for the image to be stored
                          Reference referenceImageToUpload =
                              referenceDirImages.child(currentuser!.uid);

                          try {
                            //Store the file
                            await referenceImageToUpload
                                .putFile(File(_image!.path));
                            //Success: get the download URL
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentuser.uid)
                                .update({
                              "ProfilePicture": imageUrl,
                            });

                            print(imageUrl);
                          } catch (error) {
                            print(error);
                          }
                        }
                        storeUser();
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
