class Web
    attr_accessor :painel, :abas
    def initialize
        @painel = nil
    end

    ### Comandos apenas painel ###

    def navegador()
        @painel = Watir::Browser.new BROWSER
        @painel.window.maximize()
        @abas = Hash.new
    end

    def fechar_aba(titulo)
        case acessar_aba(titulo)
        when true
            @abas.delete(@painel.window.handle)
            @painel.close()
        end
    end

    def acessar_pagina(titulo)
        @painel.goto($obj_pag[$ambiente][$tipo][txt2simb(titulo)][:url][BASE_URL])
        @abas.merge!({@painel.window.handle => apresentacao(titulo)})
    end

    ### Comandos painel e app ###

    def acessar_aba(titulo)
        case @abas.empty?
        when false
            case @abas.values.join(" ").include?(apresentacao(titulo))
            when true
                @abas.each do |k, v|
                    if v == apresentacao(titulo)
                        @painel.driver.switch_to.window(k)
                        true
                    end
                end
            end
        end
        "Aba não encontrada."
    end

    def aguardar_processamento()
        loop do
            break if ($automacao.painel.execute_script('return jQuery.active == 0') == true)
            sleep 1
        end

        if $obj_pag[$ambiente][$tipo][$titulo].keys.include?(:processamento)
            while !@painel.elements($obj_pag[$ambiente][$tipo][$titulo][:processamento]).empty?
                sleep(0.5)
            end
        end
    end

    def aguardar(tipo, titulo)
        $tipo, $titulo = txt2simb(tipo), txt2simb(titulo)

        case @abas.keys.size() < @painel.handles.size()
        when true
            @painel.handles.each do |k|
                if !@abas.keys.include?(k)
                    @abas.merge!({k => apresentacao(titulo)})
                    @painel.driver.switch_to.window(k)
                end
            end
        end

        $automacao.aguardar_processamento()
        case apresentacao(@painel.title).include?(apresentacao(titulo))
        when true then @abas.merge!({@painel.handles => apresentacao(titulo)})
        else puts "A página carregada não condiz com a página aguardada."
             puts "Página carregada: '#{@painel.title}'."
             puts "Página aguardada: '#{titulo}'."
            @abas.merge!({@painel.handle => apresentacao(@painel.title)})
        end

        "#{$tipo} #{$ambiente}: #{@abas[@painel.handle]}"
    end

    def esperar_elemento(elemento, nome, segundos = 5)
        Watir::Wait.until(timeout: segundos) { @painel.element(endereco(elemento, nome)).present? }
    end

    def esperar_elemento_desaparecer(elemento, nome)
        while !@painel.element(endereco(elemento, nome)).empty?
            sleep(0.5)
        end
    end

    def consultar_elemento(elemento, nome, parametro = nil, indice = nil)
        esperar_elemento(elemento, nome)
        case indice.nil?
        when true
            case parametro.nil?
            when true then @painel.element(endereco(elemento, nome))
            when false then @painel.element(endereco(elemento, nome)).send(parametro)
            end
        when false
            case parametro.nil?
            when true then @painel.elements(endereco(elemento, nome))[indice-1]
            when false then @painel.elements(endereco(elemento, nome))[indice-1].send(parametro)
            end
        end
    end

    def consultar(consulta, elemento, nome)
        aux = endereco(elemento, nome)
        @painel.send(consulta, aux)
    end

    def verificar_elemento(elemento, nome, indice = nil)
        case txt2simb(elemento)
        when :botao, :icone, :imagem, :dropdown, :checkbox, :link, :radiobutton, :campo, :box
            aux = consultar_elemento(elemento, nome, :tag_name, indice)
            msg(("button / a / i / input / img / select / span / input / textarea").include?(aux), elemento, nome, "Visivel", indice)
        when :texto, :textos, :lista
            format_txt(consultar_elemento(elemento, nome, :text))
        else
            "Elemento não Identificado"
        end
    end

    def clicar_elemento(elemento, nome, indice = nil)
        sleep(1)
        @painel.element(endereco(elemento, nome)).click
    end

    def preencher_campo(nome, valor)
        sleep(1)
        @painel.element(endereco(:campo, nome)).to_subtype.clear
        @painel.element(endereco(:campo, nome)).click
        @painel.element(endereco(:campo, nome)).send_keys(valor)
    end

    def bloco_auxiliar(bloco, elemento, nome, indice = 0)
        aux = Web.new
        aux.painel = bloco.consultar(:elements, elemento, nome)[indice].clone
        return aux
    end

      
end
