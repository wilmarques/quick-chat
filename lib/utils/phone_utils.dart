import 'package:phone_form_field/phone_form_field.dart';

import 'package:flutter/widgets.dart';

class PhoneUtils {
  const PhoneUtils();

  IsoCode currentIsoCode() {
    const defaultCountryCode = IsoCode.US;
    // Detect the device IsoCode, based on its locale settings
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final deviceCountryCode = deviceLocale.countryCode;
    // Return the device IsoCode, or the default one (US) if not found
    final identifiedIsoCode = IsoCode.values.firstWhere(
      (isoCode) => isoCode.name == deviceCountryCode,
      orElse: () => defaultCountryCode,
    );
    return identifiedIsoCode;
  }
}
