
# 📌 README.md — Application Flutter Todo List

# 📝 EFREI Todo — Application Flutter  
Application de gestion de tâches réalisée dans le cadre du module **Framework 1 (Flutter)** à l’EFREI.

Ce projet met en œuvre :

- Flutter & Material 3  
- State management avec **Provider**  
- Navigation avancée avec **GoRouter**  
- Thème **clair / sombre** persistant  
- CRUD complet des tâches  
- Authentification simple (login / logout)  
- UI moderne & responsive, incluant **NavigationRail**  

## ⚙️ Fonctionnalités principales

### 🔐 Authentification  
- Connexion  
- Déconnexion  
- Redirection automatique selon l’état utilisateur  

### ✅ Gestion des tâches  
- Ajouter une tâche  
- Modifier une tâche existante  
- Supprimer une tâche (Swipe → Dismissible)  
- Marquer une tâche comme terminée  
- Résumé du nombre total / restantes / terminées  
- Persistance locale ou via store  

### 🎨 Thème & UI  
- Thème clair / sombre  
- Sauvegarde du thème dans **SharedPreferences**  
- Design Material 3  
- UI moderne avec Cards, icônes, animations  
- Navigation **NavigationRail** sur toutes les pages  
- Mise en page responsive web/mobile  

## 🏗️ Architecture du projet

```
lib/
├─ features/
│   ├─ auth/
│   │   ├─ screens/
│   │   ├─ store/
│   │   └─ widgets/
│
├─ stores/
│   ├─ auth_store.dart
│   ├─ todo_store.dart
│   └─ theme_store.dart
│
├─ screens/
│   ├─ home.dart
│   ├─ todo_form.dart
│   └─ settings.dart
│
├─ widgets/
│   └─ navigation_rail.dart
│
├─ models/
│   └─ todo.dart
│
└─ main.dart
```

## 🚀 Lancer l’application

```sh
flutter pub get
flutter run
```

Pour le Web :

```sh
flutter run -d chrome
```

## 👥 Travail en équipe (3 développeurs)

### Dev A — Authentification  
- Login / logout  
- Gestion de l’état utilisateur  
- Redirection SignIn → Home  

### Dev B — Tâches  
- Modèle Todo  
- CRUD complet  
- Écran Home / Detail / Form  
- Fonction Toggle + Swipe Delete  

### Dev C — UI & Navigation  
- Thème clair / sombre  
- NavigationRail  
- Material 3  
- Refactor / cohérence visuelle

## 🧩 Points forts du projet
- NavigationRail moderne  
- UI Material 3  
- Architecture propre  
- Code maintenable

## 🏁 Conclusion  
Projet complet, moderne et structuré, respectant toutes les consignes EFREI.
