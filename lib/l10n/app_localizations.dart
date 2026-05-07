import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @generateQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate QR'**
  String get generateQrTitle;

  /// No description provided for @generateQrPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter content to\ngenerate QR'**
  String get generateQrPlaceholder;

  /// No description provided for @generateQrInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text, link, phone number...'**
  String get generateQrInputHint;

  /// No description provided for @generateQrColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get generateQrColor;

  /// No description provided for @generateQrEyeShape.
  ///
  /// In en, this message translates to:
  /// **'Eye Shape'**
  String get generateQrEyeShape;

  /// No description provided for @generateQrPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get generateQrPattern;

  /// No description provided for @generateQrBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get generateQrBackground;

  /// No description provided for @generateQrShapeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get generateQrShapeSquare;

  /// No description provided for @generateQrShapeCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get generateQrShapeCircle;

  /// No description provided for @generateQrShapeSmooth.
  ///
  /// In en, this message translates to:
  /// **'Smooth'**
  String get generateQrShapeSmooth;

  /// No description provided for @generateQrBgWhite.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get generateQrBgWhite;

  /// No description provided for @generateQrBgDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get generateQrBgDark;

  /// No description provided for @generateQrColorSmoke.
  ///
  /// In en, this message translates to:
  /// **'Smoke'**
  String get generateQrColorSmoke;

  /// No description provided for @generateQrBtnShare.
  ///
  /// In en, this message translates to:
  /// **'Save & share QR Code'**
  String get generateQrBtnShare;

  /// No description provided for @generateQrShareTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get generateQrShareTitle;

  /// No description provided for @generateQrShareError.
  ///
  /// In en, this message translates to:
  /// **'Error sharing QR: {error}'**
  String generateQrShareError(String error);

  /// No description provided for @scanHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistoryTitle;

  /// No description provided for @scanHistoryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading history...'**
  String get scanHistoryLoading;

  /// No description provided for @scanHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get scanHistoryEmptyTitle;

  /// No description provided for @scanHistoryEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scanned documents will appear\nhere when you start scanning.'**
  String get scanHistoryEmptySubtitle;

  /// No description provided for @scanHistoryErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Load Failed'**
  String get scanHistoryErrorTitle;

  /// No description provided for @scanHistoryErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get scanHistoryErrorMsg;

  /// No description provided for @scanHistoryRetryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get scanHistoryRetryBtn;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String timeDaysAgo(int days);

  /// No description provided for @historyNoTextExtracted.
  ///
  /// In en, this message translates to:
  /// **'No text extracted'**
  String get historyNoTextExtracted;

  /// No description provided for @historyTypeDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get historyTypeDocument;

  /// No description provided for @historyTypeQr.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get historyTypeQr;

  /// No description provided for @historyWordCount.
  ///
  /// In en, this message translates to:
  /// **'{words} words'**
  String historyWordCount(int words);

  /// No description provided for @historySeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get historySeeAll;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailed;

  /// No description provided for @exportPdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF: {error}'**
  String exportPdfFailed(String error);

  /// No description provided for @batchResultPageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages scanned'**
  String batchResultPageCount(int count);

  /// No description provided for @batchResultExportPdfBtn.
  ///
  /// In en, this message translates to:
  /// **'Export & Share PDF'**
  String get batchResultExportPdfBtn;

  /// No description provided for @scanResultCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get scanResultCopied;

  /// No description provided for @scanResultCopyText.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get scanResultCopyText;

  /// No description provided for @scanResultTapToZoom.
  ///
  /// In en, this message translates to:
  /// **'Tap to zoom'**
  String get scanResultTapToZoom;

  /// No description provided for @scanResultExtractedText.
  ///
  /// In en, this message translates to:
  /// **'Extracted Text'**
  String get scanResultExtractedText;

  /// No description provided for @scanResultWordCharCount.
  ///
  /// In en, this message translates to:
  /// **'{words} words · {chars} chars'**
  String scanResultWordCharCount(int words, int chars);

  /// No description provided for @scanResultPlainText.
  ///
  /// In en, this message translates to:
  /// **'Plain Text'**
  String get scanResultPlainText;

  /// No description provided for @scanResultVisualLayout.
  ///
  /// In en, this message translates to:
  /// **'Visual Layout'**
  String get scanResultVisualLayout;

  /// No description provided for @scanResultAiScan.
  ///
  /// In en, this message translates to:
  /// **'AI Scan'**
  String get scanResultAiScan;

  /// No description provided for @scanResultHideBoxes.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get scanResultHideBoxes;

  /// No description provided for @scanResultShowBoxes.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get scanResultShowBoxes;

  /// No description provided for @scanResultNoTextFound.
  ///
  /// In en, this message translates to:
  /// **'No text detected'**
  String get scanResultNoTextFound;

  /// No description provided for @scanResultTryClearerImage.
  ///
  /// In en, this message translates to:
  /// **'Try scanning a clearer image'**
  String get scanResultTryClearerImage;

  /// No description provided for @scannerGalleryBtn.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get scannerGalleryBtn;

  /// No description provided for @scannerInstructionQr.
  ///
  /// In en, this message translates to:
  /// **'Point at QR / Barcode'**
  String get scannerInstructionQr;

  /// No description provided for @scannerInstructionId.
  ///
  /// In en, this message translates to:
  /// **'Align ID card'**
  String get scannerInstructionId;

  /// No description provided for @scannerInstructionBatch.
  ///
  /// In en, this message translates to:
  /// **'Scan pages one by one'**
  String get scannerInstructionBatch;

  /// No description provided for @scannerInstructionDoc.
  ///
  /// In en, this message translates to:
  /// **'Align document in bounds'**
  String get scannerInstructionDoc;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning ☀️'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon 🌤️'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening 🌙'**
  String get homeGreetingEvening;

  /// No description provided for @homeTotalScans.
  ///
  /// In en, this message translates to:
  /// **'Total Scans'**
  String get homeTotalScans;

  /// No description provided for @homeThisWeekScans.
  ///
  /// In en, this message translates to:
  /// **'Scans this week'**
  String get homeThisWeekScans;

  /// No description provided for @homeWordsExtracted.
  ///
  /// In en, this message translates to:
  /// **'Words extracted'**
  String get homeWordsExtracted;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeQuickScanDoc.
  ///
  /// In en, this message translates to:
  /// **'Scan\nDocument'**
  String get homeQuickScanDoc;

  /// No description provided for @homeQuickScanDocDesc.
  ///
  /// In en, this message translates to:
  /// **'Extract from image'**
  String get homeQuickScanDocDesc;

  /// No description provided for @homeQuickScanId.
  ///
  /// In en, this message translates to:
  /// **'Scan\nQR Code'**
  String get homeQuickScanId;

  /// No description provided for @homeQuickScanIdDesc.
  ///
  /// In en, this message translates to:
  /// **'Extract card info'**
  String get homeQuickScanIdDesc;

  /// No description provided for @homeQuickScanBatch.
  ///
  /// In en, this message translates to:
  /// **'Scan\n& Export'**
  String get homeQuickScanBatch;

  /// No description provided for @homeQuickScanBatchDesc.
  ///
  /// In en, this message translates to:
  /// **'Create PDF'**
  String get homeQuickScanBatchDesc;

  /// No description provided for @homeQuickGenerateQr.
  ///
  /// In en, this message translates to:
  /// **'My\nQR Code'**
  String get homeQuickGenerateQr;

  /// No description provided for @homeQuickGenerateQrDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and share'**
  String get homeQuickGenerateQrDesc;

  /// No description provided for @homeRecentHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get homeRecentHistory;

  /// No description provided for @homeEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get homeEmptyStateTitle;

  /// No description provided for @homeEmptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your scanned documents will appear here.\nTap Scan to start!'**
  String get homeEmptyStateSubtitle;

  /// No description provided for @homeHeroBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get homeHeroBtn;

  /// No description provided for @homeHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Digitize documents instantly with AI'**
  String get homeHeroDesc;

  /// No description provided for @homeStatsScannedDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents scanned'**
  String get homeStatsScannedDocs;

  /// No description provided for @homeStatsScannedQr.
  ///
  /// In en, this message translates to:
  /// **'QR Codes scanned'**
  String get homeStatsScannedQr;

  /// No description provided for @homeStatsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get homeStatsSaved;

  /// No description provided for @homeTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabHome;

  /// No description provided for @homeTabSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get homeTabSetting;

  /// No description provided for @homeTabQr.
  ///
  /// In en, this message translates to:
  /// **'QR Library'**
  String get homeTabQr;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @visibilityMode.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get visibilityMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @generateQrReminderName.
  ///
  /// In en, this message translates to:
  /// **'Reminder Name'**
  String get generateQrReminderName;

  /// No description provided for @generateQrReminderNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Facebook, Phone number...'**
  String get generateQrReminderNameHint;

  /// No description provided for @generateQrContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get generateQrContent;

  /// No description provided for @qrLibraryNoQrCodesSavedYet.
  ///
  /// In en, this message translates to:
  /// **'No QR codes saved yet.'**
  String get qrLibraryNoQrCodesSavedYet;

  /// No description provided for @untitledQr.
  ///
  /// In en, this message translates to:
  /// **'Untitled QR'**
  String get untitledQr;

  /// No description provided for @deleteQrCode.
  ///
  /// In en, this message translates to:
  /// **'Delete QR Code'**
  String get deleteQrCode;

  /// No description provided for @deleteQrCodeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this QR code?'**
  String get deleteQrCodeConfirm;

  /// No description provided for @deleteQrCodeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteQrCodeCancel;

  /// No description provided for @deleteQrCodeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteQrCodeDelete;

  /// No description provided for @qrDetailId.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String qrDetailId(String id);

  /// No description provided for @qrDetailContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get qrDetailContentLabel;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share Image'**
  String get shareImage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
