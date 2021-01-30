# language: pt
# encoding UTF-8

@cadastro_de_funcionario
Funcionalidade: Cadastro de usuário

@automacao
Esquema do Cenário: Cenários Possíveis na Tela de Cadastro de usuário do Painel.
# Validar os cenários possíveis ao tentar cadastrar usuários no painel.
    * abri o browser e acessei a tela "Login" 
    E eu insiro os dados:
        |usuario  | inmetrics |
        |Senha    | automacao |
    E clico no botao "Login"

    E <condição inicial>
    * <ação1>
    * preencho o campo "Nome" com um nome aleatório
    * preencho o campo "Cargo" com um nome aleatório
    * preencho o campo "Admissão" com uma data aleatória
    * preencho o campo "Salário" com um valor aleatória
    E <ação2>
    Entao <tento cadastrar>


    @erro
    Exemplos:
    # cadastrar com valores inválidos e/ou incorretos. 
    |condição inicial                                 |ação1                             |ação2                          |tento cadastrar               |
    |estou na tela "Funcionarios" do "Painel"         |clico no botao "Novo funcionario" |                               |clico no botao "Submit Query" |
    |estou na tela "Funcionarios" do "Painel"         |clico no botao "Novo funcionario" |                               |clico no botao "Cancelar"     |   
 

    @sucesso 
    Exemplos:
    # logar com um email válido e senha correta.
    |condição inicial                                 |ação1                              |ação2                       |tento cadastrar                |
    |abri o browser e acessei a tela "Funcionarios"   |clico no botao "Novo funcionario"  |clico no radiobutton "CLT"  |clico no botao "Submit Query"  |
    |abri o browser e acessei a tela "Funcionarios"   |clico no botao "Novo funcionario"  |clico no radiobutton "PJ"   |clico no botao "Submit Query"  |  
