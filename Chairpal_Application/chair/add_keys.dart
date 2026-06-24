import 'dart:convert';
import 'dart:io';

void main() {
  final directory = Directory('lib/l10n');
  final files = directory.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();

  final Map<String, Map<String, String>> newTranslations = {
    'en': {
      'noNotificationsTitle': 'No Notifications Yet'
    },
    'ar': {
      'noNotificationsTitle': 'لا توجد إشعارات بعد'
    },
    'de': {
      'noNotificationsTitle': 'Noch Keine Benachrichtigungen'
    },
    'fr': {
      'noNotificationsTitle': 'Aucune Notification Pour Le Moment'
    },
    'hi': {
      'noNotificationsTitle': 'अभी तक कोई सूचना नहीं'
    },
    'ko': {
      'noNotificationsTitle': '아직 알림이 없습니다'
    },
    'vi': {
      'noNotificationsTitle': 'Chưa Có Thông Báo Nào'
    }
  };

  for (final file in files) {
    final languageCode = file.path.split('_').last.split('.').first;
    if (!newTranslations.containsKey(languageCode)) continue;

    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;

    final newEntries = newTranslations[languageCode]!;
    for (final key in newEntries.keys) {
      if (!json.containsKey(key)) {
        json[key] = newEntries[key];
      } else {
        json[key] = newEntries[key]; // Overwrite if exists to update casing if we want
      }
    }

    final encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(json));
    print('Updated ${file.path}');
  }
}
