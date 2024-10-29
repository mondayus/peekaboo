import 'package:peekaboo/common/data/preference/item/nullable_preference_item.dart';
import 'package:peekaboo/common/theme/custom_theme.dart';

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
}
