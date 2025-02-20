### Summary: Include screenshots or a video of your app highlighting its features

#### Fetching all recipes and pull to refresh:
https://github.com/user-attachments/assets/e8cc6f58-b0e3-4941-b1d7-e83aa7c94d15
#### Image cache read/write:
<img width="977" alt="read_write" src="https://github.com/user-attachments/assets/8eb416b4-95ba-4b7a-9f80-b7e7e0b140ec" />

#### Image cache read:
<img width="977" alt="read" src="https://github.com/user-attachments/assets/7297bfad-9605-4ec4-a345-e05d1e7b8bed" />

#### Empty recipes:
https://github.com/user-attachments/assets/19258eb2-0409-45c2-994a-8aedccd2326b
#### Malformed recipes:
<img width="875" alt="malformed_recipes" src="https://github.com/user-attachments/assets/213580d8-4da4-4b0f-b53a-5f22b6c4d305" />


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused on developing the WebImageView ui component to display images from url. 
It uses a WebImage module that handles downloading and caching images.
Since the whole project uses constructor-based DI and protocol-oriented programming, I was able to cover the main areas with Unit tests.

<img width="366" alt="unit tests" src="https://github.com/user-attachments/assets/b936cc6f-0ad2-4a7b-bca4-9e49984a111c" />

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
10 hours. ~2 hours a day.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I did a tradeoff in caching strategy to save time. It is a simple file cache that saves/reads data from disk.
Also, the downloader is not using any priorities and not canceling downloads.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The caching strategy is simple. Instead, 2- and 2-level caching can be used in memory and on disk. The LRU algorithm can be used for both.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
The downloader can be improved by using the LRU cache for download tasks and prioritizing them based on the last task used.
A cancellation strategy can be added, limiting the number of concurrent downloads with the LRU cache and canceling the least recently accessed tasks in the cache.
