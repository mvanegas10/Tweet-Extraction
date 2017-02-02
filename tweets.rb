require 'rubygems'
require 'oauth'
require 'json'
require 'date'


all = Array.new

# Método para guardar la información relevante de un tweet en un txt
def guardar_tweet(tweet,all)
    open('tweets.csv', 'a') do |f|
      if all.include?(tweet["user"]["screen_name"])
        # puts tweet["created_at"] + " - " + tweet["id_str"] + " - " + tweet["text"]
        # f.puts (tweet["created_at"] + "," + tweet["id_str"] + "," + tweet["text"])
        d = Date.parse(tweet["created_at"])
        # puts (d.strftime() + " " + tweet["text"])
        f.puts (d.strftime() + ',' + tweet["text"] + "\n")
      end
    end
    # open('id_recovery.txt', 'w') do |g|
    #   g.puts tweet["id_str"]
    # end
end

# Contador de iteraciones
i = 0
# Hash que guarda como llaves los screen_names de los equipos de la Liga
# y como valores el id del último tweet procesado de cada cuenta.
screen_names = Hash.new
# Los valores se inician en el id de un tweet que sirva como referente temporal.
id_tweet_referente = 758736509088301060

all.push("ieeevis")
all.push("eagereyes")
all.push("mbostock")
all.push("tamaramunzner")
all.push("jeffrey_heer")
all.push("benbendc")
all.push("FILWD")
all.push("wattenberg")
all.push("albertocairo")
all.push("visualisingdata")
all.push("nytgraphics")
all.push("flowingdata")
all.push("uwdata")
all.push("NElmqvist")
all.push("EdwardTufte")
all.push("duto_guerra")

screen_names["ieeevis"] = id_tweet_referente
screen_names["eagereyes"] = id_tweet_referente
screen_names["mbostock"] = id_tweet_referente
screen_names["tamaramunzner"] = id_tweet_referente
screen_names["jeffrey_heer"] = id_tweet_referente
screen_names["benbendc"] = id_tweet_referente
screen_names["FILWD"] = id_tweet_referente
screen_names["wattenberg"] = id_tweet_referente
screen_names["albertocairo"] = id_tweet_referente
screen_names["visualisingdata"] = id_tweet_referente
screen_names["nytgraphics"] = id_tweet_referente
screen_names["flowingdata"] = id_tweet_referente
screen_names["uwdata"] = id_tweet_referente
screen_names["NElmqvist"] = id_tweet_referente
screen_names["EdwardTufte"] = id_tweet_referente
screen_names["duto_guerra"] = id_tweet_referente

# Ciclo de update
while true

  # Print del contador
  puts i
  # Ciclo sobre las cuentas de twitter incluidas en el hash
  screen_names.each do |screen_name,last_id|
    # URL base
    baseurl = "https://api.twitter.com"
    # GET statuses/user_timeline
    path    = "/1.1/statuses/user_timeline.json"
    # Parametrización del query
    query   = URI.encode_www_form(
        "screen_name" => "#{screen_name}",
        "count" => 50,
        "since_id" => screen_names["#{screen_name}"],
    )
    address = URI("#{baseurl}#{path}?#{query}")
    request = Net::HTTP::Get.new address.request_uri
    # Setup  de HTTP
    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # Setup de credenciales de Twitter API
    consumer_key = OAuth::Consumer.new(
        "Bk2RrrGJIx3z3R3NzWXk2V0g0",
        "Q5QPiTiapz1GewGV2aeLWoT8IoWXhjBFrC9bsQRvjOjpTSacPK")
    access_token = OAuth::Token.new(
        "435217839-v08vYEBqddJQYHmH42ih269a6QsY0G4SozqEbs4P",
        "aYREePRSAlWpPyBQvs3VOYbHnt8w2UZCWyTj21yGzQGzW")
    # Envió de request y recepción de la respuesta
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request
    # Parsing de la respuesta y manejo de tweets recuperados
    tweets = nil
    puts response.code
    if response.code == '200' then
      tweets = JSON.parse(response.body)
      # Los tweets vienen en orden cronólogico descendente
      # Hay que reversarlos para actualizar el valor del hash correctamente
      tweets.reverse!
      # Ciclo sobre cada tweet recuperado
      tweets.each do |tweet|
        # Se actualiza el valor del hash del usuario con el id del ultimo tweet recuperado
        screen_names["#{screen_name}"] = tweet["id_str"]
        # Se guarda el id, screen_name, texto y timestamp del tweet en el txt
        guardar_tweet(tweet, all)
        # Print del usuario y del id recuperado
        # puts "#{screen_name} - " + tweet["id_str"] + " - " + tweet["text"]
      end
    end
  end
  # Se esperan 450 segundos antes de realizar nuevos updates.
  sleep(450)
  # Se aumenta el contador de iteraciones
  i += 1
end
