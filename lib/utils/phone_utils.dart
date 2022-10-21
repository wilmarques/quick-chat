import 'package:dart_countries/dart_countries.dart';
import 'dart:ui' as ui;

class PhoneUtils {
  const PhoneUtils();

  IsoCode currentIsoCode() {
    const defaultCountryCode = 'US';
    final detectedCountryCode = ui.window.locale.countryCode;
    return IsoCode.values
        .byName(detectedCountryCode ?? defaultCountryCode);
  }
}
