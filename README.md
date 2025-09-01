# Efrei Todo (collab-ready)
Lancer:
1) flutter pub get
2) flutter run

Par défaut: stockage local et auth locale.
Pour brancher Firebase plus tard, implémenter:
- lib/src/services/firebase/firebase_auth_service.dart
- lib/src/services/firebase/firebase_todo_repository.dart
Puis remplacer les Local* par Firebase* dans main.dart.
