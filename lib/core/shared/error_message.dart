class ErrorMessage {
  static Map<String, String> errorMessages = {
    'Unauthenticated.': 'Votre session a expiré, veuillez-vous reconnecter',
    'NotFound': 'Veuillez réessayer s\'il vous plait',
    'notAuthorized': 'Vous n\'êtes pas autorisé à effectuer cette action',
    'noConnection':
        'Vous êtes hors connexion. Vérifiez votre connexion internet',
    'password': 'Le mot de passe doit comporter au moins 8 caractères',
    'The email has already been taken.': "L'email a déjà été pris",
    'noErrorMessage': 'Une erreur a eu lieu, veuillez réessayer.'
  };

  static determineMessageKey(String serverErrorMessage) {
    if (serverErrorMessage.contains('password')) {
      return 'password';
    }
    if (serverErrorMessage.contains('noConnection')) {
      return 'noConnection';
    }
    if (serverErrorMessage.contains('Unauthenticated')) {
      return 'Unauthenticated';
    }
    if (serverErrorMessage.contains('NotFound')) {
      return 'NotFound';
    }
    if (serverErrorMessage.contains('notAuthorized')) {
      return 'notAuthorized';
    }
    return 'noErrorMessage';
  }
}
