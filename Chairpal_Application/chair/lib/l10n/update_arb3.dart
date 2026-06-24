import 'dart:convert';
import 'dart:io';

void main() async {
  final directory = Directory('lib/l10n');
  final files = directory.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();

  final Map<String, Map<String, String>> translations = {
    'en': {
      'myAccount': 'My Account',
      'updateProfile': 'Update Profile',
      'dateOfBirth': 'Date of Birth',
      'dateOfBirthHint': 'Select Date of Birth',
      'logoutOtherDevices': 'Logout other devices',
      'followDoctor': 'Follow Doctor?',
      'update': 'Update',
      'camera': 'Camera',
      'gallery': 'Gallery'
    },
    'ar': {
      'myAccount': 'حسابي',
      'updateProfile': 'تحديث الملف الشخصي',
      'dateOfBirth': 'تاريخ الميلاد',
      'dateOfBirthHint': 'اختر تاريخ الميلاد',
      'logoutOtherDevices': 'تسجيل الخروج من الأجهزة الأخرى',
      'followDoctor': 'متابعة مع طبيب؟',
      'update': 'تحديث',
      'camera': 'الكاميرا',
      'gallery': 'المعرض'
    },
    'de': {
      'myAccount': 'Mein Konto',
      'updateProfile': 'Profil aktualisieren',
      'dateOfBirth': 'Geburtsdatum',
      'dateOfBirthHint': 'Geburtsdatum wählen',
      'logoutOtherDevices': 'Von anderen Geräten abmelden',
      'followDoctor': 'Arzt folgen?',
      'update': 'Aktualisieren',
      'camera': 'Kamera',
      'gallery': 'Galerie'
    },
    'fr': {
      'myAccount': 'Mon compte',
      'updateProfile': 'Mettre à jour le profil',
      'dateOfBirth': 'Date de naissance',
      'dateOfBirthHint': 'Sélectionner la date de naissance',
      'logoutOtherDevices': 'Déconnexion des autres appareils',
      'followDoctor': 'Suivre un médecin?',
      'update': 'Mettre à jour',
      'camera': 'Caméra',
      'gallery': 'Galerie'
    },
    'hi': {
      'myAccount': 'मेरा खाता',
      'updateProfile': 'प्रोफ़ाइल अपडेट करें',
      'dateOfBirth': 'जन्म की तारीख',
      'dateOfBirthHint': 'जन्म तिथि चुनें',
      'logoutOtherDevices': 'अन्य उपकरणों से लॉग आउट करें',
      'followDoctor': 'डॉक्टर को फॉलो करें?',
      'update': 'अपडेट करें',
      'camera': 'कैमरा',
      'gallery': 'गेलरी'
    },
    'ko': {
      'myAccount': '내 계정',
      'updateProfile': '프로필 업데이트',
      'dateOfBirth': '생년월일',
      'dateOfBirthHint': '생년월일 선택',
      'logoutOtherDevices': '다른 기기에서 로그아웃',
      'followDoctor': '의사 팔로우?',
      'update': '업데이트',
      'camera': '카메라',
      'gallery': '갤러리'
    },
    'vi': {
      'myAccount': 'Tài khoản của tôi',
      'updateProfile': 'Cập nhật hồ sơ',
      'dateOfBirth': 'Ngày sinh',
      'dateOfBirthHint': 'Chọn ngày sinh',
      'logoutOtherDevices': 'Đăng xuất khỏi các thiết bị khác',
      'followDoctor': 'Theo dõi Bác sĩ?',
      'update': 'Cập nhật',
      'camera': 'Máy ảnh',
      'gallery': 'Thư viện'
    }
  };

  for (var file in files) {
    final languageCode = file.uri.pathSegments.last.replaceAll('intl_', '').replaceAll('.arb', '');
    if (translations.containsKey(languageCode)) {
      final content = await file.readAsString();
      final Map<String, dynamic> jsonContent = jsonDecode(content);
      
      jsonContent.addAll(translations[languageCode]!);
      
      final encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(jsonContent));
      print('Updated \${file.path}');
    }
  }
}
