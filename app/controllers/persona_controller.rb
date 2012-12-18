class PersonaController < SiteController
  
  def index
    @persona = Persona.find_by_name(params[:id])
  end
  
end
