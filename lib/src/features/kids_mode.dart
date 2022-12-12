import '../data/collections/collection_slice.dart';
import '../data/fields/sq_enum_field.dart';
import '../data/fields/sq_int_field.dart';
import '../data/fields/sq_timestamp_field.dart';
import '../data/user_settings.dart';

const dateOfBirthFieldName = 'Date of Birth';
const maturityLevelFieldName = 'Maturity Level';
const minUserAgeInYears = 3;

class SQDateOfBirthField extends SQTimestampField {
  SQDateOfBirthField()
      : super(dateOfBirthFieldName,
            lastDate: DateTime(DateTime.now().year - minUserAgeInYears));
}

class SQMaturityRatingField extends SQEnumField<int> {
  SQMaturityRatingField()
      : super(SQIntField(maturityLevelFieldName, defaultValue: 0),
            options: [0, 6, 9, 12, 14, 16, 18]);
}

class KidsModeFilter extends CollectionFilter {
  @override
  List<SQDoc> filter(List<SQDoc> docs) {
    final dateOfBirth = UserSettings()
            .getSetting<SQTimestamp>(dateOfBirthFieldName)
            ?.toDate() ??
        DateTime(1990);

    final userAge = DateTime.now().difference(dateOfBirth).inDays ~/ 365;

    return docs
        .where((doc) =>
            (doc.getValue<int>(maturityLevelFieldName) ?? 0) <= userAge)
        .toList();
  }
}

class KidsModeSlice extends CollectionSlice {
  KidsModeSlice(super.collection) : super(filter: KidsModeFilter());
}
