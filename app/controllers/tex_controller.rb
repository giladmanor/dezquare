class TexController < AdminController
  def t
      return nil
      list_users = []
      
      User.where("designer =1").each{|user|
        logger.debug user.id
        nam_down = user.name.downcase
        last_down = user.l_name.downcase
        new_nam = "#{nam_down}_#{last_down}"
        while list_users.include?(new_nam) do
          new_nam = "#{new_nam}_1" 
        end
        user.direct_link = new_nam
        user.save
      }
        
      render :text => 'is good'
  
    #def name
    #User.where("designer =1").downcase
    #end
  
  end
  
  def updatecolorsforimages
    Image.find_each do |img|   ##### (CHANGED) USING FIND_EACH INSTEAD OF ALL
      if img.user_id.present? && img.file_path.present?
        if img.dominant_colors.empty?
          img.dominant_colors= img.get_dominant_colors
          img.color_histogram= img.get_color_histogram
          img.save
        end
      else 
        img.destroy unless img.nil?
      end
    end
    render :text => "Images colors updated successfully!"
  end
  
  def fewriufnwoeruifhpwriufh
    d_tagged = User.all.select{|u| u.designer}.map{|u| u.images.map{|i| i.tags}}.flatten
    tdt = Tag.all.map{|t| {:n=>t.name,:c=>d_tagged.count(t)}}.sort{|a,b| b[:c]<=>a[:c]}.take(10)
    u_tagged = User.all.select{|u| u.shopper}.map{|u| u.game_image_rates.select{|gir| gir.value>0 && !gir.image.nil?}.map{|ir| ir.image.tags}}.flatten
    tut = Tag.all.map{|t| {:n=>t.name,:c=>u_tagged.count(t)}}.sort{|a,b| b[:c]<=>a[:c]}.take(10)
    dez = GameImageRate.last.id
    
    res=["Images = #{Image.all.size}",
        "Shoppers = #{User.where(:shopper=>true).size}",
        "Projects = #{Project.where(:status=>"completed").size} completed, #{Project.where(:status=>"started").size} started, #{Project.where(:status=>"grabbed").size} grabbed",
        "Images Per Category = <p>#{Category.all.map{|c| "-#{c.name} has==>#{c.images.size} images"}.join("<br/>")}</p>",
        "<hr/>",
        "Top10 Designer tags= <p>#{tdt.map{|t| "#{t[:n]} ==> #{t[:c]}"}.join("<br/>")}</p>", 
        "Top10 User tags=<p>#{tut.map{|t| "#{t[:n]} ==> #{t[:c]}"}.join("<br/>")}</p>", 
        "<hr/>",
        "The Game was played = #{Game.all.size} times",
        "The Game was played = #{Game.all.select{|g| (Time.now - g.created_at)<2.days }.size} times the last 2 days",
        "Designs displayed so far = #{dez}"]
    
    render :text=>res.join("<br/>")
    
  end
  
  
  def ghtdljutgv
    img_tags = ImageTag.all.where(:tag_id=>params[:id])
    
    render :text=> img_tags.map{|i| "<img src='/repository/#{i.image.file_path}' />"}.join("<br/>")
    
  end
  
  
  def kniurefdlaisedrlsaeuchbrs8453vesol45
    render :text=> User.all.select{|u| u.designer}.map{|u| "#{u.full_name}, #{u.email}"}.join("<br/>")
  end
  
  def skfniegk438v5489bltixe58ntuylo5gh8
      render :text=> Project.all.select{|p| ["started", "grabbed", "delivered", "completed","canceled"].include?(p.status)}.map{|p|
      [
        "<p><u>Date:</u> #{p.created_at}",
        "<u>Product:</u> #{p.category.name}<br/>[#{p.id}] '#{p.title}' <b>|#{p.display_status}|</b>",
        "<u>Shopper:</u> #{p.shopper.nil? ? "--" : p.shopper.full_name} #{p.shopper.nil? ? "--" : p.shopper.email}",
        "<u>Designer:</u> #{p.designer.nil? ? "--" : p.designer.full_name} #{p.designer.nil? ? "--" : p.designer.email}",
        "<u>Candidates:</u> #{p.game.nil? ? "--" : p.game.designers.map{|d| d.email}.join(', ')}",
        "<u>Tags:</u> #{p.game.nil? ? "--" : p.game.images.map{|i| i.tags.map{|t| t.name}}.flatten.uniq.join(", ")}",
        "<u>Details:</u> #{p.info.nil? ? "--" : p.info}",
        "</p>"
      ].join("<br/>")
    }.join("<hr/>")
      
  end
  
  def peronassssdkniuvt
    render :text => Persona.all.map{|p| "<hr/> <h3>#{p.name}</h3><p>#{p.tags.map{|t| t.name}.join(',')}</p> #{images_for_persona(p).join(",")}<hr/>"}.join(".")
  end
  
  def images_for_persona(persona)
    persona_tags = persona.tags
    Image.all.map{|i| {:i=>i, :rate=>(persona_tags-i.tags).length}}.sort{|a,b| a[:rate]<=>b[:rate]}.take(20).map{|i| "#{i[:rate]}<img width='128' height='128' src='/repository/#{i[:i].file_path}'/>"}
  end
  
end