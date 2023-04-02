import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserInfo {
  String _uid = "";
  String _email = "";
  String _phone = "";
  String _password = "";
  String _name = "";
  String _lastname = "";
  String _birth = "";
  String _gender = "";
  String _work = "";
  Image _image = Image.asset("Assets/Images/photo_profile.png");
  String _imageURL = "";

  UserInfo(){}

  void setImage() {
    if (_imageURL.isNotEmpty) {
      _image = Image.network("${_imageURL}");
    } else {
      _image = Image.asset("Assets/Images/photo_profile.png");
    }
  }

  String getName() => _name;
  String getLastName() => _lastname;
  String getEmail() => _email;
  String getPhone() => _phone;
  String getPassword() => _password;
  String getBirth() => _birth;
  String getGender() => _gender;
  String getWork() => _work;
  String getProfileImage() => _imageURL;
  String getUid() => _uid;

  void setName(String value) {
    this._name = value;
  }

  void setLastName(String value) {
    this._lastname = value;
  }

  void setBirth(String value) {
    this._birth = value;
  }

  void setEmail(String value) {
    this._email = value;
  }

  void setPassword(String value) {
    this._password = value;
  }

  void setWork(String value) {
    this._work = value;
  }

  void setGender(String value) {
    this._gender = value;
  }

  void setPhone(String value) {
    this._phone = value;
  }

  void setUid(String value) {
    this._uid = value;
  }

  void srtImageUrl(String value) {
    this._imageURL = value;
  }

  storeUser() {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("Users").doc(_uid).set({
      "name": _name,
      "lastname": _lastname,
      "gender": _gender,
      "work": _work,
      "birth": _birth,
      "profileimage": _imageURL
    });
  }
}
