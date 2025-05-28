### Summary: 

The screenshots below display the app's features and pages.

First, look at the app: This page consists of the search recipe feature, sorting recipes, and selecting a recipe to see its details

![Simulator Screenshot - iPhone 16 Pro - 2025-05-28 at 00 14 08](https://github.com/user-attachments/assets/58714575-4a6a-4615-ba42-90ab84750ee9)

Details of a recipe: Here, the user can return to the initial page, click on YouTube, and be directed to YouTube, where they can view the video instructions for the recipe. 
Additionally,  the user can click on the web preview and be directed to the website.

![Simulator Screenshot - iPhone 16 Pro - 2025-05-28 at 00 14 16](https://github.com/user-attachments/assets/0a3eaa8c-075b-44db-a205-1b0eadbcfd3c)


### Focused Areas: 

The areas I prioritized are the data fetching and caching, ensuring that the data is handled efficiently, as well as what would happen when a user refreshes a page, keeping the network requests to
a minimum and efficient. That's why I implemented caching for both the JSON data and the images. Additionally, I focused on making the UI intuitive and visually simple, since user experience 
plays a huge role in recipe browsing apps, and that's why I kept the UI as simple and engaging as possible so that new users face minimal difficulties in getting used to the app.

### Time Spent:

I have dedicated 6 hours, to be exact, to this project. The first 30-50 minutes were dedicated to planning the software, asking myself questions on how the data and the UI would be handled, keeping 
the code optimized at a maximum. Following that, it took 3.5 hours for me to code out the requirements and essential parts, including the UNIT tests, and the rest of the time I spent on refactoring, 
fixing bugs, and improving the UI, making the app smoother to use.

### Trade-offs and Decisions: 

Yes, I chose to implement manual image and JSON caching without third-party libraries to align with the project constraints. While this gave me full control and a learning experience, it came 
at the cost of more boilerplate and edge-case handling like force-refresh logic and disk cleanup. I also avoided Core Data or Realm for simplicity, using file-based persistence instead.

### Weakest Part of the Project:

I would say the weakest part of the project would be the lack of automated testing, even though I tested each kind of data received by the app, including the decoding function as well. Also, 
the error handling could be further refined to display more helpful messages to the user.

### Additional Information: 

One constraint was ensuring the app worked smoothly without third-party dependencies, which required building caching and networking features from scratch. This ended up being a valuable 
learning experience. I also made sure the app behaved gracefully with slow or no internet connection, including refresh control, image loading fallback, and informative error states. Even though
building the caching mechanism from scratch was difficult but I learned a lot throughout the process.
