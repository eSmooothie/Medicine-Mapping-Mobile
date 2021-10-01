import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  static final Widget streetView = SvgPicture.asset(
    'assets/icons/street-view-solid.svg',
    semanticsLabel: 'Street View',
  );

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

  static final Widget getDirection = SvgPicture.asset(
    'assets/icons/get_direction.svg',
    semanticsLabel: "Get Direction",
  );

  static final Widget userProfileHolder = SvgPicture.asset(
    'assets/icons/user-profile-holder.svg',
    semanticsLabel: "User profile holder",
  );
}
