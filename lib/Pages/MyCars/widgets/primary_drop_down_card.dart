import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Style/theme/colors.dart';
import 'package:searchfield/searchfield.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/spacing.dart';

class PrimaryDropDown extends StatefulWidget {
  const PrimaryDropDown(
      {Key? key,
      required this.title,
      this.hint = '',
      this.validatorText,
      required this.globalKey,
      this.isEnabled = false,
      this.isLoading = false,
      this.isFromChars = false,
      this.containerColor,
      required this.items,
      this.onSelect,
      required this.controller})
      : super(key: key);
  final String title;
  final String hint;
  final String? validatorText;
  final GlobalKey globalKey;
  final bool isEnabled;
  final bool isLoading;
  final bool isFromChars;
  final Color? containerColor;
  final List<String> items;
  final Function(String?)? onSelect;
  final TextEditingController? controller;

  @override
  State<PrimaryDropDown> createState() => _PrimaryDropDownState();
}

class _PrimaryDropDownState extends State<PrimaryDropDown> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.isFromChars) {
      widget.controller?.addListener(() {
        if (widget.items.contains(widget.controller?.value.text)) {
        } else {
          widget.controller?.clear();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SearchField<String>(
        maxSuggestionsInViewPort: 5,
        validator: (p0) {
          if (widget.items.contains(p0)) {
            return null;
          } else {
            setState(() {
              widget.controller?.clear();
            });
          }
        },
        searchInputDecoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          border: InputBorder.none,
        ),
        scrollbarDecoration: ScrollbarDecoration(
            trackColor: Colors.white,
            fadeDuration: Duration.zero,
            pressDuration: Duration.zero,
            trackBorderColor: Colors.white,
            thumbColor: Colors.black,
            thickness: 5,
            minThumbLength: 40),
        controller: widget.controller,
        enabled: widget.isEnabled,
        hint: widget.hint,
        key: widget.globalKey,
        onSubmit: (p0) {
          if (widget.onSelect != null) {
            widget.onSelect!(p0);
          }
        },
        onSuggestionTap: (p0) {
          if (widget.onSelect != null) {
            widget.onSelect!(p0.item);
          }
        },
        onSaved: (p0) {
          if (widget.onSelect != null) {
            widget.onSelect!(p0);
          }
        },
        suggestions: widget.items
            .map(
              (e) => SearchFieldListItem<String>(
                e,
                child: Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryGreen,
                      //    borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                        child: Text(
                      e,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
                item: e,
                // Use child to show Custom Widgets in the suggestions
                // defaults to Text widget
              ),
            )
            .toList(),
      ),
    ); /* TypeAheadField<String?>(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        enabled: !widget.isDisabled,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hint,
        ),
      ),
      suggestionsCallback: (pattern) {
        // print(pattern);
        return widget.items
            .where((val) => val.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return widget.isDisabled
            ? Container()
            : ListTile(
                title: Text(suggestion ?? ''),
              );
      },
      noItemsFoundBuilder: (context) => ListTile(
        title: Text('no items'.tr()),
      ),
      onSuggestionSelected: (suggestion) {
        // Handle when a suggestion is selected.
        print('Selected text from drop down: $suggestion');

        if (widget.onSelect != null) {
          widget.controller?.value = TextEditingValue(text: suggestion ?? '');
          widget.onSelect!(suggestion);
          setState(() {

          });
        }

        //  return suggestion;
      },
    );*/
  }
}
