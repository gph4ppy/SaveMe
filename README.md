![SaveMe](https://user-images.githubusercontent.com/41966757/111616165-de2fd480-87e1-11eb-8197-e393b8cab8f7.png)

SaveMe is an application aimed at people who would like to get to know themselves better. Many people ask themselves: "Why do I feel like this?", "How can I deal with it?". 

Keeping a physical diary is difficult, and there is no guarantee that someone will not read the journal in which the data is unprotected. Thanks to this application, everyone can monitor their feelings, see what causes them, get to know themselves, and make self-development.

# The application has such features as
- **Mood Checker**
Monitor your feelings. Thanks to this option, you will find out in which situations you feel bad and in which you feel good. This is important because you will get to know the mechanisms of your psyche and understand what to avoid and what to do to be happier.

![Mood Checker](https://user-images.githubusercontent.com/41966757/111545046-bc990380-8775-11eb-82e9-360e8e65ae88.png)
<img src="https://user-images.githubusercontent.com/41966757/111545046-bc990380-8775-11eb-82e9-360e8e65ae88.png" width="50%" />

- **Diary**
Keeping a diary is difficult, but not with SaveMe! Your cards will be with you whenever you have your phone. You don't have to worry about the pen and the fact that someone will notice that you are writing something in your notebook. An immediate diary entry will ensure that your feelings are relevant to the moment, allowing you to understand the situation later.

![Diary](https://user-images.githubusercontent.com/41966757/111545360-3af5a580-8776-11eb-970f-a51c050751dc.png)

- **Positive Cards**
These are the cards that you create. You write something good about yourself that is worth remembering in difficult situations. Sometimes it's hard to think under the influence of emotions, so reach for cards that will remind you of what you need in a such moment. They will also help you work on your self-esteem.

![Positive Cards](https://user-images.githubusercontent.com/41966757/111545576-90ca4d80-8776-11eb-85bc-ceba4fdc0b38.png)

- **Dreamcatcher**
Dreamcatcher is a feature that will help you remember your dreams. It is worth analyzing them because they may make more sense than you might imagine.

![Dreamcatcher](https://user-images.githubusercontent.com/41966757/111598583-aae44a00-87cf-11eb-8d74-66ad1830796e.png)

- **Feelings - why do I feel like that?**
This option will allow you to define what and why you feel. Choose between positive or negative emotions and answer the questions in the editor. This way you will find out exactly what you feel, why you feel it, what led to it, and what you can do in this situation. These questions guide you to think about what is best for you (and/or your loved ones).

![Feelings](https://user-images.githubusercontent.com/41966757/111598776-d9622500-87cf-11eb-9503-9f26f3244210.png)

- **Positive Things**
Something good happens to us every day. Sometimes we don't see these things, which makes our lives seem gray and sad. It's all caused by the fact that we don't pay attention to the good that has happened to us. This feature will allow you to remember all that is good, making your life more enjoyable.

![Positive Things](https://user-images.githubusercontent.com/41966757/111598895-f991e400-87cf-11eb-96e8-7db822df966b.png)

# Settings
- Tap on the current name to change it.
- Tap on the profile picture to upload a new one.
- You can change the accent color, thanks to which you will have beautiful colors of calendars and buttons.
- You can switch app language to Polish and English (works only on the simulator - probably because it isn't released on AppStore, which gives you personalized options for the app).
- You can switch the whole app to dark mode with one tap.
- Turn on notifications, which will remind you to check your frame of mind.
- If you want, you can see in formations about the app. 

![Settings](https://user-images.githubusercontent.com/41966757/111617624-a590fa80-87e3-11eb-8885-13ab4fa59fa1.png)

# Tech
- SwiftUI
- Core Data
- UserDefaults

# Bugs
- Sometimes the dark mode doesn't change when the application is launched for the first time. After changing the value of the Dark Mode switch, there is a bug that changes the color in the SettingsView. In this situation, you should restart the application - then it works without any problems. This is likely due to the use of .environment (\.colorScheme, ...) instead of .preferredColorScheme(...). I chose the first option because the second one often didn't save the selected theme.
- Changing the language only works in the simulator - this is probably caused by the option to change the language in the settings, which is only available for applications that are downloaded through the AppStore.
- Sometimes, on a physical device, adding a positive thing through an Alert with TextField returns to the home screen, which has padding from the top for half of the screen.
- CarouselView scrolls more than one page depending on the length of the gesture.

# Informations
- This application is not a replacement for professional help - let it be an electronic diary that may help you. I am not legally responsible for improper use of the application and any damage that someone may cause to himself or others. SaveMe is not a medical application - in case of mental disorders, visit a specialist who is a wonderful person and will try to help. You can also call the helpline where you can also find help.
- The project is ended.
- To copy the information, hold the card and tap the copy button.

# Gallery - rest of the views
**Welcome View:**
![Welcome](https://user-images.githubusercontent.com/41966757/111632603-efcea780-87f4-11eb-91ef-160959798681.png)

**Home View:**
![Home](https://user-images.githubusercontent.com/41966757/111634109-7c2d9a00-87f6-11eb-8d17-6fcc52c7b0b4.png)

**Tutorial View - 2x faster:**

![Welcome](https://user-images.githubusercontent.com/41966757/111634202-94051e00-87f6-11eb-88a6-2ebb2027136b.gif)


# [YouTube] Application usage video
[![SaveMeAppUsage](https://user-images.githubusercontent.com/41966757/111635050-62d91d80-87f7-11eb-9687-eebcc81e4d47.png)](http://www.youtube.com/watch?v=sgYjkqx2OGc "SaveMe")
