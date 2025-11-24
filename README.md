# Efrei Todo (collab-ready, CI OK)
1) flutter pub get
2) flutter run
Pour activer Firebase plus tard, implémentez les classes dans lib/src/services/firebase et remplacez les Local* par Firebase* dans main.dart.

## Notes pour Dev B
- Votre code (interfaces + stores + modèles) est disponible sous `lib/features/**`.
- Les implémentations `AuthServiceAdapter` et `TodoRepositoryAdapter` délèguent aux services locaux existants.
- Pour brancher Firebase, implémentez vos propres services dans `lib/features/**` ou utilisez `lib/src/services/firebase/**` et remplacez l'injection dans `lib/main.dart` si vous souhaitez faire tourner l'app avec Firebase.
