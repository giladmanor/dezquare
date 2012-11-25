class ShowPersona < StageImplementor


    def self.set(game,params,arguments)
      if game.project.nil?
        game.project = Project.new
      end
      p = game.project
      p.category=game.category
      game.project.save
    end

    def self.complete?(game,arguments)
      !game.project.nil?
    end

    def self.default_arguments
      nil
    end


  end