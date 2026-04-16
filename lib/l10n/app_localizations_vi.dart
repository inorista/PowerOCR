// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get generateQrTitle => 'Tạo mã QR';

  @override
  String get generateQrPlaceholder => 'Nhập nội dung để\ntạo mã QR';

  @override
  String get generateQrInputHint => 'Nhập văn bản, link, số điện thoại...';

  @override
  String get generateQrColor => 'Màu sắc';

  @override
  String get generateQrEyeShape => 'Kiểu mắt';

  @override
  String get generateQrPattern => 'Hoạ tiết';

  @override
  String get generateQrBackground => 'Nền mã QR';

  @override
  String get generateQrShapeSquare => 'Vuông';

  @override
  String get generateQrShapeCircle => 'Tròn';

  @override
  String get generateQrBgWhite => 'Nền trắng';

  @override
  String get generateQrBgDark => 'Nền tối';

  @override
  String get generateQrColorSmoke => 'Khói';

  @override
  String get generateQrBtnShare => 'Lưu & chia sẻ mã QR';

  @override
  String get generateQrShareTitle => 'Mã QR của tôi';

  @override
  String generateQrShareError(String error) {
    return 'Lỗi khi chia sẻ QR: $error';
  }

  @override
  String get scanHistoryTitle => 'Lịch sử quét';

  @override
  String get scanHistoryLoading => 'Đang tải lịch sử...';

  @override
  String get scanHistoryEmptyTitle => 'Chưa có lịch sử';

  @override
  String get scanHistoryEmptySubtitle =>
      'Tài liệu đã quét sẽ xuất hiện\nở đây khi bạn bắt đầu quét.';

  @override
  String get scanHistoryErrorTitle => 'Tải thất bại';

  @override
  String get scanHistoryErrorMsg => 'Đã xảy ra lỗi';

  @override
  String get scanHistoryRetryBtn => 'Thử lại';

  @override
  String get timeJustNow => 'Vừa xong';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String get timeYesterday => 'Hôm qua';

  @override
  String timeDaysAgo(int days) {
    return '$days ngày trước';
  }

  @override
  String get historyNoTextExtracted => 'Không có văn bản được trích xuất';

  @override
  String get historyTypeDocument => 'Tài liệu';

  @override
  String get historyTypeQr => 'Mã QR';

  @override
  String historyWordCount(int words) {
    return '$words từ';
  }

  @override
  String get historySeeAll => 'Xem tất cả';

  @override
  String get scanFailed => 'Quét thất bại';

  @override
  String exportPdfFailed(String error) {
    return 'Xuất PDF thất bại: $error';
  }

  @override
  String batchResultPageCount(int count) {
    return '$count trang đã quét';
  }

  @override
  String get batchResultExportPdfBtn => 'Xuất & Chia sẻ PDF';

  @override
  String get scanResultCopied => 'Đã sao chép!';

  @override
  String get scanResultCopyText => 'Sao chép văn bản';

  @override
  String get scanResultTapToZoom => 'Tap để phóng to';

  @override
  String get scanResultExtractedText => 'Văn bản trích xuất';

  @override
  String scanResultWordCharCount(int words, int chars) {
    return '$words từ · $chars ký tự';
  }

  @override
  String get scanResultPlainText => 'Văn bản thuần';

  @override
  String get scanResultVisualLayout => 'Bố cục trực quan';

  @override
  String get scanResultAiScan => 'AI quét';

  @override
  String get scanResultHideBoxes => 'Ẩn';

  @override
  String get scanResultShowBoxes => 'Hiện';

  @override
  String get scanResultNoTextFound => 'Không phát hiện văn bản';

  @override
  String get scanResultTryClearerImage => 'Thử quét ảnh rõ hơn';

  @override
  String get scannerGalleryBtn => 'Thư viện';

  @override
  String get scannerInstructionQr => 'Hướng vào mã QR / barcode';

  @override
  String get scannerInstructionId => 'Căn chỉnh thẻ căn cước / CCCD';

  @override
  String get scannerInstructionBatch => 'Quét từng trang một';

  @override
  String get scannerInstructionDoc => 'Căn tài liệu vào khung';

  @override
  String get homeGreetingMorning => 'Chào buổi sáng ☀️';

  @override
  String get homeGreetingAfternoon => 'Chào buổi chiều 🌤️';

  @override
  String get homeGreetingEvening => 'Chào buổi tối 🌙';

  @override
  String get homeTotalScans => 'Tổng số lần quét';

  @override
  String get homeThisWeekScans => 'Lần quét tuần này';

  @override
  String get homeWordsExtracted => 'Từ đã trích xuất';

  @override
  String get homeQuickActions => 'Thao tác nhanh';

  @override
  String get homeQuickScanDoc => 'Quét\nTài liệu';

  @override
  String get homeQuickScanDocDesc => 'Trích xuất văn bản từ ảnh';

  @override
  String get homeQuickScanId => 'Quét\nMã QR';

  @override
  String get homeQuickScanIdDesc => 'Trích xuất thông tin thẻ';

  @override
  String get homeQuickScanBatch => 'Quét\n& Xuất file';

  @override
  String get homeQuickScanBatchDesc => 'Tạo PDF từ nhiều ảnh';

  @override
  String get homeQuickGenerateQr => 'Tạo mã\nQR cá nhân';

  @override
  String get homeQuickGenerateQrDesc => 'Tạo và chia sẻ QR';

  @override
  String get homeRecentHistory => 'Quét gần đây';

  @override
  String get homeEmptyStateTitle => 'Chưa có lượt quét nào';

  @override
  String get homeEmptyStateSubtitle =>
      'Tài liệu đã quét của bạn sẽ hiển thị tại đây.\nNhấn Quét để bắt đầu!';

  @override
  String get homeHeroBtn => 'Bắt đầu Quét';

  @override
  String get homeHeroDesc => 'Số hóa tài liệu ngay lập tức với AI';

  @override
  String get homeStatsScannedDocs => 'Tài liệu đã quét';

  @override
  String get homeStatsScannedQr => 'Mã QR đã quét';

  @override
  String get homeStatsSaved => 'Đã lưu';

  @override
  String get homeTabHome => 'Trang chủ';

  @override
  String get homeTabSetting => 'Cài đặt';

  @override
  String get homeTabQr => 'Kho QR';

  @override
  String get visibilityMode => 'Chế độ hiển thị';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get generateQrReminderName => 'Tên gợi nhớ';

  @override
  String get generateQrReminderNameHint =>
      'VD: Facebook cá nhân, Số điện thoại...';

  @override
  String get generateQrContent => 'Nội dung';

  @override
  String get qrLibraryNoQrCodesSavedYet => 'Chưa có mã QR nào được lưu.';

  @override
  String get untitledQr => 'QR chưa đặt tên';

  @override
  String get deleteQrCode => 'Xóa mã QR';

  @override
  String get deleteQrCodeConfirm => 'Bạn có chắc chắn muốn xóa mã QR này?';

  @override
  String get deleteQrCodeCancel => 'Hủy';

  @override
  String get deleteQrCodeDelete => 'Xóa';
}
