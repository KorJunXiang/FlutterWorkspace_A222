import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab_assignment_2/appconfig/myconfig.dart';
import 'package:lab_assignment_2/models/user.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _oldpassEditingController =
      TextEditingController();
  final TextEditingController _newpass1EditingController =
      TextEditingController();
  final TextEditingController _newpass2EditingController =
      TextEditingController();
  bool _oldpasswordVisible = true;
  bool _newpasswordVisible = true;
  bool _newpassword2Visible = true;

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _emailEditingController.text = widget.user.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Update Profile",
        style: TextStyle(fontFamily: 'Merriweather'),
      )),
      body: Column(children: [
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                elevation: 10,
                child: Container(
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _selectImageDialog();
                    },
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/profile.png'),
                      image: NetworkImage(
                          "${MyConfig().server}/assets/profile/${widget.user.id}.png"),
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 150),
                      fadeOutDuration: const Duration(milliseconds: 1),
                    ),
                  ),
                ),
              ),
            )),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                        controller: _emailEditingController,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "enter a valid email"
                            : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(fontFamily: 'Merriweather.italic'),
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        validator: (val) => val!.isEmpty ? "Name" : null,
                        onFieldSubmitted: (v) {},
                        controller: _nameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Merriweather.italic',
                            ),
                            icon: Icon(Icons.abc),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _oldpassEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 5)
                            ? "password must be longer than 5"
                            : null,
                        keyboardType: TextInputType.text,
                        obscureText: _oldpasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Enter your old password',
                            labelStyle: const TextStyle(
                              fontFamily: 'Merriweather.italic',
                            ),
                            icon: const Icon(Icons.lock_person_outlined),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _oldpasswordVisible = !_oldpasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _oldpasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                )),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _newpass1EditingController,
                        validator: (val) => val!.isEmpty || (val.length < 5)
                            ? "password must be longer than 5"
                            : null,
                        keyboardType: TextInputType.text,
                        obscureText: _newpasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Enter new password',
                            labelStyle: const TextStyle(
                              fontFamily: 'Merriweather.italic',
                            ),
                            icon: const Icon(Icons.lock_person_rounded),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _newpasswordVisible = !_newpasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _newpasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                )),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _newpass2EditingController,
                        validator: (val) => val!.isEmpty || (val.length < 5)
                            ? "password must be longer than 5"
                            : null,
                        keyboardType: TextInputType.text,
                        obscureText: _newpassword2Visible,
                        decoration: InputDecoration(
                            labelText: 'Re-enter new password',
                            labelStyle: const TextStyle(
                              fontFamily: 'Merriweather.italic',
                            ),
                            icon: const Icon(Icons.lock_person_rounded),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _newpassword2Visible =
                                        !_newpassword2Visible;
                                  });
                                },
                                icon: Icon(
                                  _newpassword2Visible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                )),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            updateDialog();
                          },
                          child: const Text("Update Profile")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void updateDialog() {
    if (_oldpassEditingController.text.isNotEmpty) {
      if (_oldpassEditingController.text != widget.user.password) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Your old password is wrong. Please try again"),
          duration: Duration(seconds: 2),
        ));
        return;
      }

      String passa = _newpass1EditingController.text;
      String passb = _newpass2EditingController.text;

      if (passa.isEmpty || passb.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Enter your new password'),
            duration: Duration(seconds: 2)));
        return;
      }

      if (passa != passb) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('New password entered are different. Please try again'),
            duration: Duration(seconds: 2)));
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your profile?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProfile();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  Future<void> _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage();
      setState(() {});
    }
  }

  void _updateProfileImage() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "No image available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }

    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse("${MyConfig().server}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "image": base64Image
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Images Update Success"),
            duration: Duration(seconds: 2),
          ));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("ImagesUpdate Failed"),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Images Update Failed"),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  void updateProfile() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String password = _newpass1EditingController.text;

    Map<String, String> updateData = {
      "userid": widget.user.id.toString(),
    };

    if (name.isNotEmpty) {
      updateData["name"] = name;
    }

    if (email.isNotEmpty) {
      updateData["email"] = email;
    }

    if (password.isNotEmpty) {
      updateData["password"] = password;
    }

    http
        .post(Uri.parse("${MyConfig().server}/php/update_profile.php"),
            body: updateData)
        .then((response) {
      // print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            duration: Duration(seconds: 2),
          ));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed"),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Update Failed"),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }
}
