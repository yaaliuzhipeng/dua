import 'dart:math';

import 'dua_navigation_focus_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../page/default_unknown_page.dart';
import './dua_back_handler.dart';

class DuaNavigationRoute {
  DuaNavigationRoute({
    required this.name,
    String? key,
    this.params,
  }) {
    this.key = key ?? "name-${DateTime.now().millisecondsSinceEpoch}";
  }

  late String key;
  String name;
  Object? params;
}

class DuaNavigationState {
  DuaNavigationState({
    List<DuaNavigationRoute>? routes,
    int? index,
    this.result,
  }) {
    this.routes = routes ?? [];
    this.index = index ?? 0;
  }

  late List<DuaNavigationRoute> routes;
  late int index;
  Object? result;

  List<String> get routeNames => List.unmodifiable(routes.map((e) => e.name));
}

class DuaStackNavigationPage {
  DuaStackNavigationPage(this.name, this.page);

  final String name;
  final Page page;
}

typedef NavigationResetCallack = List<DuaNavigationRoute> Function(List<DuaNavigationRoute> currentRoutes);

class DuaStackNavigationDelegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin, ChangeNotifier, DuaNavigationFocusEmitterMixin, WidgetsBindingObserver {
  DuaStackNavigationDelegate({
    this.onUnknownRoute,
    this.observers = const [],
    this.initialPage,
    required this.pages,
  }) : assert(pages.isNotEmpty, "navigation pages cannot be empty!") {
    constructPageIndex();
    debugPrint("=============== DuaStackNavigationDelegate contructing ===============");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver> observers;
  final String? initialPage;
  final List<DuaStackNavigationPage> pages;
  final Map<String, DuaStackNavigationPage> pagesIndex = {};

  String get _initialPage => initialPage ?? (pages.isEmpty ? '/' : pages.first.name);

  bool isInitialPage(String page) {
    return page == _initialPage || page == '/';
  }

  void constructPageIndex() {
    for (var p in pages) {
      pagesIndex[p.name] = p;
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  static DuaStackNavigationDelegate of(BuildContext context) {
    var routerDelegate = Router.of(context).routerDelegate;
    return routerDelegate as DuaStackNavigationDelegate;
  }

  /// ?????????????????????????????????????????????
  /// navigate[forResult]??????true???????????? ????????????????????????name
  /// ???goBack????????????????????????????????????navigatedForResultRoute?????????????????????state??????????????????result??????
  String? navigatedForResultRoute;
  final DuaNavigationState state = DuaNavigationState(
    routes: [],
    index: 0,
    result: null,
  );

  List get stack => List.unmodifiable(state.routeNames);

  @override
  String? get currentConfiguration => stack.isEmpty ? null : stack.last;

  @override
  Widget build(BuildContext context) {
    List<Page> pages = [];

    /// stack ?????????????????? setNewRoutePath???????????????????????????????????????????????????????????????????????? name
    /// ?????????????????????????????? '/' ??????
    for (var s in stack) {
      var p = pagesIndex[s];
      assert(p != null, "route named ${s} is not found in the pages");
      pages.add(p!.page);
    }
    dispatchFocus(stack.last);
    return Navigator(
      pages: pages,
      onPopPage: _onPopPage,
      observers: observers,
      onUnknownRoute: onUnknownRoute ?? buildDefaultUnknownRouteFactory,
    );
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    state.routes
      ..clear()
      ..add(DuaNavigationRoute(name: configuration == '/' ? _initialPage : configuration));
    return SynchronousFuture<void>(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notifyListeners();
    }
    super.didChangeAppLifecycleState(state);
  }

  bool _onPopPage(Route<dynamic> route, result) {
    if (stack.isNotEmpty && route.settings.name == stack.last) {
      state.routes.removeLast();
    }
    return route.didPop(result);
  }

  Future<bool> _didPopRoute() {
    // true??????????????????Handle
    // false???????????????Handle??????????????????
    if (stack.length > 1) {
      goBack();
      return SynchronousFuture(true);
    }
    return SynchronousFuture(false);
  }

  /// ??????????????????????????????
  ///
  /// ???????????????navigate??????????????? push
  void navigate(String name, {Object? params, bool? forResult}) {
    var route = DuaNavigationRoute(name: name, params: params);
    if (forResult ?? false) {
      navigatedForResultRoute = route.key;
    }
    state.routes.add(route);
    state.index = max(state.routes.length - 1, 0);
    notifyListeners();
  }

  /// ??????????????? pop?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
  void goBack({String? name, Object? result}) {
    if (name == null) {
      if (stack.isNotEmpty) {
        state.routes.removeLast();
      }
    } else {
      int index = stack.lastIndexOf(name);
      if (index == -1) return;
      state.routes.removeRange(index + 1, state.routes.length);
    }
    state.index = max(state.routes.length - 1, 0);
    if (result != null && state.routes.last.key == navigatedForResultRoute) {
      state.result = result;
    }
    notifyListeners();
  }

  /// reset
  /// ????????????????????????state?????????????????????????????????????????????????????????????????????
  void reset(NavigationResetCallack callack) {
    var routes = callack(state.routes);
    state.routes = routes;
    state.index = max(routes.length - 1, 0);
    notifyListeners();
  }

  Object? getRouteParams(String key) {
    int index = state.routes.lastIndexWhere((element) => element.key == key);
    if (index != -1) {
      return state.routes[index].params;
    }
    return null;
  }

  Object? getRouteResult(String key) {
    if (state.routes.isNotEmpty && state.routes.last.key == key) {
      return state.result;
    }
    return null;
  }
}

class DuaBackButtonDispatcher extends RootBackButtonDispatcher {
  DuaBackButtonDispatcher(this.delegate);

  final DuaStackNavigationDelegate delegate;

  @override
  Future<bool> didPopRoute() async {
    if (DuaBackHandler.shared.invoker != null) {
      bool handled = await DuaBackHandler.shared.invoker!();
      if (handled) {
        return true;
      } // else ?????? delegate????????????
    }
    return delegate._didPopRoute();
  }
}
