import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFormFieldState extends FormFieldState<String> {
  FakeFormFieldState(String value) {
    setValue(value);
  }
}

void main() {
  group('Validators', () {
    test('tryPhone', () {
      final validator = Validators.tryPhone();

      expect(validator(""), isNotNull);
      expect(validator("080651752831"), isNotNull);
      expect(validator("0107095394"), isNotNull);
      expect(validator("0807095394"), isNotNull);
      expect(validator("0907095394"), isNotNull);
      expect(validator("0607095394"), isNotNull);
      expect(validator("0707095394"), isNotNull);
      expect(validator("027095394"), isNotNull);
      expect(validator("037095394"), isNotNull);
      expect(validator("00165175283"), isNotNull);
      expect(validator("01165175283"), isNotNull);
      expect(validator("06065175283"), isNotNull);
      expect(validator("06065a75283"), isNotNull);
      expect(validator("18065275283"), isNotNull);
      expect(validator("90652752831"), isNotNull);
      expect(validator("9065275283"), isNotNull);
      expect(validator("8065275283"), isNotNull);
      expect(validator("7065275283"), isNotNull);

      expect(validator("017095394"), isNull);
      expect(validator("07065175283"), isNull);
      expect(validator("07165175283"), isNull);
      expect(validator("08065175283"), isNull);
      expect(validator("08165175283"), isNull);
      expect(validator("09065175283"), isNull);
      expect(validator("09165175283"), isNull);
    });

    test('tryList', () {
      final validator = Validators.tryList();

      expect(validator(null), isNotNull);
      expect(validator(<dynamic>[]), isNotNull);

      expect(validator(<dynamic>[""]), isNull);
    });

    test('tryEmail', () {
      final validator = Validators.tryEmail();

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("e.3"), isNotNull);
      expect(validator("1.3"), isNotNull);

      expect(validator("j@g.m"), isNull);
    });

    test('tryDiffPassword', () {
      const password = "value";
      final validator = Validators.tryDiffPassword(FakeFormFieldState(password));

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("e.3"), isNotNull);
      expect(validator("1.3"), isNotNull);

      expect(validator(password), isNull);
    });

    test('tryDouble', () {
      final validator = Validators.tryDouble();

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("e.3"), isNotNull);

      expect(validator("1.3"), isNull);
      expect(validator("0107095394"), isNull);
    });

    test('tryInt', () {
      final validator = Validators.tryInt();

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("1.3"), isNotNull);
      expect(validator("e.3"), isNotNull);

      expect(validator("13"), isNull);
      expect(validator("0107095394"), isNull);
    });

    test('tryPassword', () {
      final validator = Validators.tryPassword();

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("13"), isNotNull);
      expect(validator("0107095394"), isNull);

      expect(validator("10000..30"), isNull);
      expect(validator("10,000.30"), isNull);
      expect(validator("stalin"), isNotNull);
      expect(validator("pallindrome"), isNull);
      expect(validator("passme"), isNotNull);
      expect(validator("p4ssme"), isNotNull);
      expect(validator("passm3"), isNotNull);
      expect(validator("p4ssword"), isNull);
      expect(validator("passw0rd"), isNull);
    });

    group('tryLength', () {
      test('minimum', () {
        final validator = Validators.tryLength(min: 3);

        expect(validator("    "), isNotNull);
        expect(validator("0"), isNotNull);

        expect(validator("111"), isNull);
        expect(validator("1111"), isNull);
        expect(validator("34 45"), isNull);
      });

      test('maximum', () {
        final validator = Validators.tryLength(max: 3);

        expect(validator("ytieire"), isNotNull);
        expect(validator(""), isNotNull);

        expect(validator("pas"), isNull);
        expect(validator("pa"), isNull);
      });
    });

    group('tryDate', () {
      test('minimum', () {
        final validator = Validators.tryDate(min: DateTime(2000));

        expect(validator(null), isNotNull);
        expect(validator(DateTime(2034)), isNotNull);

        expect(validator(DateTime(2000)), isNull);
        expect(validator(DateTime(1999)), isNull);
      });

      test('maximum', () {
        final validator = Validators.tryDate(max: DateTime(2050));

        expect(validator(null), isNotNull);
        expect(validator(DateTime(2051)), isNull);

        expect(validator(DateTime(2050)), isNull);
        expect(validator(DateTime(1999)), isNotNull);
      });
    });

    test('tryAmount', () {
      final validator = Validators.tryAmount();

      expect(validator(""), isNotNull);
      expect(validator("0"), isNotNull);
      expect(validator("10000..30"), isNotNull);
      expect(validator("10,000.30"), isNotNull);
      expect(validator("e.3"), isNotNull);

      expect(validator("1.3"), isNull);
      expect(validator("0107095394"), isNull);
      expect(validator("1.30"), isNull);
      expect(validator("10000.30"), isNull);
      expect(validator("13"), isNull);
    });
  });
}
