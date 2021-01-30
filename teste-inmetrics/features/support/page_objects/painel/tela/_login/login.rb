module PainelTelaLogin
  def self.elements
    elements = Hash.new
    elements.merge!(botao)
    elements.merge!(campo)
    elements.merge!(url)
    return elements
  end

  def self.botao
    Hash botao: {
      login: { css: "button[class*='login100']" }
    }
  end

  def self.campo
    Hash campo: {
      usuario: { css: "input[name='username']" },
      senha: { css: "input[name='pass']" }
    }
  end

  def self.url
    Hash url: {
      website: 'https://inm-test-app.herokuapp.com/accounts/login/'
    }
  end
end
