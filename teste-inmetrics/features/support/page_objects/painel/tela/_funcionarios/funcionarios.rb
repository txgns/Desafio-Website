module PainelTelaFuncionarios
    def self.elements
      elements = Hash.new
      elements.merge!(botao)
      elements.merge!(campo)
      elements.merge!(dropdown)
      elements.merge!(lista)
      elements.merge!(tabela)
      elements.merge!(url)
      return elements
    end
  
    def self.botao
      Hash botao: { 
        novo_funcionario: { css: "a[href='/empregados/new_empregado']" },
        excluir: { css: "button[id='delete-btn']" },
        editar: { css: "button[class='btn btn-warning']" },
        proxima_pagina: { css: "a[id='tabela_next']"},
        submit_query: { css: "input[class*='cadastrar']"},
        cancelar: { css: "input[class*='cancelar']"}
      }
    end
  
    def self.campo
      Hash campo: {
          pesquisar: { css: "input[type='search']"},
          nome: { css: "input[id='inputNome']"},
          cargo: { css: "input[id='inputCargo']"},
          cpf:   { css: "input[id='cpf']"},
          salario: { css: "input[id='dinheiro']"},
          admissao: { css: "input[id='inputAdmissao']"}     
      }
    end

    def self.dropdown
        Hash dropdown: {
          sexo: { css: "select[id='slctSexo']" }
        }
      end

    def self.lista
        Hash lista: {
          # Tabela
          colunas: {
            css: 'thead th',
            visible: true
          },
          itens_exibidos: {
            css: 'tbody tr',
            visible: true
          },
          dados: {
            css: 'tbody tr td',
            visible: true
          },
          # Paginação
          paginas: {
            css: 'span > a:not([aria-label])',
            visible: true
          }
        }
    end

    def self.radiobutton
        Hash radiobutton: {
            clt: { css: "input[id='clt']"},
            pj: { css: "input[id='pj']"}
        }
    end

    def self.tabela
        Hash tabela: {
          lista_de_funcionarios: { css: 'table[class]' }
        }
    end
    
    def self.url
      Hash url: {
        website: 'https://inm-test-app.herokuapp.com/empregados/'
      }
    end
end
  