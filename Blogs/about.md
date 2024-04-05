# About

## Description

    Blog App - your ultimate platform for creating and managing personal blogs effortlessly. Seamlessly integrated with Firebase Firestore, our app ensures a secure and reliable environment for storing and organizing your blog content. With intuitive features and smooth navigation, expressing yourself has never been easier.
    
    Upon app launch, an anonymous user is generated in Firebase Auth, and access requires Face ID verification. Once verified, users are directed to the main blogs screen, featuring a bottom navigation bar with icons for home, adding a blog, and profile.

    At the top of the blogs screen, a search bar allows users to query titles, content, or author names, fetching precise results from Firebase Firestore. Below, a category section enables filtering blogs based on user-selected categories.

    Further down the screen, a list displays all blogs, each complete with a title, content, tags, and an edit button. Tapping the edit button summons a bottom sheet, providing options to modify or delete the blog.

    The add icon leads to the add blog screen, facilitating the addition of blogs via title input, content composition, category selection, and tag inclusion. Upon tapping the save button, a loading indicator appears until the blog is successfully saved to Firebase Firestore. Additionally, images uploaded with the blog are securely stored in Firebase Storage. Upon confirmation, users are alerted, and the blogs screen refreshes to display the newly added blog.

    Finally, tapping the profile icon navigates users to the profile screen, where they can input their username, email, phone number, and upload or update their profile picture. Pressing save ensures their information, including their profile picture, is securely stored in Firebase Firestore and Firebase Storage, respectively.

    In summary, this app offers a seamless and intuitive blogging experience, empowering users to explore, create, and manage their blogs effortlessly.

## Additional Features Implemented

1. **Bottom Navigation:**  
   The app includes a bottom navigation bar with icons for home, adding a blog, and profile. This provides users with easy access to the main features of the app.

2. **Add Blog:**  
   Users can create new blogs using the Add Blog feature. They can upload images, input titles and content, select categories, and add tags to enrich their blogs. Upon tapping the save button, a loading indicator appears until the blog is successfully saved to Firebase Firestore. Additionally, images uploaded with the blog are securely stored in Firebase Storage. Upon confirmation, users are alerted, and the blogs screen refreshes to display the newly added blog.

3. **Profile Management:**  
   The app allows users to manage their profiles by inputting their username, email, phone number, and uploading or updating their profile picture. Pressing save ensures their information, including their profile picture, is securely stored in Firebase Firestore and Firebase Storage, respectively.


## Firestore Security Policy

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read and write access to authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

## Firebase Storage Security Policy

rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow read and write access to authenticated users
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}

