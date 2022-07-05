# MovDB - Movie app displaying latest movies and details from TMDB

Use Case:

* Home scene with various categories of movies (e.g. Popular, Trending, Now Playing, Upcoming)
* When movie tile is clicked, movie detail page is displayed with movie poster image, and other details such as title, rating, budget, description.
* On movie details page, similar movie recommendation and cast details are shown in collection view.

Tech Stack/ Highlight:

* Language: Swift
* Platform: iOS 15
* Networking: Combine + URLSession
* UI Design Pattern: Model View View-Model + Coordinator
* Image Caching
* UI Binding: Combine
* Unit Tests (for data driven components and few view components)
* Depedency Injection using Coordinators
* Collection Views (Compositional Layout), Table Views, Collection View List Cells, Diffable Data Sources

To run the app:

* Download this repo.
* Open .xcodeproj file.
* Run on simulator (iOS 15, > iPhone 12 preferably)
