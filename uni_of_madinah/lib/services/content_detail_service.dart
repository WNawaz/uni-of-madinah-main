import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';

class ContentDetailService {
  IslamicContent? content;
  LanguageMode selectedLanguage = LanguageMode.english;

  IslamicContent? get islamicContent => content;
  void init(IslamicContent content) {
    this.content = content;
  }

  void updateLanguage(LanguageMode language) {
    selectedLanguage = language;
  }

  void updateselectLanguage(LanguageMode language) {
    selectedLanguage = language;
  }
}
