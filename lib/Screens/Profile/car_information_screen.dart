import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/button.dart';
import '../../shared/constant.dart';
import '../../shared/text_field.dart';
import '../../shared/text_validation.dart';
import '../../shared/title_text_field.dart';
import 'profile_screen.dart';

class CarInformation extends StatefulWidget {
  const CarInformation({super.key});

  @override
  State<CarInformation> createState() => _CarInformationState();
}

class _CarInformationState extends State<CarInformation> with UserValidation {
  @override
  int _currentindex = 3;
  int _selectedindex = 3;

  bool modelvalidate = true;
  bool brandvalidate = true;
  bool registrationnumbervalidate = true;

  File? policy;
  File? carpicture;

  File? _image;
  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePickerGallery(String type) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (type == "policy")
          policy = File(pickedImage.path);
        else
          carpicture = File(pickedImage.path);
      });
    }
  }

  // Implementing the image picker
  Future<void> _openImagePickerCamera(String type) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
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
    modelcontroller.text = "206";
    brandcontroller.text = "Peugeot";
    registrationNumbercontroller.text = "12014-112-31";
  }

  TextEditingController modelcontroller = TextEditingController();
  TextEditingController brandcontroller = TextEditingController();
  TextEditingController registrationNumbercontroller = TextEditingController();

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
              carpicture == null
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
                      child: Image.file(
                        carpicture!,
                      ),
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
                          onTap: () => _openImagePickerGallery("carpicture"),
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
                          onTap: () => _openImagePickerCamera("carpicture"),
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

              policy != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image, you type like this.
                          File(policy!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
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
                      onPressed: () => _openImagePickerGallery("policy"),
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
                    onPressed: () {
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
