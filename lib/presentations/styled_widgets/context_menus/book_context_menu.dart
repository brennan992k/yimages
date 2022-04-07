import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:yimages/commands/app/copy_share_link_command.dart';
import 'package:yimages/commands/books/delete_book_command.dart';
import 'package:yimages/commands/books/set_current_book_command.dart';
import 'package:yimages/core_packages.dart';
import 'package:yimages/data/book_data.dart';
import 'package:yimages/presentations/styled_widgets/context_menus/context_menu_widgets.dart';

class BookContextMenu extends StatefulWidget {
  const BookContextMenu(this.book, {Key? key}) : super(key: key);
  final ScrapBookData book;

  @override
  _BookContextMenuState createState() => _BookContextMenuState();
}

class _BookContextMenuState extends State<BookContextMenu>
    with ContextMenuStateMixin {
  void _handleViewPressed(BuildContext context) =>
      SetCurrentBookCommand().run(widget.book);

  void _handleSharePressed() =>
      CopyShareLinkCommand().run(widget.book.documentId);

  void _handleDeletePressed() {
    DeleteBookCommand().run(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return cardBuilder(
      context,
      [
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "View",
            icon: const ContextMenuIcon(icon: AppIcons.view),
            iconHover: const ContextMenuIconHovered(icon: AppIcons.view),
            onPressed: () =>
                handlePressed(context, () => _handleViewPressed(context)),
          ),
        ),
        buildDivider(),
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "Share",
            icon: const ContextMenuIcon(icon: AppIcons.share),
            iconHover: const ContextMenuIconHovered(icon: AppIcons.share),
            onPressed: () =>
                handlePressed(context, () => _handleSharePressed()),
          ),
        ),
        buildDivider(),
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "Delete",
            icon: const ContextMenuIcon(icon: AppIcons.trashcan),
            iconHover: const ContextMenuIconHovered(icon: AppIcons.trashcan),
            onPressed: () =>
                handlePressed(context, () => _handleDeletePressed()),
          ),
          // Custom hover color for delete button
          context.contextMenuOverlay.buttonStyle
              .copyWith(hoverBgColor: theme.greyStrong),
        ),
      ],
    );
  }
}
