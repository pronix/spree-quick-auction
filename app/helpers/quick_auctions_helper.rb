module QuickAuctionsHelper
  # Use for check or uncheck radiobox on checkout page
  def check_variants(option_type, option_value)
    begin
      if session_value = session[:products].try(:first)[option_type.name.to_sym]
        return true if session_value.to_i == option_value.id
      end
    rescue
      nil
    end
  end
  
end
