import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Style/theme/colors.dart';
import 'package:helpooappclient/Widgets/primary_button.dart';
import 'package:intl/intl.dart';

import '../Configurations/Constants/api_endpoints.dart';

class CustomFormWidget extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final Locale locale;
  final String? photoUrl;
  CustomFormWidget({
    required this.jsonData,
    required this.locale,
    this.photoUrl,
  });

  @override
  _CustomFormWidgetState createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget> {
  late Map<String, dynamic> formData;
  late Map<String, TextEditingController> controllers;
  final _formKey = GlobalKey<FormState>();
  late final jsonData;
  bool _isValidate = false;
  @override
  void initState() {
    super.initState();
  
    // sort the json data by the order key
    jsonData = Map.fromEntries(
      widget.jsonData.entries.toList()
        ..sort((e1, e2) => e1.value['order'].compareTo(e2.value['order'])),
    );    formData = {};
    controllers = {};
    widget.jsonData.forEach((key, value) {
      controllers[key] = TextEditingController();
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'additional_information'.tr(),
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _isValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imagesBaseUrl + widget.photoUrl!,
                    placeholder: (context, url) => SizedBox(),
                    errorWidget: (context, url, error) => SizedBox(),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: jsonData.length,
                  itemBuilder: (context, index) {
                    String key = jsonData.keys.elementAt(index);
                    Map<String, dynamic> data = jsonData[key];

                    String label = widget.locale.languageCode == 'ar'
                        ? data['ar_name']
                        : data['en_name'];

                    if (data['type'] == 'string' ||
                        data['type'] == 'textarea') {
                      return _buildTextField(
                        label,
                        key,
                        data['type'] == 'textarea',
                        data['required'],
                      );
                    } else if (data['type'] == 'date') {
                      return _buildDateField(
                        label,
                        key,
                        data['required'],
                      );
                    } else {
                      return SizedBox(); // Handle unsupported type or customize as needed
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _collectFormData();
                      Navigator.pop(context, formData);
                    } else {
                      setState(() {
                        _isValidate = true;
                      });
                    }
                  },
                  text: 'confirm'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    String key,
    bool isRequired,
  ) {
    final _dateController = controllers[key];
    final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          _dateController?.text = _dateFormatter.format(pickedDate);
          formData[key] = pickedDate;
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label,
          key,
          false,
          isRequired,
        ),
      ),
    );
  }

  void _collectFormData() {
    controllers.forEach((key, controller) {
      formData[key] = controller.text;
    });
  }

  Widget _buildTextField(
    String label,
    String key,
    bool textArea,
    bool isRequired,
  ) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controllers[key],
          validator: isRequired
              ? (value) {
                  if (value!.isEmpty) {
                    return 'required_field'.tr();
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: ColorsManager.gray40,
            ),
          ),
          maxLines: textArea ? 3 : 1,
        ));
  }
}
