require 'nancy'
require 'requests/sugar'
require 'nokogiri'
require 'yajl'

class App < Nancy::Base
  get '/booths/:id' do
    url = "http://www3.registraduria.gov.co/censo/_censoresultado.php?nCedula=#{params['id']}"
    response = Requests.get(url)
    doc = Nokogiri::HTML(response.body)
    info = {}
    doc.css("table tr td").each_slice(2){|el| info[el[0].children.children.text] = el[1].children.text.strip }
    info["error"] = "ID don't found or invalid" if info.empty?
    Yajl::Encoder.encode(info)
  end

  get '/juries/:id' do
    url = "http://190.60.255.10:81/Registraduria/vista/jurados_files/consultar_jurados.php?cedula=#{params['id']}"
    response = Requests.get(url)
    doc = Nokogiri::HTML(response.body)
    info = {}
    doc.css(".t_jurados tr td").each_slice(2){|el| info[el[0].text] = el[1].text.strip }
    info["error"] = "ID wasn't selected as jury" if info.empty?
    Yajl::Encoder.encode(info)
  end
end
