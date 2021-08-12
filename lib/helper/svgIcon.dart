import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  static final Widget searchPharmacy = SvgPicture.asset(
    'assets/icons/search_pharmacy.svg',
    semanticsLabel: 'Search Pharmacy',
  );
  static final Widget searchDrug = SvgPicture.asset(
    'assets/icons/search_drug.svg',
    semanticsLabel: 'Search Drug',
  );
  static final Widget filterDrugs = SvgPicture.asset(
    'assets/icons/filter_drugs.svg',
    semanticsLabel: 'Filter drugs',
  );
  static final Widget capsulesSolid = SvgPicture.asset(
    'assets/icons/capsules-solid.svg',
    semanticsLabel: 'Capsule',
  );
  static final Widget pharmacy = SvgPicture.asset(
    'assets/icons/pharmacy.svg',
    semanticsLabel: 'Pharmacy',
    color: Colors.blue,
  );
}
