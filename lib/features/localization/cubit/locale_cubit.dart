import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const _languageKey = 'languageCode';

  LocaleCubit() : super(const LocaleInitial(Locale('vi'))) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      emit(LocaleChanged(Locale(languageCode)));
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    emit(LocaleChanged(locale));
  }
}
