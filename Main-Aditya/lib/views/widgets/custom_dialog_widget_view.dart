import 'package:cygiene_ui/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatefulWidget {
  final void Function()? onYesPressed;
  final String? title;
  final String? subtitle;
  final Icon? icon;

  const CustomConfirmDialog(
      {super.key, this.title, this.subtitle, this.icon, this.onYesPressed});

  @override
  _CustomConfirmDialogState createState() => _CustomConfirmDialogState();
}

class _CustomConfirmDialogState extends State<CustomConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: 230,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              children: [
                Text(
                  widget.title ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.subtitle ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onYesPressed,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(primaryColor),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(primaryColor),
                      ),
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -60,
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 60,
            child: widget.icon,
          ),
        ),
      ],
    );
  }
}
