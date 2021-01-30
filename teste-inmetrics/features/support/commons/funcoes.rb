# language: pt
# encoding UTF-8

def abrir_painel(link)
    $automacao = $classe[$ambiente = :painel]
    $automacao.navegador()
    $automacao.acessar_pagina("Identificacao", link)
end

def compara_arrays(array1, array2)
    array3 = array2.clone
    for i in array1
        unless array3.empty?
            for j in 0...array3.size
                if i==array3[j]
                    puts "#{i} encontrado"
                    array3[j]=nil
                    break
                end
                if j==array3.size-1
                    puts ("#{i} não encontrado")
                end
            end
            array3.compact!
        else
            puts ("#{i} não encontrado")
        end
    end
end

def verificar_local(ambiente, tipo, titulo)
    aux = [$ambiente, $tipo, $titulo]
    if $ambiente != txt2simb(ambiente) then $automacao = $classe[$ambiente = txt2simb(ambiente)] end

    begin
        $automacao.aguardar(tipo, titulo)
        $automacao.aguardar_processamento()
    rescue
        $ambiente, $tipo, $titulo = aux
        puts("A #{tipo} #{titulo} não foi carregada.")
    end
end

# Formata uma String e transforma em Símbolo
def array2str(var)
    case var.instance_of?(Array)
    when true then var.join(" ") else var.to_s end
end

# Transforma uma String em Símbolo
def txt2simb(txt)
    txt = format_txt(rmv(rmv(rmv(txt.to_s, :especiais), :acentuacao), :pontuacao)).strip.gsub(" ", "_").downcase

    loop do
        if txt.empty? then return "Não foi possível gerar um símbolo válido com o texto passado." end
        if !txt[0].match(/[0-9_]/) then return txt.to_sym end
        txt.sub!(txt[0], "")
    end
end

# Transforma um Símbolo em String
def simb2txt(simb)
    simb.to_s.gsub("_", " ").strip
end

# Remoção de caracteres
def rmv(var, aux)
    txt = array2str(var.clone)
    case aux
    when :numeros then aux = /[0-9]/
    when :alfabeto then aux = /[A-Za-zÀ-ü]/
    when :pontuacao then aux = /[!,.:;?'"]/
    when :especiais then aux = /[^0-9A-Za-zÀ-ü!,.;:?'" ]/
        txt.gsub!("_", " ")
    when :acentuacao then aux = /[~^´`¨]/
        txt = txt.split("").map{ |c| if c.match(/[À-ü]/) then I18n.transliterate(c) else c end }.join("")
    else
        case aux.instance_of?(Symbol)
        when true then aux = aux.to_s
        end
    end

    txt.gsub(aux, "")
end

# Remove todos os espaços desnecessários
def format_txt(txt)
    array2str(txt).split(" ").map{ |p| p.strip }.join(" ")
end

# Formata uma String com todas palavras com apenas a primeira letra maiúscula
def apresentacao(txt)
    simb2txt(array2str(txt)).split(" ").map{ |p| p.gsub(/\a/, "").downcase.capitalize }.join(" ")
end

# Verifica o elemento passado
def verificar_endereco(hash, keys = [])
    case keys.empty?
    when false then verificar_endereco(hash[txt2simb(keys.shift)], keys)
    else hash
    end
end

def endereco(elemento, nome)
    #binding.pry
    $obj_pag[$ambiente][$tipo][$titulo][txt2simb(elemento)][txt2simb(nome)]
end

def msg(condicao, elemento, nome, parametro, indice = nil)
    case condicao
    when true then "'#{apresentacao(nome)}'"+ if indice.nil? then " " else " '#{indice}' "end +"é #{apresentacao(parametro)}."
    when false then "'#{apresentacao(nome)}'"+ if indice.nil? then " " else " '#{indice}' "end +"não é #{apresentacao(parametro)}."
    else "Condição Inválida."
    end
end

def comparar_texto(nome, texto, identico = false)
    aux, txt = case identico
    when true then [verificar_elemento(:texto, nome), texto]
    else [apresentacao(verificar_elemento(:texto, nome)), apresentacao(texto)]
    end

    case aux == txt
    when true then "Textos não divergem."
    else "Textos divergem.\n" +
         "Texto esperado: '#{txt}'\n" +
         "Texto elemento: '#{aux}'"
    end
end

def take_print(name=nil)
    $base_name = name||"#{((rmv(@scenario, :pontuacao).downcase).gsub(" ", "_")).gsub("#", "")}"
    path = ENV['SCREENSHOT_PATH']
    n = ((Dir.glob("#{path}#{$base_name}_*").size.to_i)+1).to_s
    name = "#{$base_name}_#{n}"
    $automacao.painel.screenshot.save("#{path}#{name}.png")
    $prints.push(["#{PROJETO}/#{path}#{name}.png", name])

    embed_print($prints.pop) unless ENV['SCREENSHOT_PATH'].include?('reports')
end

def embed_print(print)
    embed(print[0], "image/png", print[1])
end

def abrir_tag(html, *tags)
    tags.each { |tag| html << "<#{tag}>" }
    html
end
  
def fechar_tag(html, *tags)
    tags.each { |tag| html << "</#{tag}>" }
    html
end
  
def reportar_tabela(element, html = [])
    abrir_tag(html, element.tag_name)
    element.trs.each { |e| reportar_linha(e, html) }
    fechar_tag(html, element.tag_name)
end
  
def reportar_linha(element, html = [], aux = nil)
    aux = true if html.empty?
    abrir_tag(html, 'table') unless aux.nil?
    abrir_tag(html, element.tag_name)
    element.ths.each { |e| reportar_celula(e, html) }
    element.tds.each { |e| reportar_celula(e, html) }
    fechar_tag(html, element.tag_name)
    fechar_tag(html, 'table') unless aux.nil?
end
  
def reportar_celula(element, html = [], aux = nil)
    aux = true if html.empty?
    abrir_tag(html, 'table', 'tr') unless aux.nil?
    abrir_tag(html, element.tag_name)
    html << element.text unless element.text.empty?
    element.images.each { |img| reportar_imagem(img, html) }
    fechar_tag(html, element.tag_name)
    fechar_tag(html, 'tr', 'table') unless aux.nil?
end
  
def reportar_imagem(img, html = [])
    src = img.attribute_value(:src)
    html << "<img src=\"#{src}\">"
end

def consultar_lista(elemento, nome)
    $automacao.consultar(:elements, elemento, nome)
end

  