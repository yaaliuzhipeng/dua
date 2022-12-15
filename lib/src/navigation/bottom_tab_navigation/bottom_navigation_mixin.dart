import '../../appstructure/broadcast.dart';

const String bottomNavigationEventName = 'BOT_NAVIGATION_EVENT';
mixin BottomNavigationMixin {
  void Function([bool? all])? off;
  void up({
    void Function(int page)? onChangeCurrentPage,
  }) {
    off = Broadcast.shared.addListener(bottomNavigationEventName, (data) {
      if (data['type'] == 'setCurrentPage') {
        var value = data['value'];
        if (onChangeCurrentPage != null) onChangeCurrentPage(value);
      }
    });
  }

  void down() {
    if (off != null) off!();
  }
}
