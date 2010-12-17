class PropertyParser
  
  # poor man's java property parser
  # Does NOT support the following
  # "key value" format
  # \ for multiple line
  # \uHHHH for unicode
  # "\ " for keys with spaces
  
  def self.parse(file_name)
    return {} if !File.file?(file_name) # exists and regular file

    results = {}
    File.open(file_name).each do |line|
      next if line =~ /^\s*[#!]/
      key, value = line.split(/\s*[=:]\s*/,2)
      if !value.nil? && value.strip != ""
        results[key.strip]=value.strip 
      end
    end    
    results
  end
end
