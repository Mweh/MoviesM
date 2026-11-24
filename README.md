# MoviesM

## Run in Xcode

1. Set `TMDB_LOCAL_TOKEN` in `.env.xcconfig` to your TMDB **API Read Access Token**. https://www.themoviedb.org/settings/api
2. Open `MoviesM.xcodeproj`, choose the **MoviesM** scheme and an iPhone simulator, then run with **⌘R**. Development was verified with Xcode 27.2.

## Architecture

- The app groups screen code under `MoviesM/Features/<Feature>/VIPER`.
- `Packages/TMDBClient` owns TMDB endpoints.
