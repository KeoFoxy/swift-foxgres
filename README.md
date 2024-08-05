# :fox_face: swift-foxgres

Simple backend service that implements CRUD operations.

## Stack

* ***Swift***
* ***Vapor***
* ***Docker***
* ***PSQL***

## Requirements

* **[Swift 5.10](https://www.swift.org/download/)**
* **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**

### Start

> [!IMPORTANT]  
> Do not forget to create and fill the `.env` file! Just remove **.example** from `.env.example`
> 

```sh
git clone git@github.com:KeoFoxy/swift-foxgres.git

docker-compose build
docker-compose up -d
docker-compose run migrate
```

### Tests

```sh
docker-compose up -d db

swift test
```

> [!WARNING]  
> Make sure that the DB is available either via Docker or locally


#### API

##### Anime API

| Method   | URL                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `GET`    | `/animes`                             | Receive all anime.                      |
| `GET`   | `/animes/{id}`                             | Get anime by id.                       |
| `POST`    | `/animes`                          | Create an anime.                       |
| `PUT`  | `/animes/{id}`                          | Update existing anime by id.                 |
| `DELETE`   | `/animes/{id}`                 | Delete anime by id.                 |

##### Characters

| Method   | URL                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `GET`    | `/characters`                             | Receive all characters.                      |
| `GET`   | `/characters/{id}`                             | Get character by id.                       |
| `POST`    | `/characters`                          | Create character.                       |
| `PUT`  | `/characters/{id}`                          | Update existing character by id.                 |
| `DELETE`   | `/characters/{id}`                 | Delete character by id.                 |

#### Models

##### Anime
```swift
id: Optional<UUID>
titleEn: String
titleJp: String
description: Optional<String>
releaseDate: Date
rating: Double
episodeCount: Int
type: AnimeType
characters: [UUID]
genres: Optional<[String]>
imageUrl: Optional<String>
```

##### Character

```swift
id: Optional<UUID>
name: String
description: Optional<String>
animeId: [UUID]
imageUrl: Optional<String>
```