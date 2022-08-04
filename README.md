# intro-to-sinatra

- Questions

  - What would you say the difference between an API, a server, and a database?

- Key Terms

  - endpoint
  - controller
  - root route
  - params
  - separation of concerns
  - single responsibility

  - Objectives
  - [ ] Discuss Rack and what it does.

    - Walk-through

      - Why - In Phase 2, we used a db.json to store and post data. This phase we are going to be creating a more robust backend that can accept requests from a client and returns a response.

      - What is Rack - [Rack](https://github.com/rack/rack) is a web server interface that is going to give a way to create a server with Ruby. We are actually able to create a full CRUD app using Rack.

      - How:

        - Create a `config.ru` file

          - The `config.ru` fie
          - This file needs to live on the top level of the file structure.
          - We will be configuring Cross Origin Resource Sharing in this file as well as where the class Rack can find the class that is will contain our routes.
          - We will define the “main” class to `run` and all other classes that Rack can `use`

        - Create an `application.rb` file

          - This file will contain the class that has a `call` method.

        - `gem install rack`

        - In the `config.ru`
          ```ruby
          require 'rack'
          require_relative './application.rb'

          run Application.new
          ```
        - In the `application.rb`
          ```ruby
          require 'pry'

          class Application
              def call(env)
                  request = Rack::Request.new(env)
                  response = Rack::Response.new

                  binding.pry
              end
          end
          ```

  - [ ] Add Model - Perform CRUD on model

    - Walk-through

      - Why - At the end of the day we want to be working with something that we can ‘consume’ with a React front-end. Ultimately, we will need to be sending json as our responses.

      **For this example, We will not be using Active Record in an effort to highlight the functionality of the Rack gem. I do want to create methods that mimic the Active Record ORMs.**

      - What - Add gem: `[require 'json’](https://github.com/flori/json)` - this will give us the ability to call `.to_json` on our Ruby hashes and convert them to json.

      - How: Add the following to the `application.rb` file
        ```ruby
        require 'pry'
        require 'json'

        class Racer
          attr_accessor :name, :team, :number, :nationality, :id

          @@all = []
          @@count = 0

          def initialize(args = {})
            args.each do |k, v|
              self.send("#{k}=", v)
            end
          end

          def save
            self.id = @@count
            @@count += 1
            @@all << self
          end

          def self.create(args = {})
            racer = self.new(args)
            racer.save
          end

          def self.find(id)
            @@all.find { |r| r.id == id }
          end

          def self.all
            @@all
          end
        end

        #Seeds
        Racer.create(name: "Valentino Rossi", team: "Factory Yamaha Racing", number: 46, nationality: "Italy")
        Racer.create(name: "Marc Marquez", team: "Factory Honda", number: 93, nationality: "Spain")
        Racer.create(name: "Taka Nakagami", team: "LCR Honda", number: 30, nationality: "Italy")
        Racer.create(name: "Nicky Hayden", team: "Factory Honda", number: 69, nationality: "United States")
        Racer.create(name: "Fabio Quatararo", team: "Factory Yamaha", number: 20, nationality: "France")
        Racer.create(name: "Johann Zarco", team: "Pramac Ducati", number: 5, nationality: "France")
        Racer.create(name: "Cal Crutchlow", team: "Factory Yamaha", number: 35, nationality: "Great Britan")
        Racer.create(name: "Jack Miller", team: "Factory Ducati", number: 43, nationality: "Austrailia")
        Racer.create(name: "Luca Marini", team: "VR46 Ducati", number: 10, nationality: "Italy")
        Racer.create(name: "Aleix Espargaro", team: "Factory Aprilia", number: 41, nationality: "Spain")

        binding.pry
        ```

      ## Deliverables

      - Create an endpoint `/racers` that responds with _all_ racers instances.
      - Create an endpoint `/racers` that gives us the ability to _add_ a new racer.
      - Create an endpoint `/racer/:id` that responds with a single json racer.
      - Create an endpoint `/racer/:id` that allows us to update a single racer object.
      - Create an endpoint `/racers/:id` that deletes the racer with the id that is passed in the `params`.

  - [ ] Five minute break

  - [ ] Create basic Sinatra app

  - Walk - through
    - Why - Rack is a great tool to build a server in Ruby. The code that we ended up writing was pretty dense though and as devs, we are lazy. There is a simpler - cleaner way to create endpoints and that is going to be through the use of Sinatra.
    - What - [Sinatra is a DSL that “rides on top of” Rack](https://sinatrarb.com/intro.html#:~:text=Sinatra%20rides%20on%20Rack%2C%20a%20minimal%20standard%20interface%20for%20Ruby%20web%20frameworks.). Sinatra is nothing more than a collection of pre-written methods that we can incorporate into our applications. Sinatra is a “lightweight framework” meaning that the responsibility of app structure and communication falls solely on the developer. We really don’t need much to spin up a Sinatra app.
    - How:
      - Installation: `gem install sinatra`
      - In application.rb:
        ```ruby
        require 'sinatra'

        get '/' do
          'Hello world!'
        end
        ```
        ## Deliverables
        - Create a route `/racers` that responds with _all_ racers instances.
        - Create a route `/racers` that gives us the ability to _add_ a new racer.
        - Create a route `/racer/:id` that responds with a single json racer.
        - Create a route `/racer/:id` that allows us to update a single racer object.
        - Create a route `/racers/:id` that deletes the racer with the id that is passed in the `params`.

- [ ] Organize code - OO design principals

  - Walkthrough
    - Single Responsibility - the idea that classes in object-oriented programming should have one job, one responsibility, and their services (i.e., methods) should be narrowly aligned with that responsibility.
    - Separation of concerns - the idea that the various responsibilities, or concerns, of a computer program should be separated out into discrete sections
