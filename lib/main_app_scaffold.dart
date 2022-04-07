import 'package:anchored_popups/anchored_popups.dart';
import 'package:flutter/material.dart';
import 'package:yimages/core/_widgets/decorated_container.dart';
import 'package:yimages/commands/commands.dart' as commands;
import 'package:yimages/core_packages.dart';
import 'package:yimages/data/models/app_model.dart';
import 'package:yimages/presentations/styled_widgets/context_menus/styled_context_menu_overlay.dart';
import 'package:yimages/presentations/views/app_title_bar/app_title_bar.dart';

/// Wraps the entire app, providing it with various helper classes and wrapper widgets.
class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold(
      {Key? key, required this.pageNavigator, required this.showAppBar})
      : super(key: key);
  final Widget pageNavigator;
  final bool showAppBar;

  @override
  _MainAppScaffoldState createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TextDirection textDirection =
        context.select((AppModel app) => app.textDirection);
    // Provide the appTheme directly to the tree, so views don't need to look it up on the model (less boilerplate for views)
    AppTheme appTheme = context.select((AppModel app) => app.theme);
    return Provider.value(
      value: appTheme,
      child: Directionality(
        textDirection: textDirection,
        child: Navigator(
          onPopPage: (_, __) => false,
          pages: [
            MaterialPage(
                // Right-click support
                child: StyledContextMenuOverlay(
              // Tooltip and popup panel support
              child: AnchoredPopups(
                child: Navigator(
                  onPopPage: (Route route, result) {
                    if (route.didPop(result)) return true;
                    return false;
                  },
                  pages: [
                    MaterialPage(
                        // Pop-over (tooltip) support
                        child: Builder(
                      builder: (BuildContext builderContext) {
                        /// User a builder to provide a context to the Command layer that can show dialogs, bottom sheets etc
                        commands.setContext(builderContext);
                        return _WindowBorder(
                          color: appTheme.greyStrong,
                          // Supply a top-level scaffold and SafeArea for all views
                          child: Scaffold(
                            backgroundColor: appTheme.surface1,
                            body: Stack(
                              clipBehavior: Clip.antiAlias,
                              children: [
                                SafeArea(
                                  // AppBar + Content
                                  child: Column(
                                    // This column has a reversed vertical direction, because we want the TitleBar to cast a shadow on the content below it.
                                    verticalDirection: VerticalDirection.up,
                                    children: [
                                      // Bottom content area
                                      Expanded(child: widget.pageNavigator),
                                      // Top-aligned TitleBar
                                      if (widget.showAppBar)
                                        const AppTitleBar(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _WindowBorder extends StatelessWidget {
  const _WindowBorder({Key? key, required this.child, required this.color})
      : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      DecoratedContainer(
          ignorePointer: true,
          borderColor: Colors.white.withOpacity(.1),
          borderWidth: 1),
    ]);
  }
}
