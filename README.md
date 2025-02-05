# ember_trips

# Trip Information App

<img src="https://github.com/user-attachments/assets/8878a2e5-26d5-44c8-849a-5ce1d2691503" width="300">
<img src="https://github.com/user-attachments/assets/2a9ce454-0a22-4b34-ac4c-a0a06c6afffa" width="300">

## Video Demo
Please have a look at the video demo first: [Google Drive Link here](https://drive.google.com/file/d/1dB48hSgw-FcKqfXx25IbYC3RCKsUL01t/view?usp=sharing)

---

## APK file
Please install the apk from: [Google Drive Link here](https://drive.google.com/file/d/1-DQ4vQytDtv2-KsV1qeCjZ164sxrsgTl/view?usp=sharing)

---

### Building the app
Inorder to build the app, you will have to add your   `GOOGLE_MAP_API_KEY` in constants.dart.

---

## How I Am Getting the Trip UID

1. **API Call to Fetch Quotes**  
   I start by making an API call to:  
   `GET https://api.ember.to/v1/quotes/?origin=13&destination=42&departure_date_from=[start of the next day in ISO8601]&departure_date_to=[end of the next day in ISO8601]`.

2. **Extract Trip UID**  
   Once the result is received, I extract the `trip_uid` of the first quote.

3. **Fetch Trip Details**  
   Using the `trip_uid`, I make another API call to:  

   `GET https://api.ember.to/v1/trips`.

---

## State Management
The app uses **GetX** for state management.

---

## Error Handling
For the scope of this project:
- If there is any error (client or server-side), the app will display an error message to the user.

---

## Why Only Departure Time Is Shown for Stops?
- The stops are very brief, and the departure and arrival times provided by the API are the same.  
- Therefore, it makes sense to only show the departure time.

---

## File Structure
The project follows a **feature-wise segregation** approach. Additionally, there is a `core` folder for common resources:
- **`core` folder**: Contains shared models, utilities, and widgets.
- **Feature-wise folders**: Each feature has its own dedicated folder for better organization.

---

## Summary
This app fetches trip information using the Ember API, displays relevant details, and handles errors gracefully. The codebase is organized feature-wise, with a shared `core` folder for common components.
