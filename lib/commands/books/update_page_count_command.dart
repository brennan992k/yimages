import 'dart:math';

import 'package:yimages/core/_utils/time_utils.dart';
import 'package:yimages/commands/books/update_book_modified_command.dart';
import 'package:yimages/commands/commands.dart';
import 'package:yimages/data/book_data.dart';

class UpdatePageCountCommand extends BaseAppCommand {
  Future<int> run(int value, {ScrapBookData? book}) async {
    book ??= booksModel.currentBook;
    assert(book != null, "UpdatePageCountCommand was called but there is no current book.");
    if (book != null) {
      value = max(0, value);
      ScrapBookData newBook = book.copyWith(
        lastModifiedTime: TimeUtils.nowMillis,
        pageCount: value,
      );
      booksModel.replaceBook(newBook);
      await firebase.setBook(newBook);
      UpdateBookModifiedCommand().run(book: newBook);
    }
    return value;
  }

  Future<int> incrementCurrent() async {
    ScrapBookData? book = booksModel.currentBook;
    if (book == null) return 0;
    return await run(book.pageCount + 1, book: book);
  }

  Future<int> decrementCurrent() async {
    ScrapBookData? book = booksModel.currentBook;
    if (book == null) return 0;
    return await run(book.pageCount - 1, book: book);
  }
}
