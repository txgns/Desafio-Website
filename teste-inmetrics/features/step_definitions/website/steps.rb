# language: pt
# encoding UTF-8

Dado(/^(?:que |)abri o browser e acessei a (tela|pagina|página|janela) (?:de |)"([^"]*)"$/) do |tipo, titulo|
    $ambiente, $tipo, $titulo = :painel, txt2simb(tipo), txt2simb(titulo)
    $automacao.painel.close() if $automacao.instance_of?(Web)
    $automacao = $classe[$ambiente]
    $automacao.navegador()
    $automacao.acessar_pagina(titulo)
    step 'eu aguardo o carregamento da '+tipo+' "'+titulo+'"'
end
      
Dado(/^(?:que |)estou na (tela|pagina|página|aba) "([^"]*)"$/) do |tipo, titulo|
    $tipo, $titulo = txt2simb(tipo), txt2simb(titulo)
    $automacao = $classe[$ambiente]
end

Quando(/^(?:eu | )(?:insiro|preencho) (?:o|os) (?:dados|campo|campos):$/) do |tabela|
    dados = tabela.raw
    for dado in dados
        campo, valor = dado
        $automacao.preencher_campo(campo, valor)
    end
end

Quando(/^(?:eu |)(?:clico|clicar) (?:no|na) (item|botao|tela|aba|lista|botão|radiobutton|icone|ícone|imagem|dropdown|checkbox|link) "([^"]*)"$/) do |elemento, nome|
    $automacao.clicar_elemento(elemento, nome)
end

Entao(/^(?:eu |)aguardo o carregamento (?:do|da) (tela|texto|lista|pagina|página|janela) "([^"]*)"$/) do |tipo, titulo|
    $tipo, $titulo = txt2simb(tipo), txt2simb(titulo)
    $automacao.aguardar_processamento()
end

Entao(/^verifico (?:o|a) (mensagem|alerta|notificacao|notificação)$/) do |msg|
    $resultados << "#{apresentacao(msg)}: #{$automacao.verificar_elemento(:texto, msg)}"
end

Dado(/^(?:que |)estou na (tela|pagina|página|janela) "([^"]*)" do "([^"]*)"$/) do |tipo, titulo, ambiente|
    $ambiente, $tipo, $titulo = txt2simb(ambiente), txt2simb(tipo), txt2simb(titulo)
    $automacao = $classe[$ambiente] unless $automacao.instance_of?(Web)
    step 'eu aguardo o carregamento da '+tipo+' "'+titulo+'"'
  end

Quando(/^verifico (?:o|a) (botao|botão|icone|ícone|coluna|imagem|radiobutton|dropdown|checkbox|link|texto|campo|box) "([^"]*)"$/) do |elemento, nome|
    $resultados << "#{apresentacao(elemento)}: #{$automacao.verificar_elemento(elemento, nome)}"
end

Quando(/^verifico (?:o|a|os|as) (lista|textos|tabela|menu) "([^"]*)"$/) do |elemento, nome|
    $resultados << "#{apresentacao(elemento)}: #{$automacao.verificar_elemento(elemento, nome)}"
end

Dado(/^que estou na (tela|pagina|página|janela) "([^"]*)" após logar no painel.$/) do |tipo, titulo|
    $ambiente, $tipo, $titulo = :painel, txt2simb(tipo), txt2simb(titulo)

    $automacao = $classe[$ambiente] unless $automacao.instance_of?(Web)
    $automacao.navegador() if $automacao.painel.nil?
    $automacao.acessar_pagina(:login)
    step 'eu aguardo o carregamento da tela "Login"'

    $automacao.preencher_campo(:cliente, "teste")
    $automacao.preencher_campo(:login, "spliceadm")
    $automacao.preencher_campo(:senha, "v01c35")
    $automacao.clicar_elemento(:botao, :conectar)
    step 'eu aguardo o carregamento da '+tipo+' "'+titulo+'"'
    
end

E(/^verifico o conteudo de "([^"]*)"$/) do |arg1|
    trata_menu
end

Então(/^clico em sequência (?:no|na|nos) (checkbox|botões|botão|botao) "([^"]*)"$/) do |elemento, nome|
    $automacao.consultar(:elements, elemento, nome).each { |aux| aux.click;sleep 1}
end

Então(/^eu coloco um breaking point$/) do 
    binding.pry
end

Então(/^eu espero (\d) segund(?:os|o)$/) do |seg|
    sleep seg.to_i
end

Quando(/^eu troco de janela no navegador (\d)$/) do |num|
    sleep 5
    $automacao.painel.driver.switch_to.window($automacao.painel.driver.window_handles[num.to_i])
end

E(/^visualizo (?:o|a) (L|l)ista (?:de |)"([^"]*)"$/) do |_elemento, nome|
    $automacao.aguardar_processamento
    lista = $automacao.consultar(:elements, :lista, txt2simb(nome)).clone
    lista.each do |item|
        item = item.text.split("\n")
        $resultados << "<b>#{item[0]}</b> #{item[1]}"
    end
end

E(/^eu verifico (?:o|a) (L|l)ista (?:de |)"([^"]*)"$/) do |_elemento, nome|
    $automacao.aguardar_processamento
    lista = $automacao.consultar(:elements, :lista, txt2simb(nome)).clone
    lista.each do |item|
        item = item.text.split("\n")
        item.each { |i| $resultados << i }
    end
end

E(/^(?:V|v)isualizo a (?:T|t)abela (?:I|i)nfra(?:çõ|co)es (?:M|m)onitoradas$/) do
    sleep 1
    n = $automacao.consultar(:elements, :lista, :faixas).size
    colunas = $automacao.consultar(:elements, :lista, :colunas).map(&:text)

    sleep 0.1 until $automacao.consultar(:element, :carregamento, :aguarde).exists?
    sleep 0.1 while $automacao.consultar(:element, :carregamento, :aguarde).exists?

    n.times do |i|
      aux = ''
      colunas.each_with_index do |col, j|
        dado = nil
        linha = $automacao.bloco_auxiliar($automacao, :lista, :faixas, i)
        if col == ' '
          col = ' >><br>Ocorrências'
          linha.consultar(:element, :botao, :ocorrencias).click
          dado = $automacao.consultar(:element, :tabela, :ocorrencias).html
          linha.consultar(:element, :botao, :ocorrencias).click
        else
          dado = linha.consultar(:elements, :lista, :dados)[j].text
        end
  
        aux += " <b><font color='red'>|</font></b>" unless aux.empty?
        aux += "<b>#{col}:</b> #{dado.gsub("\n", ' ')}"
      end
  
      $resultados << aux unless aux.empty?
    end
end

Então(/^eu clico no botão expandir do menu "([^"]*)"$/) do |menu|
    for i in $automacao.painel.elements(css: ".rtSp")
        if i.parent.spans(css: ".rtPlus").size == 1
            next unless i.parent.span(css: ".rtIn").text.include? menu  
            i.parent.spans(css: ".rtPlus")[0].click
            break
        end
    end
end

E(/^visualizo a tabela "([^"]*)"$/) do |table|
    tabela = $automacao.consultar(:element, :tabela, table)
    $resultados << reportar_tabela(tabela).join
    take_print()
end

E(/^eu clico no item "([^"]*)" da tabela$/) do |nome|
    consultar_lista(:lista, :registros).each do |registro|
        next unless registro.text.downcase.include? nome.downcase
        registro.click
        break
    end
end

E(/^eu clico no item "([^"]*)" se estiver presente na lista "([^"]*)"$/) do |item, lista|
    consultar_lista(:lista, lista).each do |registro|
        next unless registro.text.downcase.include? item.downcase
        registro.click
        break
    end
end

E(/^preencho o campo "([^"]*)" com um nome aleatório$/) do |nome|
    valor = Faker::Name.name
    $automacao.preencher_campo(nome, valor)
end

E(/^preencho o campo "([^"]*)" com uma data aleatória$/) do |nome|
    valor = Time.now.strftime('%d/%m/%Y')
    $automacao.preencher_campo(nome, valor)
end

E(/^preencho o campo "([^"]*)" com um valor aleatório$/) do |nome|
    valor = rand(1000..10000).to_s
    $automacao.preencher_campo(nome, valor)
end
E(/^preencho o campo "([^"]*)" com um numero aleatório$/) do |nome|
    valor = rand(11111111111..99999999999).to_s
    $automacao.preencher_campo(nome, valor)
end

Dado(/^(?:que |)estou na (tela|pagina|página|aba) "([^"]*)"$/) do |tipo, titulo|
    $tipo, $titulo = txt2simb(tipo), txt2simb(titulo)
    $automacao = $classe[$ambiente]
end

