import 'dart:convert';
import 'dart:io';

void main() async {
  final directory = Directory('.');
  final files = directory.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();

  final Map<String, Map<String, String>> translations = {
    'en': {
      'sosButtonPressed': 'SOS button pressed',
      'daysAgo2_1132am': '2 days ago, 11:32 AM',
      'low': 'Low',
      'lastVisited': 'Last Visited',
      'unknownDistance': 'Unknown'
    },
    'ar': {
      'sosButtonPressed': 'تم الضغط على زر SOS',
      'daysAgo2_1132am': 'منذ يومين، 11:32 صباحاً',
      'low': 'منخفض',
      'lastVisited': 'آخر زيارة',
      'unknownDistance': 'غير معروف'
    },
    'de': {
      'sosButtonPressed': 'SOS-Taste gedrückt',
      'daysAgo2_1132am': 'vor 2 Tagen, 11:32 Uhr',
      'low': 'Niedrig',
      'lastVisited': 'Zuletzt besucht',
      'unknownDistance': 'Unbekannt'
    },
    'fr': {
      'sosButtonPressed': 'Bouton SOS pressé',
      'daysAgo2_1132am': 'il y a 2 jours, 11h32',
      'low': 'Faible',
      'lastVisited': 'Dernière visite',
      'unknownDistance': 'Inconnu'
    },
    'hi': {
      'sosButtonPressed': 'एसओएस बटन दबाया गया',
      'daysAgo2_1132am': '2 दिन पहले, 11:32 AM',
      'low': 'कम',
      'lastVisited': 'अंतिम देखा गया',
      'unknownDistance': 'अज्ञात'
    },
    'ko': {
      'sosButtonPressed': 'SOS 버튼 눌림',
      'daysAgo2_1132am': '2일 전, 오전 11:32',
      'low': '낮음',
      'lastVisited': '최근 방문',
      'unknownDistance': '알 수 없음'
    },
    'vi': {
      'sosButtonPressed': 'Đã nhấn nút SOS',
      'daysAgo2_1132am': '2 ngày trước, 11:32 SA',
      'low': 'Thấp',
      'lastVisited': 'Đã truy cập lần cuối',
      'unknownDistance': 'Không xác định'
    }
  };

  for (var file in files) {
    String lang = file.path.split('_').last.split('.').first;
    if (lang == 'en') lang = 'en';
    Map<String, String> trans = translations[lang] ?? translations['en']!;
    
    String content = file.readAsStringSync();
    Map<String, dynamic> arbMap = jsonDecode(content);
    
    bool updated = false;
    for (var entry in trans.entries) {
      if (!arbMap.containsKey(entry.key)) {
        arbMap[entry.key] = entry.value;
        updated = true;
      }
    }
    
    if (updated) {
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      file.writeAsStringSync(encoder.convert(arbMap));
      print('Updated \${file.path}');
    }
  }
}
