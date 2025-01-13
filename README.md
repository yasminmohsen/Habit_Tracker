# Habit_Tracker
This project is a habit-tracking application implemented using **MVVM Clean Architecture**, **SwiftUI**, **Modern Concurrency**, and **Firebase for authentication and data management**. Below is a detailed guide to understanding the app's workflow and features.

## Features
- **Login Flow**
    - Login using the test credentials:   
       **Email**: test@gmail.com  
       **Password**: 123456
   - Alternatively, register using any valid email and password **(Firebase Authentication is used for secure user management)**.
 
- **Home View**
   - Displays habits created for the current day only.
   - Allows users to add, edit, and delete habits efficiently.
     
- **Firebase Integration**
   - **Authentication**: Secure login and registration using Firebase Authentication.
   - **Database**: Habits are stored and managed on Firestore.
   
## Workflow
- **Login Flow**
    1. Launch the app and access the login screen.
    2. Enter the provided test credentials or register with a new email and password.
    3. Upon successful authentication, the app navigates to the Home View.

- **Home View**
   - **Adding a Habit**.  
     1. Tap the **plus (+)** button at the top of the screen.
     2. Enter the habit details and set its progress.
     3. The habit appears as a card in the **Home View**, showing
         - **Habit name**
         - **Progress**
         - **Edit button for further actions.**
   - **Editing a Habit:**.
      1. Tap the Edit button on a habit card.
      2. Update the habit's progress, mark it as completed, or delete it from the list.
     
## Setup Instructions
   1. Clone the repository to your local machine.
   2. Open the project in Xcode.
   3. Ensure you have the latest version of Xcode installed (supports SwiftUI and concurrency).
   4. Build and run the project on your simulator or device.



   



     
  
