
Settings = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result binding)[Rails.env]