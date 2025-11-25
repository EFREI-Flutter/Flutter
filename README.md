# 📝 EFREI Todo — Application Flutter

Application Flutter complète réalisée dans le cadre du module  
**Framework 1 (Flutter)** de l’EFREI.

---

## ✨ Fonctionnalités

### 🔐 Authentification (Firebase Auth)
- Création de compte  
- Connexion  
- Déconnexion  
- Reset password  
- Redirection automatique selon l’état utilisateur  

### 🗒️ Gestion des tâches (Local store)
- Ajouter une tâche  
- Modifier une tâche  
- Supprimer une tâche  
- Marquer comme terminée  
- Affichage des notes  
- Dismissible pour supprimer rapidement  

### 🎨 Thème & UI
- Thème clair / sombre  
- Persisté avec **SharedPreferences**  
- Material 3 / UI moderne  
- NavigationRail sur toutes les pages  
- Pages responsive web + mobile  

### 🌐 GoRouter (Navigation)
- Navigation déclarative  
- Routes propres  
- Redirections selon authentication state  

---

## 🏗️ Architecture du projet

```
lib/
├─ features/
│   ├─ auth/
│   │   ├─ models/
│   │   ├─ services/
│   │   ├─ store/
│   │   └─ écrans sign_in, sign_up, reset_password
│   ├─ todo/
│       ├─ models/
│       ├─ services/
│       └─ store/
│
├─ src/
│   ├─ screens/
│   │   ├─ home.dart
│   │   ├─ todo_form.dart
│   │   ├─ settings.dart
│   │   ├─ sign_in.dart
│   │   ├─ sign_up.dart
│   │   └─ reset_password.dart
│   ├─ services/
│   │   ├─ firebase/
│   │   ├─ interfaces/
│   │   └─ local/
│   ├─ stores/
│   │   ├─ theme_store.dart
│   │   └─ todo_store.dart
│   └─ widgets/
│       ├─ app_nav.dart
│       ├─ errors.dart
│       └─ models.dart
│
├─ firebase_options.dart
├─ main.dart
│
test/
integration_test/
web/
```

---

## 🔧 Technologies utilisées

| Fonction | Tech utilisée |
|---------|---------------|
| Authentification | Firebase Auth |
| Stockage local des tâches | Store local custom |
| Gestion d'état | Provider + ChangeNotifier |
| Navigation | GoRouter |
| Persistance thème | SharedPreferences |
| UI | Material 3 |
| Responsive | NavigationRail + mise en page web/mobile |

---

## 🚀 Lancer l’application

```sh
flutter pub get
flutter run
```

Pour le Web :

```sh
flutter run -d chrome
```

---

## 👥 Travail en équipe (3 développeurs)

### Dev A — Authentification  
- Auth Firebase  
- Pages sign_in, sign_up, reset_password  
- store auth  
- Redirections connexion/déconnexion  

### Dev B — Tâches  
- Modèle Todo  
- todo_store (CRUD)  
- home.dart + todo_form.dart  
- Toggle done + suppression Dismissible  

### Dev C — UI / Thème / Navigation  
- Material 3  
- Thème clair/sombre persistant  
- SharedPreferences  
- NavigationRail partout  
- GoRouter + cohérence design  
