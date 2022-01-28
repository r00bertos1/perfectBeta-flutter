# PerfectBeta - Flutter

<img src="https://i.imgur.com/aKSxfR5.png"  width="200px" alt="logo_perfectbeta"/>  

## Requirements

### Core
* [Flutter 2.8.0](https://docs.flutter.dev/get-started/install)
* [Android Studio >= 4.1.1](https://developer.android.com/studio)
* [Google Chrome 96.0.4664.110](https://www.google.com/intl/pl_pl/chrome/) (for web development)

### Optional
* [Docker](https://docs.docker.com/get-docker/) (for running application in a container)

### Packages
| Package  | Version |
| ------------- | ------------- |
| google_fonts  | `2.1.0`  |
| get  | `4.1.4`  |
| data_table_2  | `2.0.3`  |
| http  | `0.13.4`  |
| dio  | `4.0.4`  |
| flutter_secure_storage  | `5.0.2`  |
| jwt_decoder  | `2.0.1`  |
| flutter_easyloading  | `3.0.3`  |
| flutter_launcher_icons  | `0.9.2`  |
| cupertino_icons  | `1.0.2`  |
| cached_network_image  | `3.1.0`  |
| flutter_rating_bar  | `4.0.0`  |
| image_picker  | `0.8.4+4`  |
| image_picker_web  | `any`  |
| dropdown_below  | `1.0.3`  |
| intl_phone_number_input  | `0.7.0+2`  |
| carousel_slider  | `4.0.0`  |
| photo_view  | `0.13.0`  |
| rating_dialog  | `2.0.3`  |

## Installation and run

### 1. Clone repository

````
git clone https://github.com/r00bertos1/perfectBeta-flutter.git
````

### 2. Run flutter doctor to verify your flutter instalation

````
flutter doctor
````

### 3. Get dependencies from pubspec.yaml

````
flutter pub get
````

### 4. Run flutter application

````
flutter run lib/main.dart
````

## Mobile application
You can also download **perfectBeta.apk** file and install it on your mobile device

## Docker integration
You can run an application inside a Docker Container

### 1. Build the Container
Change Directories into the root project folder
Run the command 
````
docker build . -t <IMAGE_TAG>
````
where **<IMAGE_TAG>** is a name of an image

### 2. Run the Container
To run the container enter command
````
docker run -i -p 8080:<PORT> -td <IMAGE_TAG>
````
where **<PORT>** is a port specified inside *Dockerfile* and *server/server.sh*. Default port is **4040**

### 3. Access the App
App is now running on selected port. You can access is eg. by browser
  
## Help
[Flutter online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
