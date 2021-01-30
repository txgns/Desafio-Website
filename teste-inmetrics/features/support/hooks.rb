AfterConfiguration do
    $obj_pag         = PageObjects.elements
    $classe          = { :painel => Web.new }
    $ambiente        = nil
    $tipo            = nil
    $titulo          = nil
    $automacao       = nil
    $resultados      = []
    $prints          = []
    $prints_steps    = []
    $prints_outlines = []
  end
  
  Before do |scenario|
    @scenario = scenario.name
    @is_scenario_outline = scenario.respond_to?(:scenario_outline)
  end
  
  After do |scenario|
    if scenario.failed?
      take_print("print_cenario_falho")
      embed_print($prints.pop) unless $prints.empty?
    end
    ## exibe os resultados gerados no final do cenário
    # puts $resultados.shift while !$resultados.empty?
  end
  
  AfterStep do
    ## exibe os resultados gerados no final de cada step
    puts $resultados.shift while !$resultados.empty?
    while !$prints.empty?
      (@is_scenario_outline ? $prints_outlines : $prints_steps) << $prints.shift
    end
  end
  