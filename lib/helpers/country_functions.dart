import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfectBeta/model/country/countryDTO.dart';

Future<List<CountryDTO>> getCountries(String jsonFile) async {
  final String response =
  await rootBundle.loadString(jsonFile);
  final parsed = await jsonDecode(response).cast<Map<String, dynamic>>();

  return parsed.map<CountryDTO>((json) => CountryDTO.fromJson(json)).toList();
}

Future<List<DropdownMenuItem<String>>> putCountries() async {
  List<DropdownMenuItem<String>> countryItems = [];

  List<CountryDTO> countries = await getCountries('assets/country_data.json');

  countries.forEach((country) {
    countryItems.add(DropdownMenuItem(
        child: Text("${country.name}", overflow: TextOverflow.ellipsis,), value: '${country.code}'));
  });

  return countryItems;
}