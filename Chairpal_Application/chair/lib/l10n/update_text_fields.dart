import 'dart:convert';
import 'dart:io';

void main() {
  final Map<String, Map<String, String>> translations = {
    'en': {
      'noCommentsYet': 'No comments yet.',
    },
    'ar': {
      'noCommentsYet': 'لا يوجد تعليقات بعد.',
    },
    'fr': {
      'noCommentsYet': 'Aucun commentaire pour le moment.',
    },
    'de': {
      'noCommentsYet': 'Noch keine Kommentare.',
    },
    'hi': {
      'noCommentsYet': 'अभी तक कोई टिप्पणी नहीं।',
    },
    'ko': {
      'noCommentsYet': '아직 댓글이 없습니다.',
    },
    'vi': {
      'noCommentsYet': 'Chưa có bình luận nào.',
    },
  };

  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (final file in files) {
    final langMatch = RegExp(r'intl_(\w+)\.arb').firstMatch(file.path);
    if (langMatch != null) {
      final lang = langMatch.group(1)!;
      final content = file.readAsStringSync();
      final Map<String, dynamic> json = jsonDecode(content);
      
      final trans = translations[lang] ?? translations['en']!;
      json['noCommentsYet'] = trans['noCommentsYet'];

      file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(json));
      print('Updated ${file.path}');
    }
  }
}
