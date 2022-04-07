import 'package:yimages/core/_utils/time_utils.dart';
import 'package:yimages/commands/commands.dart';
import 'package:yimages/data/book_data.dart';

class UpdateBookCommand extends BaseAppCommand {
  Future<void> run(ScrapBookData book) async {
    booksModel.replaceBook(book);
    await firebase.setBook(book.copyWith(
      lastModifiedTime: TimeUtils.nowMillis,
    ));
  }
}
