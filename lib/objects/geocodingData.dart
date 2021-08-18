class GeoCodingData {
  final PlusCode plusCode;

  GeoCodingData(this.plusCode);
}

class PlusCode {
  final String compound_code;
  final String global_code;

  PlusCode(this.compound_code, this.global_code);
}
