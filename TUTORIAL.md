## THIS TUTORIAL IS STILL WORK IN PROGRESS

## Welcome
Welcome curious stranger. You have wandered into tutorial which aims to help you grasp the Snap and Heist Haskell modules via building a simple dynamic website.

## Prerequisites
### Knowledge
* For your own good, read the following articles first:
  1. [Snap Quick Start Guide](http://snapframework.com/docs/quickstart)
  2. [Snap API Introduction](http://snapframework.com/docs/tutorials/snap-api)
  3. [Heist Template Tutorial](http://snapframework.com/docs/tutorials/heist)  
* You should be comfortable with the concept of monads.

### Modules
Apart from the basic and standard modules, you will need these:

* snap -- [[github]](https://github.com/snapframework/snap) | [[haddock]](http://snapframework.com/docs/latest/snap/index.html)
* snap-core -- [[github]](https://github.com/snapframework/snap-core) | [[haddock]](http://snapframework.com/docs/latest/snap-core/index.html)
* snap-server -- [[github]](https://github.com/snapframework/snap-server) | [[haddock]](http://snapframework.com/docs/latest/snap-server/index.html)
* snap-extension-mongodb -- [[github]](https://github.com/ozataman/snap-extension-mongodb) | [haddock]
* heist -- [[github]](https://github.com/snapframework/heist) | [[haddock]](http://snapframework.com/docs/latest/heist/index.html)
* mongoDB -- [[github]](https://github.com/TonyGen/mongoDB-haskell) | [[haddock]](http://hackage.haskell.org/package/mongoDB)
* bson -- [[github]](https://github.com/TonyGen/bson-haskell) | [[haddock]](http://hackage.haskell.org/package/bson)

*Take a look at the [`pastie.cabal`](pastie.cabal) for details*

### Tools
You only need a text editor or IDE of your choice, GHC and cabal (I would presonally recommend cabal-dev).

## Design Decisions
In this littel project, we will be abiding the rules of what is usually called the [MVC architecture](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).
The reason is simple -- it makes your code more modular and thus hopefully easier to reason about and maintain.

*Disclaimer: These design decisions are in no way related to the Snap & Heist itself, you do not have to follow them in your projects.*

### Model
Model should provide API to retrieve and store data (in our case in database).

Our model resides in the [`src/Model`](src/Model) directory. It's job is:

* to communicate with a database (i.e. writing and reading),
* to present data in suitable form to the controller.

### Controller
Controller is the place where the application logic resides.

Our controller resides in the [`src/Controller`](src/Controller) directory. It's job is:

* to manipulate the data it got from the model and prepare them to be presented to the user (e.g. retrieve a post),
* to convert the data it got from users to suitable form for the model (e.g. handle a form).

In Snap & Heist terms, this is the place where we implement most of our splices (ideally all of them).

### View
View is the mediator between application and the user.

Our view resides in the [`resources/templates`](resources/templates) directory. It's job is:

* to display the data from controller to the user,
* to provide an input facilities (e.g. a HTML form).

In Snap & Heist terms, the view consists of the Heist templates where we call the controller's splices.

## Down to Bussines
### Setting up MongoDB server

It's really easy! Just download [the binary](http://www.mongodb.org/downloads) for your system and fire up the `mongod` daemon, that's it, you are set to go.

### Setting up the Heist Extension

*Working file: [Application.hs](src/Application.hs)*

One of the strengths of Snap is its modularity and Heist is a proof of that.
Heist is just an extension, meaning [you could use your own templating engine]("if such thing crossed your mind, it probably will not ever again after you learn more about Heist"), yet it seamlessly blends with Snap.

### Setting up the MongoDB Extension

*Working file: [Application.hs](src/Application.hs)*

The Snap.Extension.MongoDB is Snap extension utilizing Snap's extension interface.
It's installed analogicaly to any other Snap's extension.

First, we import the module of the extension:

    import           Snap.Extension.DB.MongoDB

Then we make it part of our Application's state along with Heist:

    data ApplicationState = ApplicationState
        { templateState :: HeistState Application
        , databaseState :: MongoDBState
        }

    instance HasMongoDBState ApplicationState where
        getMongoDBState     = databaseState
        setMongoDBState s a = a { databaseState = s }

And finally call the extension's initializer in the application's initializer:

    applicationInitializer :: Initializer ApplicationState
    applicationInitializer = do
        heist <- heistInitializer "resources/templates"
        database <- mongoDBInitializer (Host "127.0.0.1" $ PortNumber 27017) 1 "pastie"
        return $ ApplicationState heist database

    database <- mongoDBInitializer (Host "127.0.0.1" $ PortNumber 27017) 1 "pastie"

That line tells the MongoDB extension, that the database server is hosted on `127.0.0.1` and listening on port `27017` (which is the standard one)