// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Khám Phá Âm Nhạc';

  @override
  String get onboardingTitle1 => 'Khám Phá Âm Nhạc';

  @override
  String get onboardingDesc1 =>
      'Duyệt qua các album hàng đầu trên iTunes và tìm nghệ sĩ yêu thích tiếp theo của bạn.';

  @override
  String get onboardingTitle2 => 'Lưu Yêu Thích';

  @override
  String get onboardingDesc2 =>
      'Đánh dấu các album bạn yêu thích và thưởng thức khi không có mạng.';

  @override
  String get onboardingTitle3 => 'Tìm Kiếm & Khám Phá';

  @override
  String get onboardingDesc3 =>
      'Tìm kiếm hàng triệu album và khám phá điều gì đó mới mỗi ngày.';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingGetStarted => 'Bắt đầu';

  @override
  String get homeTitle => 'Album Hàng Đầu';

  @override
  String get homeErrorMessage => 'Không thể tải album. Vui lòng thử lại.';

  @override
  String get homeRetry => 'Thử lại';

  @override
  String get detailTracksHeader => 'Danh sách bài hát';

  @override
  String get detailNoTracks => 'Không có bài hát nào.';

  @override
  String get detailSaved => 'Đã lưu vào Yêu thích';

  @override
  String get detailRemoved => 'Đã xóa khỏi Yêu thích';
}
