# myapp1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Steps to Add a New Page

1:Add the new page to lib/Views/Screens.
2:Import the new page in route_generator.dart.
3:Add a new case as case('path') in switch(settings.name) for the route.
4:If you want to transition from an existing page to the new page, write 
"Navigator.pushNamed(context,'path')"

lib
|-constants
|-models
|-routes
|-services
|-utils
|-view_models
|-views-screens
|-widgets