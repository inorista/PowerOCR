// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generateQrTitle => 'Generate QR';

  @override
  String get generateQrPlaceholder => 'Enter content to\ngenerate QR';

  @override
  String get generateQrInputHint => 'Enter text, link, phone number...';

  @override
  String get generateQrColor => 'Color';

  @override
  String get generateQrEyeShape => 'Eye Shape';

  @override
  String get generateQrPattern => 'Pattern';

  @override
  String get generateQrBackground => 'Background';

  @override
  String get generateQrShapeSquare => 'Square';

  @override
  String get generateQrShapeCircle => 'Circle';

  @override
  String get generateQrShapeSmooth => 'Smooth';

  @override
  String get generateQrBgWhite => 'Light';

  @override
  String get generateQrBgDark => 'Dark';

  @override
  String get generateQrColorSmoke => 'Smoke';

  @override
  String get generateQrBtnShare => 'Save & share QR Code';

  @override
  String get generateQrShareTitle => 'My QR Code';

  @override
  String generateQrShareError(String error) {
    return 'Error sharing QR: $error';
  }

  @override
  String get scanHistoryTitle => 'Scan History';

  @override
  String get scanHistoryLoading => 'Loading history...';

  @override
  String get scanHistoryEmptyTitle => 'No History Yet';

  @override
  String get scanHistoryEmptySubtitle =>
      'Scanned documents will appear\nhere when you start scanning.';

  @override
  String get scanHistoryErrorTitle => 'Load Failed';

  @override
  String get scanHistoryErrorMsg => 'An error occurred';

  @override
  String get scanHistoryRetryBtn => 'Retry';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String timeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get historyNoTextExtracted => 'No text extracted';

  @override
  String get historyTypeDocument => 'Document';

  @override
  String get historyTypeQr => 'QR Code';

  @override
  String historyWordCount(int words) {
    return '$words words';
  }

  @override
  String get historySeeAll => 'See All';

  @override
  String get scanFailed => 'Scan Failed';

  @override
  String exportPdfFailed(String error) {
    return 'Failed to export PDF: $error';
  }

  @override
  String batchResultPageCount(int count) {
    return '$count pages scanned';
  }

  @override
  String get batchResultExportPdfBtn => 'Export & Share PDF';

  @override
  String get scanResultCopied => 'Copied!';

  @override
  String get scanResultCopyText => 'Copy Text';

  @override
  String get scanResultTapToZoom => 'Tap to zoom';

  @override
  String get scanResultExtractedText => 'Extracted Text';

  @override
  String scanResultWordCharCount(int words, int chars) {
    return '$words words · $chars chars';
  }

  @override
  String get scanResultPlainText => 'Plain Text';

  @override
  String get scanResultVisualLayout => 'Visual Layout';

  @override
  String get scanResultAiScan => 'AI Scan';

  @override
  String get scanResultHideBoxes => 'Hide';

  @override
  String get scanResultShowBoxes => 'Show';

  @override
  String get scanResultNoTextFound => 'No text detected';

  @override
  String get scanResultTryClearerImage => 'Try scanning a clearer image';

  @override
  String get scannerGalleryBtn => 'Gallery';

  @override
  String get scannerInstructionQr => 'Point at QR / Barcode';

  @override
  String get scannerInstructionId => 'Align ID card';

  @override
  String get scannerInstructionBatch => 'Scan pages one by one';

  @override
  String get scannerInstructionDoc => 'Align document in bounds';

  @override
  String get homeGreetingMorning => 'Good morning ☀️';

  @override
  String get homeGreetingAfternoon => 'Good afternoon 🌤️';

  @override
  String get homeGreetingEvening => 'Good evening 🌙';

  @override
  String get homeTotalScans => 'Total Scans';

  @override
  String get homeThisWeekScans => 'Scans this week';

  @override
  String get homeWordsExtracted => 'Words extracted';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeQuickScanDoc => 'Scan\nDocument';

  @override
  String get homeQuickScanDocDesc => 'Extract from image';

  @override
  String get homeQuickScanId => 'Scan\nQR Code';

  @override
  String get homeQuickScanIdDesc => 'Extract card info';

  @override
  String get homeQuickScanBatch => 'Scan\n& Export';

  @override
  String get homeQuickScanBatchDesc => 'Create PDF';

  @override
  String get homeQuickGenerateQr => 'My\nQR Code';

  @override
  String get homeQuickGenerateQrDesc => 'Create and share';

  @override
  String get homeRecentHistory => 'Recent Scans';

  @override
  String get homeEmptyStateTitle => 'No scans yet';

  @override
  String get homeEmptyStateSubtitle =>
      'Your scanned documents will appear here.\nTap Scan to start!';

  @override
  String get homeHeroBtn => 'Start Scanning';

  @override
  String get homeHeroDesc => 'Digitize documents instantly with AI';

  @override
  String get homeStatsScannedDocs => 'Documents scanned';

  @override
  String get homeStatsScannedQr => 'QR Codes scanned';

  @override
  String get homeStatsSaved => 'Saved';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabSetting => 'Setting';

  @override
  String get homeTabQr => 'QR Library';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get visibilityMode => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get generateQrReminderName => 'Reminder Name';

  @override
  String get generateQrReminderNameHint => 'E.g.: Facebook, Phone number...';

  @override
  String get generateQrContent => 'Content';

  @override
  String get qrLibraryNoQrCodesSavedYet => 'No QR codes saved yet.';

  @override
  String get untitledQr => 'Untitled QR';

  @override
  String get deleteQrCode => 'Delete QR Code';

  @override
  String get deleteQrCodeConfirm =>
      'Are you sure you want to delete this QR code?';

  @override
  String get deleteQrCodeCancel => 'Cancel';

  @override
  String get deleteQrCodeDelete => 'Delete';

  @override
  String qrDetailId(String id) {
    return 'ID: $id';
  }

  @override
  String get qrDetailContentLabel => 'Content';

  @override
  String get shareImage => 'Share Image';
}
