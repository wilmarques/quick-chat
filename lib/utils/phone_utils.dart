import 'package:phone_form_field/phone_form_field.dart';

import 'package:flutter/widgets.dart';

class PhoneUtils {
  const PhoneUtils();

  IsoCode currentIsoCode() {
    const defaultCountryCode = 'US';
    final detectedCountryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    return IsoCode.values.byName(detectedCountryCode ?? defaultCountryCode);
  }
}
