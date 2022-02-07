import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/handlers.dart';
import 'package:perfectBeta/model/users/data/email_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmChangeEmail extends StatefulWidget {
  const ConfirmChangeEmail({Key key, this.email}) : super(key: key);
  final EmailDTO email;

  @override
  _ConfirmChangeEmail createState() => _ConfirmChangeEmail();
}

class _ConfirmChangeEmail extends State<ConfirmChangeEmail> {
  final _confirmChangeEmailFormKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _confirmChangeEmailFormKey,
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.asset("assets/icons/logo.png"),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text("Change Email", style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: [
                        CustomText(
                          text: "Paste code from sent to your old email address into box below to confirm change email.",
                          overflow: TextOverflow.visible,
                          color: lightGrey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      String pattern = r'^[a-zA-Z0-9]+$';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Please enter code';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please valid code';
                      }
                      return null;
                    },
                    controller: _codeController,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Code", hintText: "Enter your code", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_confirmChangeEmailFormKey.currentState.validate()) {
                        await handleConfirmChangeEmail(context, _codeController.text, widget.email.email);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Change email",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
