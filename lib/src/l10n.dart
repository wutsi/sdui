import 'package:flutter/cupertino.dart';

// Global variable containting all the localized string.
// Defaulted to `en`
SDUIL10n sduiL10 = const SDUIL10nEn();

@immutable
abstract class SDUIL10n {
  const SDUIL10n(
      {required this.error,
      required this.loading,
      required this.validationMalformedEmail,
      required this.validationMalformedURL,
      required this.validationMissingField,
      required this.validationInvalidNumber});

  final String error;
  final String loading;
  final String validationInvalidNumber;
  final String validationMalformedEmail;
  final String validationMalformedURL;
  final String validationMissingField;
}

@immutable
class SDUIL10nEn extends SDUIL10n {
  const SDUIL10nEn()
      : super(
          error: 'Error',
          loading: 'Loading...',
          validationInvalidNumber: 'The number not not valid',
          validationMalformedEmail: 'The email address in not valid',
          validationMalformedURL: 'The URL in not valid',
          validationMissingField: 'The field is missing',
        );
}

@immutable
class SDUIL10nFr extends SDUIL10n {
  const SDUIL10nFr()
      : super(
          error: 'Erreur',
          loading: 'Chargement...',
          validationInvalidNumber: "Le nombre n'est pas valide",
          validationMalformedEmail: "L'adresse e-mail n'est pas valide",
          validationMalformedURL: "L'URL n'est pas valide",
          validationMissingField: 'Le champ est manquant',
        );
}
