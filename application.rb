require 'pry'
require 'json'
require 'sinatra'

# Racer model
class Racer
    attr_accessor :name, :team, :number, :nationality, :id
    
    @@all = []
    @@id_count = 0

    def initialize(args={})
        args.each do |k,v|
            self.send("#{k}=", v)
        end
    end

    def save
        self.id = @@id_count
        @@id_count += 1
        @@all << self
        self
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

      def update(data)
        data.each do |k,v|
            self.send("#{k}=", v)
        end
        self
      end
end

# Seeds
Racer.create(name: "Valentino Rossi", team: "Factory Yamaha Racing", number: 46, nationality: "Italy")
Racer.create(name: "Marc Marquez", team: "Factory Honda", number: 93, nationality: "Spain")
Racer.create(name: "Taka Nakagami", team: "LCR Honda", number: 30, nationality: "Japan")
Racer.create(name: "Nicky Hayden", team: "Factory Honda", number: 69, nationality: "United States")
Racer.create(name: "Fabio Quatararo", team: "Factory Yamaha", number: 20, nationality: "France")
Racer.create(name: "Johann Zarco", team: "Pramac Ducati", number: 5, nationality: "France")
Racer.create(name: "Cal Crutchlow", team: "Factory Yamaha", number: 35, nationality: "Great Britan")
Racer.create(name: "Jack Miller", team: "Factory Ducati", number: 43, nationality: "Austrailia")
Racer.create(name: "Luca Marini", team: "VR46 Ducati", number: 10, nationality: "Italy")
Racer.create(name: "Aleix Espargaro", team: "Factory Aprilia", number: 41, nationality: "Spain")

# Basic Rack CRUD 
# class Application

#     def call(env)
#         request = Rack::Request.new(env)
#         response = Rack::Response.new

#         # Root route
#         if request.path == "/"
#             # The response always needs to be strucutured like: [status, headers, body]
#             return [200, {"Content-Type" => "text/html"}, ["<h1>Hello, from the root route</h1>"]]

#             # READ - Get all racers
#         elsif request.path == "/racers" && request.get?
#             racers = Racer.all 
            
#             json_racers = racers.map {|r| back_to_hash(r)}
#             return [200, {"Content-Type" => "application/json"}, [json_racers.to_json]]

#             # READ - Get a racer by id
#         elsif request.path.match("/racers/") && request.get?
#             racer_id = request.path.split("/racers/").last.to_i
#             racer = Racer.find(racer_id)
#             if racer
#                 racer = back_to_hash(racer)
#                 return [200, {"Content-Type" => "application/json"}, [racer.to_json]]
#             else
#                 return [404, {"Content-Type" => "text/html"}, ["Record not found"]]
#             end

#             # CREATE - Create a new racer
#         elsif request.path.match("/racers") && request.post?
#             # fetch("http://127.0.0.1:9292/racers/0", {
#             #     method: "POST",
#             #     headers:{ 'Content-Type': 'application/json' },
#             #     body: JSON.stringify({name: "Thompson Plyler", team: "Factory Aweseom", number: 100, nationality: "United States"})
#             #   }).then(resp => console.log(resp))

#             hash = JSON.parse(request.body.read)
#             Racer.create(hash)
#             racers = Racer.all 
#             json_racers = racers.map {|r| back_to_hash(r)}
#             return [200, {"Content-Type" => "application/json"}, [json_racers.to_json]]

#             # UPDATE - Update a racer's data '/racers/:id' 
#         elsif request.path.match("/racers/") && request.patch?
#             # fetch("http://127.0.0.1:9292/racers/0", {
#             #     method: "PATCH",
#             #     headers:{ 'Content-Type': 'application/json' },
#             #     body: JSON.stringify({number: 46})
#             #   })

#             # request.path
#             # => "/racers/0"
#             # We information that we are after here is the id that was passed as a parameter in the requested URL.
#             # If we use the split method, we can gain access to the id.
#             # request.path.split("/racers/")
#             # => ["", "0"]
            
#             # Then, we can call .last on the array and grab the id
#             racer_id = request.path.split("/racers/").last.to_i
#             # Use the racer_id to get find the racer using the Racer.find method.
#             racer = Racer.find(racer_id)
            
#             # Read the body that was sent in the POST request from the client
#             data = JSON.parse(request.body.read)
#             racer.update(data)
#             return [200, {"Content-Type" => "application/json"}, [racer.to_json]]

#             # DELETE - Delete a racer by id 
#         elsif request.path.match("/racers/") && request.delete?
#             # Then, we can call .last on the array and grab the id
#             racer_id = request.path.split("/racers/").last.to_i
            
#             # Use the racer_id to get find the racer using the Racer.find method.
#             racer = Racer.find(racer_id)
#             # Delete racer from @@all
#             Racer.all.delete(racer)
#             racer = back_to_hash(racer)

#             # Respond with the deleted racer and a 200
#             return [200, {"Content-Type" => "application/json"}, [racer.to_json]]
#         end

#         response.write "This path does not exits. "
#         response.write "Please check the URL and try again."
#         response.finish
#     end

#     def back_to_hash(racer)
#         {
#             id: racer.id, 
#             name: racer.name, 
#             team: racer.team, 
#             number: racer.number, 
#             nationality: racer.nationality
#         }
#     end
# end



# Basic Sinatra CRUD - uncomment require 'sinatra' at the top of the page and comment out the Rack Application class.
# Run: ruby application.rb

# GET - all Racers
get "/racers" do 
    racers = Racer.all 
    json_racers = racers.map {|r| back_to_hash(r)}
    json_racers.to_json
end

# GET - an individual racer
get "/racers/:id" do
    racer = Racer.find(params["id"].to_i)
    back_to_hash(racer).to_json
end

# CREATE - create a racer
post "/racers" do 
    hash = JSON.parse(request.body.read)
    Racer.create(hash)
    racers = Racer.all 
    json_racers = racers.map {|r| back_to_hash(r)}
    json_racers
end

# UPDATE - update a racers info
patch "/racers/:id" do 
    racer = Racer.find(params[:id])
    hash = JSON.parse(request.body.read)
    racer.update(hash)
    back_to_hash(racer).to_json
end

# DELETE - delete a racer.
delete "/racers/:id" do
    # Use the racer_id to get find the racer using the Racer.find method.
    racer = Racer.find(params[:id].to_i)
    # Delete racer from @@all
    Racer.all.delete(racer)
    back_to_hash(racer).to_json
end

# HELPER to convert 
def back_to_hash(racer)
    {
        id: racer.id,
        name: racer.name, 
        team: racer.team, 
        number: racer.number, 
        nationality: racer.nationality
    }
end