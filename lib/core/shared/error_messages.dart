class ErrorMessages {
  static String errorMessages(String key) {
    var stuff = Map.from({
      "Unauthenticated.": "Votre session a expiré, veuillez vous reconnecter.",
      "name_required": "Le nom de l'établissement est obligatoire",
      "name_string": "Veuillez réesayer avec un nom approprié",
      "name_max":
          "Le nom de l'etablissement ne doit pas etre superieur a 225 caracteres",
      "email_required": "L'adresse email est obiligatoire",
      "email_email": "Veuillez entrer une adresse email valide",
      "email_max":
          "L'adresse email de l'etablissementne doit pas etre superieur a 225 caracteres",
      "email_exists":
          "Cette email ne correspond a aucun compte dans notre base de données",
      "email_unique": "L'adresse email est deja utilisée.",
      "mobile_required": "Le numéro de telephone est obiligatoire",
      "mobile_regex": "Veuillez entrer un numéro de telephone valide",
      "code_required": "Le code de OTP est obligatoire",
      "code_string": "Veuillez entrer une code OTP valide",
      "code_exists": "Le code entré n'est plus valide",
      "password_required": "Le mot de passe est obligatoire",
      "password_string": "Veuillez entré un mot de passe valide",
      "password_min": "Le mot de passe doit comporter minimum 8 carateres",
      "password_confirmed": "Les mots de passe ne correspondent pas",
      "password.reset": "Le code a été envoyé avec succes",
      "invalid_credentials":
          "Le mot de passe ne correspond pas au compte utilisateur ou le compte n'existe pas. Veuillez vérifier le nom d'utilisateur et le mot de passe et réessayer."
    });
    return stuff[key];
  }
}
