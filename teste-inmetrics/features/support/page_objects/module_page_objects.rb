module PageObjects
  def self.elements
    Dir.chdir DIR_PAGE_OBJECTS
    page_objects = search("*")
    Dir.chdir PROJETO

    return page_objects
  end

  def self.search(p_obj = Hash.new, dir)
    Dir.glob(dir).select {|f| File.directory? f}.each do |dir|
      d_key = File.basename(dir).to_sym
      if d_key.to_s.start_with?('_')
        p_obj.merge!(search("#{dir}/*"))
      else
        p_obj[d_key] = search("#{dir}/*")
      end

      Dir.glob("#{dir}/*.rb").each do |file|
        mod = Object.const_get(
          File.basename(
            file.split('/').map do |s|
              s.split('_').map(&:capitalize) unless s.start_with?('_')
            end.join, '.*'
          )
        )
        elements = mod.elements
        f_key = File.basename(file, '.*').to_sym

        unless elements.empty?
          if d_key.to_s.start_with?('_')
            p_obj[f_key] = elements
          else
            p_obj[d_key][f_key] = elements
          end
        end
      end

      unless d_key.to_s.start_with?('_')
        p_obj.delete(d_key) if p_obj[d_key].empty?
      end
    end

    return p_obj
  end
end
