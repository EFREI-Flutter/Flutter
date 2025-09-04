# Efrei Todo (collab-ready, CI OK)
1) flutter pub get
2) flutter run
Pour activer Firebase plus tard, implémentez les classes dans lib/src/services/firebase et remplacez les Local* par Firebase* dans main.dart.

## Notes pour Dev 
Firebase branché (Auth + Firestore, règles OK, index OK).

J’expose 2 services via Provider :
IAuthService (login/logout/register/reset)
ITodoRepo (CRUD todos)

Usage front :
final auth = context.read<IAuthService>();
final repo = context.read<ITodoRepo>();
 
Pas besoin de toucher Firebase direct, tu consommes juste ces interfaces.
