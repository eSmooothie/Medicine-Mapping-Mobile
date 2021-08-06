import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  static final Widget search_pharmacy = SvgPicture.asset(
    'assets/icons/search_pharmacy.svg',
    semanticsLabel: 'Search Pharmacy',
  );
  static final Widget search_drug = SvgPicture.asset(
    'assets/icons/search_drug.svg',
    semanticsLabel: 'Search Drug',
  );
  static final Widget filter_drugs = SvgPicture.asset(
    'assets/icons/filter_drugs.svg',
    semanticsLabel: 'Filter drugs',
  );
  static final Widget capsules_solid = SvgPicture.asset(
    'assets/icons/capsules-solid.svg',
    semanticsLabel: 'Capsule',
  );
  static final Widget pharmacy = SvgPicture.asset(
    'assets/icons/pharmacy.svg',
    semanticsLabel: 'Pharmacy',
    color: Colors.blue,
  );
}
