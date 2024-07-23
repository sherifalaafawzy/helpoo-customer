import 'package:flutter/material.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteSearchApp extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
             /* TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search country...',
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return countries
                      .where((country) => country.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // Handle when a suggestion is selected.
                  _controller.text = suggestion;
                  print('Selected country: $suggestion');
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}