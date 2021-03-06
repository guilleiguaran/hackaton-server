require 'nancy'
require 'requests/sugar'
require 'nokogiri'
require 'yajl'
require 'rack/jsonp'

class App < Nancy::Base
  use Rack::JSONP

  after do
    response['Content-Type'] = 'application/json'
  end

  get '/booths/:id.json' do
    url = "http://www3.registraduria.gov.co/censo/_censoresultado.php?nCedula=#{params['id']}"
    response = Requests.get(url)
    doc = Nokogiri::HTML(response.body)
    info = {}
    doc.css("table tr td").each_slice(2){|el| info[el[0].children.children.text.gsub(":","")] = el[1].children.text.strip }
    info["error"] = "La cedula no es valida o no puede votar en estas elecciones" if info.empty?
    Yajl::Encoder.encode(info)
  end

  get '/juries/:id.json' do
    url = "http://190.60.255.10:81/Registraduria/vista/jurados_files/consultar_jurados.php?cedula=#{params['id']}"
    response = Requests.get(url)
    doc = Nokogiri::HTML(response.body)
    info = {}
    doc.css(".t_jurados tr td").each_slice(2){|el| info[el[0].text.gsub(":", "")] = el[1].text.strip }
    info["error"] = "La persona no fue seleccionada como jurado para estas elecciones" if info.empty?
    Yajl::Encoder.encode(info)
  end
end
