// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m6(count) => "${count} Gebäude";

  static String m7(count) => "${count} Etagen";

  static String m8(name) => "Hallo, ${name}";

  static String m9(name) => "Hallo, ${name}";

  static String m10(date) => "Beigetreten ${date}";

  static String m11(count) => "${count} Orte";

  static String m12(category) => "Beliebt in ${category}";

  static String m13(name) => "Bewerte ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Über"),
    "aboutBuilding": MessageLookupByLibrary.simpleMessage("Über das Gebäude"),
    "aboutFloor": MessageLookupByLibrary.simpleMessage("Über die Etage"),
    "addBuilding": MessageLookupByLibrary.simpleMessage("Gebäude hinzufügen"),
    "addFloor": MessageLookupByLibrary.simpleMessage("Etage hinzufügen"),
    "addFriend": MessageLookupByLibrary.simpleMessage("Freund hinzufügen"),
    "addNew": MessageLookupByLibrary.simpleMessage("Neu hinzufügen"),
    "addNewBuilding": MessageLookupByLibrary.simpleMessage(
      "Neues Gebäude hinzufügen",
    ),
    "addNewFloor": MessageLookupByLibrary.simpleMessage(
      "Neue Etage hinzufügen",
    ),
    "addNewPlace": MessageLookupByLibrary.simpleMessage("Neuen Ort hinzufügen"),
    "addNewPostPrompt": MessageLookupByLibrary.simpleMessage(
      "Neuen Beitrag hinzufügen?",
    ),
    "addOrganization": MessageLookupByLibrary.simpleMessage(
      "Organisation hinzufügen",
    ),
    "addPlace": MessageLookupByLibrary.simpleMessage("Ort hinzufügen"),
    "age": MessageLookupByLibrary.simpleMessage("Alter"),
    "agreeToPolicy": MessageLookupByLibrary.simpleMessage(
      "Ich stimme den Richtlinien zu",
    ),
    "aiHealthInsight": MessageLookupByLibrary.simpleMessage(
      "KI-Gesundheitsanalyse",
    ),
    "allLanguages": MessageLookupByLibrary.simpleMessage("Alle Sprachen"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Haben Sie bereits ein Konto?",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Chair Pal"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabisch"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to login"),
    "birthDate": MessageLookupByLibrary.simpleMessage("Birth Date"),
    "birthDateHint": MessageLookupByLibrary.simpleMessage("YYYY-MM-DD"),
    "bpm": MessageLookupByLibrary.simpleMessage("BPM"),
    "buildingAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Gebäude erfolgreich hinzugefügt!",
    ),
    "buildingDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Beschreiben Sie das Gebäude...",
    ),
    "buildingName": MessageLookupByLibrary.simpleMessage("Gebäudename"),
    "buildingNameHint": MessageLookupByLibrary.simpleMessage(
      "z.B. Hauptgebäude",
    ),
    "buildings": MessageLookupByLibrary.simpleMessage("Gebäude"),
    "buildingsCount": m6,
    "camera": MessageLookupByLibrary.simpleMessage("Kamera"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cannotReviewPlace": MessageLookupByLibrary.simpleMessage(
      "Dieser Ort kann nicht bewertet werden.",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Kategorien"),
    "categoryName": MessageLookupByLibrary.simpleMessage("Category Name"),
    "categoryNameHint": MessageLookupByLibrary.simpleMessage(
      "z.B. Universitäten",
    ),
    "celsius": MessageLookupByLibrary.simpleMessage("°C"),
    "chairPalAI": MessageLookupByLibrary.simpleMessage("ChairPal AI"),
    "changeMyEChair": MessageLookupByLibrary.simpleMessage(
      "Meinen E-Rollstuhl ändern",
    ),
    "changePassword": MessageLookupByLibrary.simpleMessage("Passwort ändern"),
    "chatClearedMessage": MessageLookupByLibrary.simpleMessage(
      "Chat cleared. How can I help you?",
    ),
    "chatbotWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Hello! I\'m your ChairPal AI assistant 🌍\\nAsk me anything about places, travel tips, or nearby spots!",
    ),
    "choose": MessageLookupByLibrary.simpleMessage("Wählen"),
    "city": MessageLookupByLibrary.simpleMessage("Stadt"),
    "cityHint": MessageLookupByLibrary.simpleMessage("z.B. Banha"),
    "cm": MessageLookupByLibrary.simpleMessage("cm"),
    "codeResentSuccess": MessageLookupByLibrary.simpleMessage(
      "Code wurde erfolgreich erneut gesendet.",
    ),
    "comment": MessageLookupByLibrary.simpleMessage("Kommentar"),
    "companionRequestPending": MessageLookupByLibrary.simpleMessage(
      "Companion Request Pending",
    ),
    "companionRequestPendingDesc": MessageLookupByLibrary.simpleMessage(
      "Your companion request is currently waiting for the user\'s approval. You\'ll gain access once the request is accepted.",
    ),
    "companionRequestRejected": MessageLookupByLibrary.simpleMessage(
      "Companion Request Rejected",
    ),
    "companionRequestRejectedDesc": MessageLookupByLibrary.simpleMessage(
      "Your companion request was declined by the user. Please check the username and try sending a new request.",
    ),
    "conditionDiabetes": MessageLookupByLibrary.simpleMessage("Diabetes"),
    "conditionElderly": MessageLookupByLibrary.simpleMessage("Elderly"),
    "conditionEpilepsy": MessageLookupByLibrary.simpleMessage("Epilepsy"),
    "conditionHeartDisease": MessageLookupByLibrary.simpleMessage(
      "Heart Disease",
    ),
    "conditionHighBloodPressure": MessageLookupByLibrary.simpleMessage(
      "High Blood Pressure",
    ),
    "conditionNone": MessageLookupByLibrary.simpleMessage("None of the above"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Neues Passwort bestätigen",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort bestätigen",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Weiter"),
    "country": MessageLookupByLibrary.simpleMessage("Land"),
    "countryHint": MessageLookupByLibrary.simpleMessage("z.B. Ägypten"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Konto erstellen"),
    "critical": MessageLookupByLibrary.simpleMessage("Kritisch"),
    "currentPassword": MessageLookupByLibrary.simpleMessage(
      "Aktuelles Passwort",
    ),
    "dateOfBirth": MessageLookupByLibrary.simpleMessage("Geburtsdatum"),
    "dateOfBirthHint": MessageLookupByLibrary.simpleMessage(
      "Geburtsdatum wählen",
    ),
    "daysAgo2_1132am": MessageLookupByLibrary.simpleMessage(
      "vor 2 Tagen, 11:32 Uhr",
    ),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Konto löschen"),
    "deleteAccountDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Sind Sie sicher, dass Sie Ihr Konto löschen möchten?",
    ),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Löschen"),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionOptional": MessageLookupByLibrary.simpleMessage(
      "Beschreibung (Optional)",
    ),
    "didNotReceiveCode": MessageLookupByLibrary.simpleMessage(
      "Code nicht erhalten?",
    ),
    "doctorUsername": MessageLookupByLibrary.simpleMessage("Doctor Username"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Sie haben kein Konto?",
    ),
    "dragDropImage": MessageLookupByLibrary.simpleMessage(
      "Drag & drop image or Browse",
    ),
    "editPlace": MessageLookupByLibrary.simpleMessage("Edit Place"),
    "email": MessageLookupByLibrary.simpleMessage("E-Mail"),
    "emailHint": MessageLookupByLibrary.simpleMessage("beispiel@gmail.com"),
    "emailVerifiedSuccess": MessageLookupByLibrary.simpleMessage(
      "Großartig! Ihre E-Mail wurde erfolgreich verifiziert.",
    ),
    "english": MessageLookupByLibrary.simpleMessage("Englisch"),
    "enterAge": MessageLookupByLibrary.simpleMessage("18"),
    "enterCurrentAndNewPassword": MessageLookupByLibrary.simpleMessage(
      "Geben Sie Ihr aktuelles Passwort und ein neues Passwort ein.",
    ),
    "enterLocation": MessageLookupByLibrary.simpleMessage(
      "Geben Sie Ihren Standort ein",
    ),
    "enterOrganizationLocationHint": MessageLookupByLibrary.simpleMessage(
      "Geben Sie den Standort der Organisation ein",
    ),
    "enterOtpCode": MessageLookupByLibrary.simpleMessage("OTP-Code eingeben"),
    "enterPatientUsernameToSendConnectionRequest":
        MessageLookupByLibrary.simpleMessage(
          "Enter a patients username to send a connection request.",
        ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Geben Sie Ihre Telefonnummer ein",
    ),
    "enterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Verifizierungscode eingeben",
    ),
    "fallDetected": MessageLookupByLibrary.simpleMessage("Sturz erkannt"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fetchingLocation": MessageLookupByLibrary.simpleMessage(
      "Standort wird abgerufen...",
    ),
    "floorAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Etage erfolgreich hinzugefügt!",
    ),
    "floorDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Beschreiben Sie die Etage...",
    ),
    "floorLevel": MessageLookupByLibrary.simpleMessage("Ebene"),
    "floorLevelHint": MessageLookupByLibrary.simpleMessage("z.B. 0 oder 1"),
    "floorName": MessageLookupByLibrary.simpleMessage("Etagenname"),
    "floorNameHint": MessageLookupByLibrary.simpleMessage("z.B. Erdgeschoss"),
    "floors": MessageLookupByLibrary.simpleMessage("Etagen"),
    "floorsCount": m7,
    "floorsNumberLevels": MessageLookupByLibrary.simpleMessage(
      "Anzahl der Etagen/ Ebenen",
    ),
    "followDoctor": MessageLookupByLibrary.simpleMessage("Arzt folgen?"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort vergessen?",
    ),
    "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Verifizierungscode zum Zurücksetzen Ihres Passworts.",
    ),
    "forgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Passwort vergessen?",
    ),
    "gallery": MessageLookupByLibrary.simpleMessage("Galerie"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Loslegen"),
    "greeting": m8,
    "healthAssistantIntroMessage": MessageLookupByLibrary.simpleMessage(
      "Before we begin, answer a few quick questions to personalize your health monitoring.",
    ),
    "healthAssistantIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Hi, I\'m your health assistant!",
    ),
    "healthConditionTitle": MessageLookupByLibrary.simpleMessage(
      "Tell us about your health condition so we can provide smarter monitoring.",
    ),
    "healthStatusIs": MessageLookupByLibrary.simpleMessage(
      "Ihr Gesundheitszustand ist ",
    ),
    "heartRate": MessageLookupByLibrary.simpleMessage("Herzfrequenz"),
    "height": MessageLookupByLibrary.simpleMessage("Height"),
    "heightCm": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "helpSupport": MessageLookupByLibrary.simpleMessage("Hilfe & Support"),
    "helpSupportAssistance": MessageLookupByLibrary.simpleMessage(
      "Brauchen Sie Hilfe? Das ChairPal-Team ist bereit, Ihnen zu helfen.",
    ),
    "helpSupportContactInfo": MessageLookupByLibrary.simpleMessage(
      "Kontaktinformationen",
    ),
    "helpSupportMessage": MessageLookupByLibrary.simpleMessage("Nachricht"),
    "helpSupportMessageHint": MessageLookupByLibrary.simpleMessage(
      "Geben Sie hier die Nachricht ein..",
    ),
    "helpSupportSend": MessageLookupByLibrary.simpleMessage("Senden"),
    "helpSupportSuccessDesc1": MessageLookupByLibrary.simpleMessage(
      "Vielen Dank für Ihre Kontaktaufnahme. Das ",
    ),
    "helpSupportSuccessDesc2": MessageLookupByLibrary.simpleMessage("ChairPal"),
    "helpSupportSuccessDesc3": MessageLookupByLibrary.simpleMessage(
      "-Support-Team wird sich bald bei Ihnen melden.",
    ),
    "helpSupportSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Nachricht erfolgreich gesendet!",
    ),
    "hiUser": m9,
    "high": MessageLookupByLibrary.simpleMessage("Hoch"),
    "highHeartRate": MessageLookupByLibrary.simpleMessage("Hohe Herzfrequenz"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "imageOfOrganization": MessageLookupByLibrary.simpleMessage(
      "Bild der Organisation",
    ),
    "joinedDate": m10,
    "kg": MessageLookupByLibrary.simpleMessage("kg"),
    "languageSelectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wählen Sie unten Ihre bevorzugte Sprache aus, damit wir Sie besser bedienen können.",
    ),
    "languageSelectionTitle": MessageLookupByLibrary.simpleMessage(
      "Wählen Sie Ihre Sprache",
    ),
    "languageSetting": MessageLookupByLibrary.simpleMessage("Sprache"),
    "lastUpdate": MessageLookupByLibrary.simpleMessage("Last update: "),
    "lastVisited": MessageLookupByLibrary.simpleMessage("Zuletzt besucht"),
    "letsGo": MessageLookupByLibrary.simpleMessage("Let\'s Go"),
    "liveHealthMonitoring": MessageLookupByLibrary.simpleMessage(
      "Live-Gesundheitsüberwachung",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Standort"),
    "locationFetched": MessageLookupByLibrary.simpleMessage(
      "Standort abgerufen",
    ),
    "locationNotSet": MessageLookupByLibrary.simpleMessage(
      "Ort nicht festgelegt",
    ),
    "locationPermissionsDenied": MessageLookupByLibrary.simpleMessage(
      "Standortberechtigungen wurden verweigert.",
    ),
    "locationPermissionsPermanentlyDenied":
        MessageLookupByLibrary.simpleMessage(
          "Standortberechtigungen wurden dauerhaft verweigert.",
        ),
    "locationServicesDisabled": MessageLookupByLibrary.simpleMessage(
      "Standortdienste sind deaktiviert.",
    ),
    "logOut": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "loggedInSuccess": MessageLookupByLibrary.simpleMessage(
      "Erfolgreich angemeldet.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "loginScreenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Greifen Sie auf Ihr Konto zu, um Ihren Rollstuhl zu steuern und Community-Funktionen zu nutzen.",
    ),
    "loginScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Melden Sie sich bei Ihrem Konto an",
    ),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Melden Sie sich an, um fortzufahren",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Willkommen zurück"),
    "logo": MessageLookupByLibrary.simpleMessage("Logo"),
    "logoutButton": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "logoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Oh! Sie gehen. Sind Sie sicher?",
    ),
    "logoutOtherDevices": MessageLookupByLibrary.simpleMessage(
      "Von anderen Geräten abmelden",
    ),
    "love": MessageLookupByLibrary.simpleMessage("Liebe"),
    "low": MessageLookupByLibrary.simpleMessage("Niedrig"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "medicalConditionIds": MessageLookupByLibrary.simpleMessage(
      "Medical Condition IDs (comma separated)",
    ),
    "medicalConditionIdsHint": MessageLookupByLibrary.simpleMessage(
      "e.g. 1, 2",
    ),
    "medicalInfo": MessageLookupByLibrary.simpleMessage(
      "Medizinische Informationen",
    ),
    "medium": MessageLookupByLibrary.simpleMessage("Mittel"),
    "messageAction": MessageLookupByLibrary.simpleMessage("Nachricht"),
    "movement": MessageLookupByLibrary.simpleMessage("Bewegung"),
    "myAccount": MessageLookupByLibrary.simpleMessage("Mein Konto"),
    "myCommunity": MessageLookupByLibrary.simpleMessage("Meine Community"),
    "myFavorites": MessageLookupByLibrary.simpleMessage("Meine Favoriten"),
    "myPosts": MessageLookupByLibrary.simpleMessage("Meine Beiträge"),
    "myProfile": MessageLookupByLibrary.simpleMessage("Mein Profil"),
    "name": MessageLookupByLibrary.simpleMessage("Vollständiger Name"),
    "nameHint": MessageLookupByLibrary.simpleMessage("Max Mustermann"),
    "newChat": MessageLookupByLibrary.simpleMessage("New Chat"),
    "newPassword": MessageLookupByLibrary.simpleMessage("Neues Passwort"),
    "next": MessageLookupByLibrary.simpleMessage("Weiter"),
    "noAiInsights": MessageLookupByLibrary.simpleMessage(
      "Noch keine KI-Erkenntnisse generiert. Warten auf weitere Daten...",
    ),
    "noBuildingsFound": MessageLookupByLibrary.simpleMessage(
      "Keine Gebäude gefunden.",
    ),
    "noCancel": MessageLookupByLibrary.simpleMessage("Nein, Abbrechen"),
    "noCategoriesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wir konnten im Moment keine Kategorien finden.",
    ),
    "noCategoriesTitle": MessageLookupByLibrary.simpleMessage(
      "Keine Kategorien",
    ),
    "noChartData": MessageLookupByLibrary.simpleMessage(
      "Keine Diagrammdaten verfügbar",
    ),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage(
      "Noch keine Kommentare.",
    ),
    "noConnections": MessageLookupByLibrary.simpleMessage("No Connections"),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noFavoritesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Orte, die Sie als Favoriten speichern, werden hier für den Schnellzugriff angezeigt",
    ),
    "noFavoritesYet": MessageLookupByLibrary.simpleMessage(
      "Noch keine Favoriten",
    ),
    "noFloorsFound": MessageLookupByLibrary.simpleMessage(
      "Keine Etagen gefunden.",
    ),
    "noNotificationsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sie haben derzeit keine Benachrichtigungen.\nAlle Warnungen und Aktualisierungen werden hier angezeigt",
    ),
    "noNotificationsTitle": MessageLookupByLibrary.simpleMessage(
      "Noch Keine Benachrichtigungen",
    ),
    "noNotificationsYet": MessageLookupByLibrary.simpleMessage(
      "Noch keine Benachrichtigungen.",
    ),
    "noPatientsAssigned": MessageLookupByLibrary.simpleMessage(
      "Noch keine Patienten zugewiesen.",
    ),
    "noPlacesFound": MessageLookupByLibrary.simpleMessage(
      "Keine Orte gefunden.",
    ),
    "noPlacesFoundSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wir konnten keine beliebten Orte in der Nähe finden.",
    ),
    "noPlacesFoundTitle": MessageLookupByLibrary.simpleMessage(
      "Keine Orte gefunden",
    ),
    "noPostsYetDesc": MessageLookupByLibrary.simpleMessage(
      "Momentan gibt es keine Beiträge. Beiträge erscheinen hier, sobald sie geteilt werden",
    ),
    "noPostsYetTitle": MessageLookupByLibrary.simpleMessage(
      "Noch keine Beiträge",
    ),
    "noRecentActivity": MessageLookupByLibrary.simpleMessage(
      "Keine letzte Aktivität.",
    ),
    "noRecentAlerts": MessageLookupByLibrary.simpleMessage(
      "Keine aktuellen Warnungen",
    ),
    "noSessionsFound": MessageLookupByLibrary.simpleMessage(
      "No sessions found.",
    ),
    "normal": MessageLookupByLibrary.simpleMessage("Normal"),
    "normalActivity": MessageLookupByLibrary.simpleMessage("Normale Aktivität"),
    "normalRangeHeartRate": MessageLookupByLibrary.simpleMessage(
      "Normalbereich: 60-100",
    ),
    "normalRangeTemperature": MessageLookupByLibrary.simpleMessage(
      "Normalbereich: 36.1-37.2",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
    "onboardingDescription1": MessageLookupByLibrary.simpleMessage(
      "Ihr perfekter Begleiter für die Navigation mit Ihrem Rollstuhl. Wir helfen Ihnen, barrierefreie Orte zu finden und sich mit einer unterstützenden Gemeinschaft zu verbinden.",
    ),
    "onboardingDescription2": MessageLookupByLibrary.simpleMessage(
      "Entdecken Sie rollstuhlgerechte Orte in Ihrer Nähe. Lesen Sie Bewertungen anderer Benutzer, um fundierte Entscheidungen zu treffen.",
    ),
    "onboardingDescription3": MessageLookupByLibrary.simpleMessage(
      "Verbinden Sie sich mit anderen, teilen Sie Ihre Erfahrungen und helfen Sie gemeinsam, eine barrierefreiere Welt aufzubauen.",
    ),
    "onboardingPage1Description": MessageLookupByLibrary.simpleMessage(
      "Intelligente Funktionen für Benutzer, Begleiter, Ärzte und Organisationen.",
    ),
    "onboardingPage1Title": MessageLookupByLibrary.simpleMessage(
      "Intelligente Mobilität und Kontrolle für jeden Benutzer",
    ),
    "onboardingPage2Description": MessageLookupByLibrary.simpleMessage(
      "Entdecken Sie barrierefreie Orte, die von Organisationen erstellt wurden, oder erstellen Sie Ihre eigenen.",
    ),
    "onboardingPage2Title": MessageLookupByLibrary.simpleMessage(
      "Entdecken und Erstellen Sie barrierefreie Orte",
    ),
    "onboardingPage3Description": MessageLookupByLibrary.simpleMessage(
      "Verbunden mit Benutzern und Begleitern in einem unterstützenden Umfeld.",
    ),
    "onboardingPage3Title": MessageLookupByLibrary.simpleMessage(
      "Verbinden Sie sich mit einer unterstützenden Gemeinschaft",
    ),
    "onboardingPage4Description": MessageLookupByLibrary.simpleMessage(
      "Verfolgen Sie Ihren Gesundheitszustand, erhalten Sie Notfallwarnungen und bleiben Sie informiert",
    ),
    "onboardingPage4Title": MessageLookupByLibrary.simpleMessage(
      "Bleiben Sie auf dem Laufenden mit Echtzeit-Gesundheitsüberwachung",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Willkommen bei Wheelchair Buddy",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Finden Sie barrierefreie Orte",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Treten Sie unserer Gemeinschaft bei",
    ),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "oops": MessageLookupByLibrary.simpleMessage("Hoppla!"),
    "orContinueWith": MessageLookupByLibrary.simpleMessage("Oder weiter mit"),
    "organizationAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Organisation erfolgreich hinzugefügt!",
    ),
    "organizationDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Beschreiben Sie die Organisation...",
    ),
    "organizationName": MessageLookupByLibrary.simpleMessage(
      "Organisationsname",
    ),
    "organizationNameHint": MessageLookupByLibrary.simpleMessage(
      "z.B. FCAI Fakultät",
    ),
    "otpMustBe4Digits": MessageLookupByLibrary.simpleMessage(
      "OTP muss 4 Ziffern haben",
    ),
    "otpSentSuccess": MessageLookupByLibrary.simpleMessage(
      "OTP wurde erfolgreich an Ihre E-Mail gesendet.",
    ),
    "otpSentTo": MessageLookupByLibrary.simpleMessage(
      "Wir haben einen 4-stelligen Code gesendet an",
    ),
    "otpVerifiedSuccess": MessageLookupByLibrary.simpleMessage(
      "OTP erfolgreich verifiziert.",
    ),
    "overview": MessageLookupByLibrary.simpleMessage("Übersicht"),
    "password": MessageLookupByLibrary.simpleMessage("Passwort"),
    "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Passwort erfolgreich geändert.",
    ),
    "passwordHint": MessageLookupByLibrary.simpleMessage("••••••••"),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Passwort muss mindestens 6 Zeichen lang sein",
    ),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Ihr Passwort wurde erfolgreich zurückgesetzt.",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "Das Passwort muss mindestens 6 Zeichen lang sein",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwörter stimmen nicht überein",
    ),
    "patientUsername": MessageLookupByLibrary.simpleMessage(
      "Patients Username",
    ),
    "patients": MessageLookupByLibrary.simpleMessage("Patienten"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Telefonnummer"),
    "placeAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Ort erfolgreich hinzugefügt!",
    ),
    "placeDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Beschreiben Sie den Ort...",
    ),
    "placeName": MessageLookupByLibrary.simpleMessage("Ortsname"),
    "placeNameHint": MessageLookupByLibrary.simpleMessage(
      "z.B. Raum 101, Cafeteria",
    ),
    "places": MessageLookupByLibrary.simpleMessage("Orte"),
    "placesCount": m11,
    "pleaseAgreeToPolicy": MessageLookupByLibrary.simpleMessage(
      "Bitte stimmen Sie den Richtlinien zu",
    ),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Bitte bestätigen Sie Ihr neues Passwort",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Bitte bestätigen Sie Ihr Passwort",
    ),
    "pleaseConnectFromDoctorSearch": MessageLookupByLibrary.simpleMessage(
      "Bitte verbinden Sie sich über die Arztsuche",
    ),
    "pleaseEnterCurrentPassword": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihr aktuelles Passwort ein",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihre E-Mail ein",
    ),
    "pleaseEnterName": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihren vollständigen Namen ein",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie ein neues Passwort ein",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihr Passwort ein",
    ),
    "pleaseEnterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihre Telefonnummer ein",
    ),
    "pleaseEnterUsername": MessageLookupByLibrary.simpleMessage(
      "Please enter username",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie eine gültige E-Mail ein",
    ),
    "pleaseEnterValidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie eine gültige Telefonnummer ein",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie den Verifizierungscode ein",
    ),
    "pleaseEnterYourEmail": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie Ihre E-Mail ein",
    ),
    "pleaseSelectBirthDate": MessageLookupByLibrary.simpleMessage(
      "Please select birth date",
    ),
    "pleaseSelectGender": MessageLookupByLibrary.simpleMessage(
      "Please select gender",
    ),
    "pleaseSelectRating": MessageLookupByLibrary.simpleMessage(
      "Bitte wählen Sie zuerst eine Bewertung aus.",
    ),
    "pleaseSetLocationFirst": MessageLookupByLibrary.simpleMessage(
      "Bitte legen Sie zuerst den Standort fest.",
    ),
    "pleaseUploadLogo": MessageLookupByLibrary.simpleMessage(
      "Bitte laden Sie ein Logo hoch",
    ),
    "popularIn": m12,
    "popularPlaces": MessageLookupByLibrary.simpleMessage("Beliebte Orte"),
    "postsTabTitle": MessageLookupByLibrary.simpleMessage("Beiträge"),
    "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Profil erfolgreich aktualisiert",
    ),
    "rateAppHint": MessageLookupByLibrary.simpleMessage(
      "Schreiben Sie Ihre Meinung (optional)..",
    ),
    "ratePlaceTitle": m13,
    "rateThisBuilding": MessageLookupByLibrary.simpleMessage(
      "Dieses Gebäude bewerten",
    ),
    "rateThisFloor": MessageLookupByLibrary.simpleMessage(
      "Diese Etage bewerten",
    ),
    "rateThisPlace": MessageLookupByLibrary.simpleMessage(
      "Diesen Ort bewerten",
    ),
    "readMore": MessageLookupByLibrary.simpleMessage("mehr lesen.."),
    "recentActivity": MessageLookupByLibrary.simpleMessage("Letzte Aktivität"),
    "recentAlerts": MessageLookupByLibrary.simpleMessage("Aktuelle Warnungen"),
    "recommendedPosts": MessageLookupByLibrary.simpleMessage(
      "Empfohlene Beiträge",
    ),
    "rememberMe": MessageLookupByLibrary.simpleMessage("Angemeldet bleiben"),
    "requestAcceptedDesc": MessageLookupByLibrary.simpleMessage(
      "Welcome aboard! Your companion request has been accepted. You can now start monitoring and supporting the user.",
    ),
    "requestAcceptedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Request Accepted Successfully",
    ),
    "requestAlreadyHandled": MessageLookupByLibrary.simpleMessage(
      "Diese Anfrage wurde bereits bearbeitet.",
    ),
    "requestRejectedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Anfrage erfolgreich abgelehnt",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Required"),
    "requiredField": MessageLookupByLibrary.simpleMessage("Erforderlich"),
    "resendCode": MessageLookupByLibrary.simpleMessage("Code erneut senden"),
    "resendCodeTimer": MessageLookupByLibrary.simpleMessage(
      "Code erneut senden • 00:30",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Geben Sie unten Ihr neues Passwort ein.",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "reviewPostedSuccess": MessageLookupByLibrary.simpleMessage(
      "Bewertung erfolgreich gepostet!",
    ),
    "reviewsVisibilityNote": MessageLookupByLibrary.simpleMessage(
      "Alle Benutzer können Ihre Bewertungen sehen, die Ihre Profilinformationen enthalten",
    ),
    "roleOrganization": MessageLookupByLibrary.simpleMessage("Organisation"),
    "roleOrganizationDescription": MessageLookupByLibrary.simpleMessage(
      "Greifen Sie auf Ihr Konto zu, um Systemfunktionen zu verwalten.",
    ),
    "roleSelectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wählen Sie Ihre Rolle, damit wir die App-Erfahrung für Sie anpassen können.",
    ),
    "roleSelectionTitle": MessageLookupByLibrary.simpleMessage(
      "Wählen Sie, wie Sie die App verwenden möchten",
    ),
    "roleUser": MessageLookupByLibrary.simpleMessage("Benutzer"),
    "roleUserDescription": MessageLookupByLibrary.simpleMessage(
      "Greifen Sie auf Ihr Konto zu, um verfügbare Funktionen zu nutzen.",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Suche"),
    "selectLanguageFirst": MessageLookupByLibrary.simpleMessage(
      "Bitte wählen Sie zuerst eine Sprache aus",
    ),
    "sendOtp": MessageLookupByLibrary.simpleMessage("OTP senden"),
    "sendRequest": MessageLookupByLibrary.simpleMessage("Send Request"),
    "share": MessageLookupByLibrary.simpleMessage("Teilen"),
    "shares": MessageLookupByLibrary.simpleMessage("Geteilt"),
    "signUp": MessageLookupByLibrary.simpleMessage("Registrieren"),
    "signupSubtitle": MessageLookupByLibrary.simpleMessage(
      "Melden Sie sich an, um zu beginnen",
    ),
    "signupSubtitleOrg": MessageLookupByLibrary.simpleMessage(
      "Erstellen Sie ein neues Konto, um Benutzer zu verwalten und Systemaktivitäten zu verfolgen.",
    ),
    "signupSubtitleUser": MessageLookupByLibrary.simpleMessage(
      "Erstellen Sie ein neues Konto, um den Rollstuhl zu steuern und barrierefreie Orte zu entdecken.",
    ),
    "signupTitle": MessageLookupByLibrary.simpleMessage("Konto erstellen"),
    "signupTitleOrg": MessageLookupByLibrary.simpleMessage(
      "Neues Konto erstellen",
    ),
    "signupTitleUser": MessageLookupByLibrary.simpleMessage(
      "Neues Konto erstellen",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("Überspringen"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Etwas ist schief gelaufen.",
    ),
    "sosButtonPressed": MessageLookupByLibrary.simpleMessage(
      "SOS-Taste gedrückt",
    ),
    "stable": MessageLookupByLibrary.simpleMessage("stabil"),
    "steps": MessageLookupByLibrary.simpleMessage("Schritte"),
    "submitReview": MessageLookupByLibrary.simpleMessage("Bewertung absenden"),
    "targetUsername": MessageLookupByLibrary.simpleMessage("Target Username"),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperatur"),
    "today": MessageLookupByLibrary.simpleMessage("Heute"),
    "today847am": MessageLookupByLibrary.simpleMessage("Heute, 08:47 AM"),
    "totalPatients": MessageLookupByLibrary.simpleMessage("Gesamt"),
    "totalPlaces": MessageLookupByLibrary.simpleMessage("Gesamtorte"),
    "typeAMessage": MessageLookupByLibrary.simpleMessage(
      "Schreibe eine Nachricht...",
    ),
    "typeDescriptionHere": MessageLookupByLibrary.simpleMessage(
      "Geben Sie die Beschreibung hier ein..",
    ),
    "typeYourMessage": MessageLookupByLibrary.simpleMessage(
      "Type your message...",
    ),
    "unknownDistance": MessageLookupByLibrary.simpleMessage("Unbekannt"),
    "update": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "updatePassword": MessageLookupByLibrary.simpleMessage(
      "Passwort aktualisieren",
    ),
    "updateProfile": MessageLookupByLibrary.simpleMessage(
      "Profil aktualisieren",
    ),
    "uploadBuildingImage": MessageLookupByLibrary.simpleMessage(
      "Hauptbild des Gebäudes hochladen",
    ),
    "uploadFloorImage": MessageLookupByLibrary.simpleMessage(
      "Etagenbild hochladen (Optional)",
    ),
    "uploadOrganizationImage": MessageLookupByLibrary.simpleMessage(
      "Hauptbild der Organisation hochladen",
    ),
    "uploadPlaceImage": MessageLookupByLibrary.simpleMessage(
      "Ortsbild hochladen (Optional)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "verificationCodeMustBe4Digits": MessageLookupByLibrary.simpleMessage(
      "Der Verifizierungscode muss 4 Ziffern lang sein",
    ),
    "verificationCodeResent": MessageLookupByLibrary.simpleMessage(
      "Verifizierungscode wurde erneut gesendet!",
    ),
    "verificationDescription": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie den 4-stelligen Code ein, der an\\nIhre E-Mail gesendet wurde, um Ihr Konto zu bestätigen.",
    ),
    "verificationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Geben Sie den Code ein, der gesendet wurde an",
    ),
    "verificationSuccessful": MessageLookupByLibrary.simpleMessage(
      "Verifizierung erfolgreich!",
    ),
    "verificationTitle": MessageLookupByLibrary.simpleMessage("Verifizierung"),
    "verify": MessageLookupByLibrary.simpleMessage("Verifizieren"),
    "verifyOtp": MessageLookupByLibrary.simpleMessage("OTP verifizieren"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Alle ansehen"),
    "viewLess": MessageLookupByLibrary.simpleMessage("weniger anzeigen.."),
    "vitalSignsNormal": MessageLookupByLibrary.simpleMessage(
      ". Alle Vitalwerte liegen im Normalbereich.",
    ),
    "warningLabel": MessageLookupByLibrary.simpleMessage("Warning"),
    "weight": MessageLookupByLibrary.simpleMessage("Weight"),
    "weightKg": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "writeAComment": MessageLookupByLibrary.simpleMessage(
      "Schreibe einen Kommentar...",
    ),
    "yesDelete": MessageLookupByLibrary.simpleMessage("Ja, Löschen"),
    "yesLogout": MessageLookupByLibrary.simpleMessage("Ja, Abmelden"),
    "yesterday615pm": MessageLookupByLibrary.simpleMessage("Gestern, 06:15 PM"),
    "youDontHaveAnyConnectedPatients": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any connected patients.\\nApproved patient connections will appear here.",
    ),
    "yourPlaces": MessageLookupByLibrary.simpleMessage("Deine Orte"),
  };
}
