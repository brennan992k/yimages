import 'package:flutter/material.dart';
import 'package:yimages/core/_utils/data_utils.dart';
import 'package:yimages/core/_widgets/decorated_container.dart';
import 'package:yimages/commands/books/create_page_command.dart';
import 'package:yimages/commands/books/set_current_page_command.dart';
import 'package:yimages/core_packages.dart';
import 'package:yimages/data/book_data.dart';
import 'package:yimages/data/models/books_model.dart';
import 'package:yimages/presentations/views/editor_page/draggable_page_menu/draggable_page_menu.dart';

class CollapsiblePagesPanel extends StatefulWidget {
  const CollapsiblePagesPanel(this.pages, {Key? key, required this.height})
      : super(key: key);
  final List<ScrapPageData> pages;
  final double height;

  @override
  _CollapsiblePagesPanelState createState() => _CollapsiblePagesPanelState();
}

class _CollapsiblePagesPanelState extends State<CollapsiblePagesPanel> {
  ScrapBookData? _book;

  @override
  Widget build(BuildContext context) {
    /// State Bindings
    _book = context.select((BooksModel m) => m.currentBook);
    ScrapPageData? page = context.select((BooksModel m) => m.currentPage);

    /// Build
    List<ScrapPageData> list =
        DataUtils.sortListById((widget.pages), _book?.pageOrder);
    return CollapsingCard(
      title: "Pages (${list.length})",
      titleClosed: page?.title,
      icon: _RoundedBtn(onPressed: _handleAddPressed),
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: list.isEmpty || page == null
                ? _EmptyView()
                : DraggablePagesMenu(
                    pageId: page.documentId,
                    pages: list,
                    onPressed: _handlePagePressed,
                  ),
          ),
        ],
      ),
    );
  }

  /// Handlers
  void _handleAddPressed() => CreatePageCommand().run();

  void _handlePagePressed(ScrapPageData e) => SetCurrentPageCommand().run(e);
}

class _RoundedBtn extends StatelessWidget {
  const _RoundedBtn({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return SimpleBtn(
        onPressed: onPressed,
        ignoreDensity: false,
        child: SizedBox(
          width: 30,
          height: 30,
          child: DecoratedContainer(
            color: theme.accent1,
            borderRadius: 99,
            child: MaterialIcon(Icons.add, color: theme.bg1, size: 16),
          ),
        ));
  }
}

class _EmptyView extends StatefulWidget {
  @override
  __EmptyViewState createState() => __EmptyViewState();
}

class __EmptyViewState extends State<_EmptyView> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: EdgeInsets.all(Insets.med).copyWith(top: Insets.xl),
      child: Text(
        "Create your first page by pressing the ??? button.",
        textAlign: TextAlign.center,
        style:
            TextStyles.callout1.copyWith(color: theme.greyMedium, height: 1.5),
      ),
    );
  }
}
