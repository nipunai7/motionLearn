# Motion Learn
**Learn What you see**

Motion Learn is a Mobile Application that will help you to sharpen your dancing skills with the help of Machine Learning. I developed the app using flutter and currently fully compatible with android devices.
 
Creators can upload their training video via a gallery or live camera recording. Video will be uploaded to Firebase Storage and a link will be sent to the flask server hosted in Google Cloud Platform. Then a report CSV with motion in every frame will be saved and transported back to firebase.
 
Then users who register and log as clients can purchase tutorials according to their preference. After purchasing they can enter a training view. Using this view, they can follow the tutors' video while watching it. After completion user can review their video and submit to the server. Flask server will get both video and tutor's previously generated report from firebase. Then create a report same as the tutors' report and compares the values for each frame. Users can see their progress in each attempt as they view the finalized report page within the app.
 
Flask API is hosted in a Google Cloud Platform as a daemon. It will start at each system reboot (on run levels 3+) to keep maximum availability.
  
**Main Technologies used,**
 
- Firebase (Firestore, Storage, Authentication)
- Python (MediaPipe, NumPy, Pandas, Firebase admin SDK, Open-CV, Matplotlib, Flask, FPDF)
- Google Cloud Platform (Ubuntu 20.04 LTS - 4vCPU, 4GB RAM)
- Flutter

**Features List**
- [x] Register User
- [x] Purchase tutorials
- [x] Rate tutorials
- [x] Enter training view
- [x] Set mobile phone placement before start training
- [x] View user video before submitting
- [x] Get comprehensive reports after submiting
- [x] Admin dashboard
- [x] Admin Income, Top clients, Trending tutorials reports
