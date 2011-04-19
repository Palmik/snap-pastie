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
* snap
* snap-core
* snap-server
* snap-extension-mongodb
* heist
* mongoDB
* bson

*Take a look at the [`pastie.cabal`](pastie.cabal) for details*

### Tools
* 

## Design Decisions
In this littel project, we will be abiding the rules of what is usually called the [MVC architecture](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).
The reason is simple -- it makes your code more modular and thus hopefully easier to reason about and maintain.

*Disclaimer: These design decision are in no way related to the Snap & Heist itself, you do not have to follow them in your projects.*

### Model
Model should communicate the data (in our case from database) to the controller and handle the data received from controller.

Our model resides in the `src/Model` directory. It's job is:
* to communicate with a database (i.e. writing and reading),
* to present data in suitable form to the controller.

### Controller
**Controller should:**
* contain the logic of the application,
* perpare a data from the model for the view,
* serve a data from the view (user input) to the model.

**Controller should not:**
* access a database directly.

Our controller resides in the `src/Controller` directory. It's job is:
* to manipulate the data it got from the model and prepare them to be presented to the user (e.g. retrieve a post),
* to convert the data it got from users to suitable form for the model (e.g. handle a form).

In Snap & Heist terms, this is the place where we implement most of our splices (ideally all of them).

### View
Our view resides in the `resources/templates` directory. It's job is:
* to display the data from controller to the user,
* to provide an input facilities (e.g. a HTML form).

In Snap & Heist terms, the view are the Heist templates where we call the controller's splices.

## Down to Bussines
### Setting up the MongoDB Extension