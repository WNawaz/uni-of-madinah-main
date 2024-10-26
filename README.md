# This work is related to our following funded project.

**Funded Project Title** 
A Trusted and Accessibility-Supported Islamic Knowledge Delivery Platform for Non-Arabic Speakers

**Research Team**
1.	Dr. Waqas Nawaz (Islamic University of Madinah) - PI
2.	Dr. Qaiser Abbas (Islamic University of Madinah) - CO-PI
3.	Dr. Abdallah Namoun (Islamic University of Madinah) - CO-PI
4.	Dr. Fazal Noor (Islamic University of Madinah) - CO-PI
5.	Dr. Toqeer Ali (Islamic University of Madinah) - CO-PI
6.	Dr. Fahad Alsisi (Islamic University of Madinah) - CO-PI
7.	Dr. Kifayat Ullah Khan (FAST-NU Islamabad, Pakistan | Birmingham City University, UK) - Consultant
8.	Mr. Rayan (MS Data science student at Islamic University of Madinah) – Student
9.	Mr. Zakariya (BS student at Islamic University of Madinah) - Student

**Acknowledgment Statement**
The authors extend their sincere gratitude to all those who contributed to this study, notably the Islamic University of Madinah, the National University of Computer and Emerging Sciences (FAST-NU), and Birmingham City University. The Deanship of Scientific Research at the Islamic University of Madinah, KSA, generously provided financial support for this research under the research groups (first) project no. 956.


# IslamQ Flutter App

## Overview

IslamQ is a Flutter application designed to provide comprehensive Islamic content to users. This document explains the code structure, design patterns, and key components used in the application.

## Project Structure

The project follows a well-organized structure to maintain code readability and scalability. Here’s an overview of the directory structure:

![image](https://github.com/grayhatdevelopers/uni-of-madinah/assets/113006875/3bf4844c-9862-4f1f-95a0-158b235f3801)

## Directory Explanation

services/: Contain the core logic for data operations, such as API calls etc.

presentation/ui/: Contains all UI-related code. Contains the different screens (views) of the app. Each screen has its own folder. 

## Example 

detail_screen/: Contains the DetailScreen view and its related components.

detail_screen/widgets/: Contains view-specific widgets for DetailScreen. Example: custom_container, title_section etc.

detail_screen/detail_screen.dart: Contains the UI code for the detail screen.

detail_screen/detail_screen_viewmodel.dart: Contains the view model for the detail screen, managing its business logic and state.

## Other views

Other view folders follow a similar structure.

main.dart: Entry point of the application.

## Design Patterns
### Stacked flutter framework
IslamQ utilizes the MVVM (Model-View-ViewModel) design pattern facilitated by the stacked package. This pattern helps separate business logic from UI code, making the app more maintainable and testable.

## Explanation of Components
### Views: 
Represent the UI of the application. Each view is a separate screen in the app, placed in the presentation/ui/ directory under its specific folder.

Example: detail_screen/detail_screen.dart, home_screen/home_screen.dart.

### ViewModels: 

Handle the business logic and state management for the views. Each view has a corresponding view model, placed within the specific view folder.

Example: detail_screen/detail_screen_viewmodel.dart, home_screen/home_screen_viewmodel.dart.

### Services: 

Contain the core logic for data operations, such as API calls etc. Services are placed in the services/ directory.

Example: ApiService, UserService etc.

### Common Widgets: 

Reusable UI components that can be used across different views. These widgets are placed in the lib/common_widgets/ directory.

Example: CustomButton, custom_button-for_login.dart etc.

## Example: Detail Screen and ViewModel

### DetailScreen:

Located at lib/presentation/ui/detail_screen/detail_screen.dart.

Contains the UI code for the detail screen.

Uses DetailScreenViewModel to interact with the business logic.

### DetailScreenViewModel:

Located at lib/presentation/ui/detail_screen/detail_screen_viewmodel.dart.

Extends BaseViewModel from the stacked package.

Contains logic for fetching data, handling user interactions, and updating the UI state.

### Detail Widgets:

Located in lib/presentation/ui/detail_screen/widgets/.

Contains UI components specific to the detail screen.

Example: title_section.dart.

## Navigation with GetX
IslamQ uses the GetX package for navigation. GetX provides a simple and efficient way to manage routes and navigation in the application.

### Navigation Example:
Get.to(NextView());

This command navigates to the NextView screen. Navigation logic is centralized and managed using GetX’s Get.to, Get.back, and other navigation methods.

## Dependency Injection

Dependency injection is managed using the stacked package, ensuring that services and other dependencies are easily accessible throughout the app.

dependency_injection.dart:

Configures dependency injection using Locator.

Registers services.
 
