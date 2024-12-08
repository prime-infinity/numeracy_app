# numeracy app

the contents of this readme is meant to give a comprehensive and detailed explation of the technical aspects of this app "numeracy".
It'll include architecture, data types, data flow, state, state change etc.

This is done for some possible reasons:

- As the app grows, it'll become harder to track. This documentation is mean to both be a grounded state of refrence of the app, and meant to track the app as it grows.
- In the event that the app is sold or transferred, it becomes easy for the new devs to understand the process that made the app
- This documentation is also meant for me, the creator of this app. Prime infinity itself to know what i did, why i did what i did and what not
- Being conscious of the fact that i'm documenting all my doings will hopefully make me aware to always follow best practices, i apologize to any senior devs viewing my codes.

## Overall App explanation

In it's oversimplified form, this app delivers math questions to the users, the app also delivers 4 options that the users can then pick from, of which one is the right answer.
In the stage one of it's MVP(which i'm writing this from), the app generates these questions and options from codes within the app itself.

P.S:The overall theme of this app is "simplicity" and "organization". So the app, it's features, contents, code, UI, etc, are kept as simple and organized as possible. The more simple an app, the easier it is to explain

Also P.S:I have decided to focus on documenting the essential workings of the app, most notebly the models, data types and data flow. Contents in the UI/UI may change rapidly

## Tech Stack Overview

In the stage one of it's MVP(which i'm writing this from), the tech stack used are:

- Flutter for UI and UX
- Riverpod for state management

## Architecture

In the architecture of the app, an effort is made to follow an organized and simple pattern.
All global data type modelling and methods are done in the "models" folder. All global state and notifiers are done in the "providers" folder.
Other services that help the app perform additional tasks are done in the "services" folder.
The "screen" folder hold individual screens "only". the components/widgets that are in the individual screen (if going to be reused) are to be moved to another folder //TODO:create this folder

### Models

In stage one of the mvp, the only global data types and methods that exist are those concerned with the actual question(s) themselves.

#### Question model

Overview wise, in stage one of the MVP, the question model contains: the question number, the first number of the operation, the second number of the operation, the operation itself, the list of options, the correct result, and a method to check if the answer is correct or not
