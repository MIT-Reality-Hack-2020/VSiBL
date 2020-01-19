# 2020 MIT VR/AR Hacktahon
Team VSiBL ✨🐢🚀✨


**Authors**: Ryan Kopinsky, Alex Xingqi Casella, Yogeshwor JB Rana, Emily Shoemaker

**Overview**
VSiBL makes it possible for people in the same physical space to discover and connect with one another by using AR to reveal contextual information that is anchored to the users’ personal devices. Using a multi-user spatial mesh network to establish a shared reference frame, VSiBL users join an AR session overlaying their current environment. In the session, participants can visually identify each other’s location as well as whatever information they have chosen to express about themselves.

**Use Cases**
This tool is extremely useful in situations where traditional methods of communication (such as speaking) are not viable. There are many such occasions: in the hackathon team formation example, it is difficult to be heard when yelling over a crowded room. In another scenario, a hearing-impaired individual might be attending a social mixer and wish to visually identify who else in the room can speak sign language and where those people are standing. Other people at the same social mixer may want to visually identify who is single and ready to mingle. Finally, teachers may wish to scan their classroom before beginning a lecture and identify where students with certain learning disorders are sitting so that they can adjust their pedagogy accordingly during the lesson. This is just a small sample of the possible use cases for VSiBL.

**Consent**
Consent was one of the primary topics of discussion for our team during this hackathon. VSiBL makes your personal information visible and localized to your position in an environment, so there may be scenarios in which users engage in predatory behavior. We would like to emphasize that VSiBL will only display information that users have knowingly and voluntarily chosen to share with others. Future versions of the platform will (1) provide extensive privacy controls and (2) have UI features that clearly indicate to users what information about them is visible to others at all times.

<br>

### Technical Description
Technologies used: RealityKit, ARKit, Multipeer Connectivity, spatial mesh network, Firebase

**Frontned AR**: 
VSiBL is a multi-user spatial mesh network built on Apple’s RealityKit, ARKit, and Multipeer Connectivity frameworks. Spatial mapping is used to establish a shared reference frame for participants in the same session. The shared reference frame is constructed by looking for overlap in the point clouds of each participant’s device. Once a shared reference frame has been established, participant data is communicated in real-time over a mesh network maintained by Multipeer Connectivity. 

Participant data is visualized using Augmented Reality assets created in Reality Composer. In the demo sample app, participants represent potential team roles such as Developer, Designer, Storyteller, and Staff. Each role is displayed as an “User Icon” using RealityKit as the rendering technology. Of course, VSiBL allows for the display of any data that is desired to be anchored on a person. 

ARKit automatically creates ARParticipantAnchors for each participant in a VSiBL session. The ARParticipantAnchors are registered to the pose of the user’s device. The sample app assumes each participant uses a mobile phone positioned in front of the user at chest height. To display AR content on top of the participant’s head, a transformation is performed using fine-tuned, static values. Ideally, motion capture or face detection would be used to make head pose estimation more robust. Furthermore, once devices such as Apple AR Glasses are released, anchoring content above the head will likely be a simple translation transformation.


**Cloud data persistence**: We used the Firebase real time database to persist user information. The real time database is always in sync with users' phones. We have many designs in mind for improving the scalability and reliability of the network should this project ever go into production.  

<br>

### Set up
To run the project, just clone and then `cd` into the **VSiBL Prototype** directory and run the **.xcodeproj**

Thank you, we welcome any and all feedback! :sweat_smile: 

