import 'dart:io';
import 'dart:typed_data';

import 'package:saiphappfinal/Screens/FirstNotifScreen.dart';
import 'package:saiphappfinal/Screens/SignInScreen.dart';
import 'package:saiphappfinal/resources/auth-methode.dart';
import 'package:saiphappfinal/responsive/mobile_screen_layout.dart';
import 'package:saiphappfinal/responsive/responsive_layout_screen.dart';
import 'package:saiphappfinal/responsive/web_screen_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../utils/utils.dart';


class SignUpScreen extends StatefulWidget {

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}
class _SignUpScreen extends State<SignUpScreen>{
  TextEditingController PseudoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController DatedenaissanceController = TextEditingController();
  TextEditingController TelController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController pharmacieController = TextEditingController();
  TextEditingController ProfessionController = TextEditingController();
  TextEditingController CodeClientController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    ProfessionController.dispose();
    PseudoController.dispose();
    pharmacieController.dispose();
    TelController.dispose();
    CodeClientController.dispose();

  }
  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethodes().SignUPUser(
        email: _emailController.text,
        password: _passwordController.text,
        pseudo: PseudoController.text,
        pharmacy: pharmacieController.text,
        Profession: ProfessionController.text,
        phoneNumber: TelController.text,
        Datedenaissance:DatedenaissanceController.text,
        Verified: '0',
        FullScore: '0',
        PuzzleScore:'0',
        CodeClient: CodeClientController.text,

        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FirstNotifScreen()
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }
  void navigateToHome(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> const SignInScreen(),
      ),
    );
  }
  selectImage() async {
    // Show a dialog to choose between camera and gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List img = await pickImage(ImageSource.camera);
                  if (img != null) {
                    setState(() {
                      _image = img;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List im = await pickImage(ImageSource.gallery);
                  if (im != null) {
                    setState(() {
                      _image = im;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(36 * fem, 37 * fem, 36.83 * fem, 43 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20 * fem),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0.17 * fem, 12 * fem),
                child: Text(
                  'Merci de remplir le formulaire',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
             Stack(children: [
               _image != null
                   ? CircleAvatar(
                 radius: 64,
                 backgroundImage: MemoryImage(_image!),
                 backgroundColor: Colors.red,
               )
                   : const CircleAvatar(
                 radius: 64,
                 backgroundImage: NetworkImage(
                     'https://i.stack.imgur.com/l60Hf.png'),
                 backgroundColor: Colors.red,
               ),

                 Positioned(
                   bottom: -10,
                   left: 60,
                   child: IconButton(

                       onPressed: selectImage,

                     icon: const Icon(
                         Icons.add_a_photo,
                       color:  Color(0xff273085),
                     ),
                   ),
                 ),

               ],
             ),
              Container(
                margin: EdgeInsets.fromLTRB(0.83 * fem, 0 * fem, 0 * fem, 19 * fem),
                child: Text(
                    'Ajouter une photo',
                    style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Color(0xff273085),
                    )
                ),
              ),
              SizedBox(height: 19 * fem),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 97.17 * fem, 4 * fem),
                child: Text(
                  'informations profil',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(

                            controller: PseudoController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Pseudo',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Pseudo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: DatedenaissanceController,
                            keyboardType: TextInputType.datetime,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Date de Naissance',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Date de Naissance';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(

                            controller: TelController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Numero du telephone',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Numero du telephone';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                width: double.infinity,
                height: 54 * fem,
                child:Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Entrez un nouveau mot de passe',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Entrez un nouveau mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 97.17 * fem, 4 * fem),
                child: Text(
                  'informations pharmacie',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: pharmacieController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Nom de la pharmacie',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Nom de la pharmacie';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 19 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: ProfessionController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Ville',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Ville';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(79 * fem, 0 * fem, 78.28 * fem, 0 * fem),
                width: double.infinity,
                height: 54 * fem,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0 * fem, 4 * fem),
                      blurRadius: 2 * fem,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                   signUpUser();


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff273085), // Change to your desired blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50 * fem),
                    ),
                    elevation: 2 * fem,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }

}
