import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/models/report_problem.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/utils/validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../constants.dart';

class ReportProblem extends StatefulWidget {
  static const String route = '/reportProblem';

  const ReportProblem({Key? key}) : super(key: key);

  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _sending = false;
  File? _image;

  /// Profile image
  final ImagePicker _picker = ImagePicker();

  @override
  initState() {
    super.initState();
  }

  Future takePhoto(ImageSource source) async {
    await _picker
        .pickImage(
      source: source,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    )
        .then((value) async {
      if (value!.path == "" || value.name == "") {
        return false;
      }

      setState(() {
        _image = File(value.path);
      });
    });
  }

  _submit() async {
    /// Check connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastNetwork,
        timeInSecForIosWeb: 2,
      );
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int? id = preferences.getInt('id')!;
    setState(() {
      _sending = true;
    });
    ReportProblemDetails reportProblemDetails = ReportProblemDetails(
      id: id.toString(),
      title: _controllerTitle.text,
      description: _controllerDescription.text,
      image: _image!,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage = await AuthenticationProvider()
        .problemReport(reportProblemDetails: reportProblemDetails);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    if (responseMessage.error == false) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Report sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastSuccess,
        timeInSecForIosWeb: 2,
      );
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }
    setState(() {
      _sending = false;
    });
  }

  @override
  dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Report problem", style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white), // ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: pagePadding,
            vertical: pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: p2,
                    ),
                    TextFormField(
                      controller: _controllerTitle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      validator: (title) =>
                          Validators.validateInputWithCustomErrorMessage(
                              title!, "This field is required"),
                      decoration: InputDecoration(
                        hintText: "Add problem title",
                      ),
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: p2,
                    ),
                    Scrollbar(
                      child: TextFormField(
                        controller: _controllerDescription,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        validator: (description) =>
                            Validators.validateInputWithCustomErrorMessage(
                                description!, "This field is required"),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Problem description",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    Text(
                      "Image",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: p1,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            takePhoto(ImageSource.gallery);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(p2),
                            child: Text("Attach image"),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _image == null || _image!.path == ""
                                ? "No image selected"
                                : _image!.path,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    materialButton.createButton(
                      function: () {
                        if (_image == null || _image!.path == "") return;
                        if (_formKey.currentState!.validate()) {
                          _submit();
                        }
                      },
                      label: 'Send report',
                      loadingLabel: "Sending report ...",
                      loading: _sending,
                    )
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
