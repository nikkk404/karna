import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../widgets/authbutton_widget_view.dart';
import '../widgets/input_with_icon.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key, this.data}) : super(key: key);
  final DocumentSnapshot<Map?>? data;

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  double windowWidth = 0;
  double windowHeight = 0;

  CollectionReference contactUs =
      FirebaseFirestore.instance.collection("Contact-Us");
  @override
  void dispose() {
    nameController.dispose();
    messageController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.data!.data()!.containsKey('name')
            ? widget.data!['name']
            : null);
    emailController = TextEditingController(
        text: widget.data!.data()!.containsKey('email')
            ? widget.data!['email']
            : null);
  }

  void addContactUs() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      contactUs.doc(widget.data!['email']).set({
        "name": nameController.text.trim(),
        "email": widget.data!.data()!.containsKey('email')
            ? widget.data!['email']
            : "",
        "message": messageController.text.trim(),
      }).then((value) async {
        Fluttertoast.showToast(msg: 'Message Sent');
        setState((() {
          nameController.clear();
          messageController.clear();
          emailController.clear();
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          title: const Text(
            "Contact Us",
            style: TextStyle(color: white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        backgroundColor: white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: const Text(
                            'Contact Us ',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      obscure: false,
                      btnIcon: Icons.account_circle_rounded,
                      hintText: nameHintText,
                      myController: nameController,
                      keyboardType: TextInputType.name,
                      validateFunc: (val) {
                        if (val!.isEmpty) {
                          return nameEmptyWarning;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.email,
                      hintText: 'Email',
                      myController: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.message,
                      hintText: 'Enter your message',
                      myController: messageController,
                      keyboardType: TextInputType.text,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Message is required";
                        }
                        return null;
                      },
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthButtonWidget(
                      btnTxt: 'Send Message',
                      onPress: () {
                        addContactUs();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
