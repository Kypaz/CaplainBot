require 'open-uri'
require 'nokogiri'

def get_bulletin()
  url = "http://mto38.free.fr/"
  doc = Nokogiri::HTML(open(url))
  emission_date = doc.css("table b[1] i").text
  str = "Emis : " + emission_date + "\n"
  i = 1
  while doc.css("table div.titre:nth-of-type("+i.to_s+")").text != ""
    titre = doc.css("table div.titre:nth-of-type("+i.to_s+")").text
    blabla = doc.css("table div.blabla:nth-of-type("+i.to_s+")").text
    data = doc.css("table div.blabla:nth-of-type("+i.to_s+") + div.donnees").text
    str += "\n" + titre
    str += blabla + "\n"
    if data != ""
      str += data + "\n"
    end
    i = i +1
  end
  return str
end
