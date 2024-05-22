**IWasHere**

IWasHere is an iOS application designed to capture and share photos with embedded geolocation data. The app allows users to document their travels by taking pictures that are automatically tagged with their current location. Users can view their photos on an interactive globe map and share their experiences with friends.

**Features**

Custom Camera Interface: Capture high-quality photos using AVFoundation.
Real-Time Geolocation: Embed geolocation data into photos using CoreLocation.
Cloud Storage: Store photos and metadata in Firebase Firestore and Firebase Storage.
Metadata Serialization: Efficiently manage photo metadata using Protocol Buffers (SwiftProtobuf).
Interactive Map: View photos on an interactive globe map using the Maps SDK.
Asynchronous Data Handling: Utilize the Combine framework for smooth and efficient data uploading and downloading.

**Technologies Used**

**Swift**: Programming language used for development.

**SwiftUI**: Framework for building the user interface.

**UIKit**: Framework for managing the app’s interface.

**Combine**: Framework for handling asynchronous operations.

**AVFoundation**: Framework for working with audiovisual media.

**CoreLocation**: Framework for obtaining the user’s location.

**Firebase Firestore**: NoSQL cloud database for storing photo metadata.

**Firebase Storag**e: Cloud storage for storing photos.

**SwiftProtobuf**: Library for Protocol Buffers support in Swift.

**Maps SDK**: SDK for integrating interactive maps.

**Usage**

Capture a Photo: Launch the app, and the camera interface will appear. Press the shutter button to take a photo.
View and Upload: After capturing a photo, preview it. Add notes and upload the photo to Firebase.
View on Map: Swipe right to access the interactive globe map and view photos with their geolocation tags.

**Contact**

For any inquiries or issues, please open an issue on GitHub or contact the project maintainer:

Name: Matthew Zierl
Email: matthewtzierl@gmail.com

