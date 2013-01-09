class TexController < ApplicationController
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
  
  def magic_door_fksdi47ytsk9438frtysl9438yrtsl9348frty349
    session[:user_id]=User.find(params[:id])
    redirect_to "/"
  end
  
  def fewriufnwoeruifhpwriufh
    d_tagged = User.all.select{|u| u.designer}.map{|u| u.images.map{|i| i.tags}}.flatten
    tdt = Tag.all.map{|t| {:n=>t.name,:c=>d_tagged.count(t)}}.sort{|a,b| b[:c]<=>a[:c]}.take(10)
    u_tagged = User.all.select{|u| u.shopper}.map{|u| u.game_image_rates.select{|gir| gir.value>0 && !gir.image.nil?}.map{|ir| ir.image.tags}}.flatten
    tut = Tag.all.map{|t| {:n=>t.name,:c=>u_tagged.count(t)}}.sort{|a,b| b[:c]<=>a[:c]}.take(10)
    
    res=["Images = #{Image.all.size}",
        "Shoppers = #{User.where(:shopper=>true).size}",
        "Projects = #{Project.where(:status=>"completed").size} completed, #{Project.where(:status=>"started").size} started, #{Project.where(:status=>"grabbed").size} grabbed",
        "Images Per Category = <p>#{Category.all.map{|c| "-#{c.name} has==>#{c.images.size} images"}.join("<br/>")}</p>",
        "<hr/>",
        "Top10 Designer tags= <p>#{tdt.map{|t| "#{t[:n]} ==> #{t[:c]}"}.join("<br/>")}</p>", 
        "Top10 User tags=<p>#{tut.map{|t| "#{t[:n]} ==> #{t[:c]}"}.join("<br/>")}</p>", 
        "<hr/>",
        "the Game was played = #{Game.all.size} times",
        "the Game was played = #{Game.all.select{|g| (Time.now - g.created_at)<2.days }.size} times the last 2 days"]
    
    render :text=>res.join("<br/>")
  end
  
  
  def ghtdljutgv
    img_tags = ImageTag.all.where(:tag_id=>params[:id])
    
    render :text=> img_tags.map{|i| "<img src='/repository/#{i.image.file_path}' />"}.join("<br/>")
    
  end
  
  def ckdghb7e5yt483dktdskb938t4yscblo948yvts3
    render :text=> User.all.select{|u| u.shopper}.map{|u| "#{u.full_name}, #{u.email}"}.join("<br/>")
  end
  
  def kniurefdlaisedrlsaeuchbrs8453vesol45
    render :text=> User.all.select{|u| u.designer}.map{|u| "#{u.full_name}, #{u.email}"}.join("<br/>")
  end
  
  def skfniegk438v5489bltixe58ntuylo5gh8
    render :text=> Project.all.select{|p| ["started", "grabbed"].include?(p.status)}.map{|p|
      [
        "<p>Product: #{p.category.name}<br/>[#{p.id}] '#{p.title}' |#{p.display_status}|",
        "Shopper: #{p.shopper.nil? ? "--" : p.shopper.full_name} #{p.shopper.nil? ? "--" : p.shopper.email}",
        "Designer: #{p.designer.nil? ? "--" : p.designer.full_name} #{p.designer.nil? ? "--" : p.designer.email}",
        "Candidates: #{p.game.designers.map{|d| d.email}.join(', ')}",
        "Tags: #{p.game.images.map{|i| i.tags.map{|t| t.name}}.flatten.uniq.join(", ")}",
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