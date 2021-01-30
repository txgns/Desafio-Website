# language: pt
# encoding UTF-8

# Função que retorna dados aleatórios de vários tipos para validação dos campos
def entradas_randomicas(tipo, porcentagem = nil)
  tipo_aux = tipo.split
  caso = txt2simb(tipo_aux[0].downcase == 'entre' ? tipo_aux[0] : tipo)

  case caso
  when :caractere
    loop do
      string_aux = Faker::Types.character
      return string_aux unless %w[w x y z].include?(string_aux)
    end
  when :nome
    return Faker::Name.name
  when :lorem
    return Faker::Lorem.paragraph
  when :versao
    return Faker::Internet.ip_v4_address
  when :ip
    return Faker::Internet.ip_v4_address
  when :data
    return Time.now.strftime('%d/%m/%Y')
  when :data_posterior
    return (Date.new(DateTime.now.year, DateTime.now.month, DateTime.now.day) + 31).strftime('%d/%m/%Y')
  when :data_hora
    return Time.now.strftime('%d/%m/%Y %H:%M')
  when :data_invalida
    return Time.at(rand(Time.parse('01/01/2000').to_i..Time.now.to_i)).strftime('%d/%m/%Y %H:%M')
  when :hora_invalida
    return Time.at(rand(Time.parse('01/01/2000').to_i..Time.now.to_i)).strftime('%H:%M')
  when :hora
    return Time.now.strftime('%H:%M')
  when :data_anterior
    return (Date.new(DateTime.now.year, DateTime.now.month, DateTime.now.day) - 31).strftime('%d/%m/%Y')
  when :porcentagem
    return Faker::Boolean.boolean(porcentagem)
  when :serie
    string_aux = []
    4.times { string_aux << rand(0..9) }
    return string_aux.join
  when :fiscal
    string_aux = []
    10.times { string_aux << rand(0..9) }
    return string_aux.join
  when :valor
    string_aux = []
    4.times { string_aux << rand(0..9) }
    return string_aux.join
  when :valor_negativo
    string_aux = ['-']
    4.times { string_aux << rand(0..9) }
    return string_aux.join
  when :valor_decimal
    return Faker::Number.decimal
  when :vazio
    return ''
  when :invalido
    return "!@#$%¨&*()_+`´{[ª^~]}º<,>.;:/?°|'"
  when :dois_digitos
    return rand(1..4).to_s << rand(1..4).to_s
  when :um_digito
    return rand(1..4).to_s
  when :dois_digitos_negativos
    return '-' << rand(1..4).to_s << rand(1..4).to_s
  when :um_digito_negativo
    return '-' << rand(1..4).to_s
  when :direcao
    aux = %w[Norte Sul Leste Oeste]
    return aux.sample
  when :endereco
    return Faker::Address.street_address
  when :cidade
    return Faker::Address.city
  when :bairro
    return Faker::Address.street_name
  when :cep
    string_aux = []
    9.times { string_aux << rand(0..9) }
    return string_aux.join
  when :entre
    if tipo_aux[1].to_f.to_s == tipo_aux[1]
      # Ponto Flutuante
      tipo_aux[1] = tipo_aux[1].to_f
      tipo_aux[3] = tipo_aux[3].to_f
    else
      # Inteiro
      tipo_aux[1] = tipo_aux[1].to_i
      tipo_aux[3] = tipo_aux[3].to_i
    end
    return Faker::Number.between(from: tipo_aux[1], to: tipo_aux[3]).to_s
  when :n_a
    return 'na'
  else
    return tipo
  end
end
