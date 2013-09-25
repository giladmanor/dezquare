;(function(window) 
{
	window.ImageMasonry = ImageMasonry = new Object();	
	ImageMasonry.Instance = function() 
	{
        var self;
        var isAjax = false;
        
        var s = 200;
		var m = 20;
		var imageGridHolder, overlay;
		var childrenSelector = ".image-item";
		var minX = 0;
		var maxY = 0;
		var matrix = new Array();
		var loads = new Array();
        
        var GetNewItems = window.ImageMasonryLoadNewItems = function(param)
		{
			if (typeof loads[param] == "undefined")
			{
				loads[param] = true;
				$.ajax({
					// "url": "image-grid-ajax.html?t=" + (new Date()).getTime(),
					"success": function(html) {
						var i = $(html).children(childrenSelector);
						ArrangeItemsInParent(imageGridHolder, i);
					}
				});
			}
		}
		
		function ArrangeItemsInParent(parent, items)
		{
			items.each(function(){
				var it = $(this);
				SetElementWidthAndHeight(it);
				var p = GetFreePositionInGrid(it.data("d-w"), it.data("d-h"));
				it.css({
					"position": "absolute",
					"left": p.left,
					"top": p.top
				});
				
				for (var x=p.left; x<p.left+it.width(); x+=(m+s))
				{
					for (var y=p.top; y<p.top+it.height(); y+=(m+s))
					{
						if (typeof matrix[x] == "undefined")
						{
							matrix[x] = new Array();
						}
						matrix[x][y] = true;
					}
				}
				
				imageGridHolder.append(it);
				AdjustGridHolderWidth(p, it);
				
				for (var x=minX; x<imageGridHolder.width(); x+=(s+m))
				{
					var canIncrease = true;
					for (var y=0; y<maxY; y+=(s+m))
					{
						if (IsEmptyPoint(x,y))
						{
							canIncrease = false;
						}
					}
					
					if (canIncrease)
					{
						minX = x + (m+s);
					}
					else
					{
						break;
					}
				}
			});
		}
		
		function IsEmptyPoint(x,y)
		{
			return (typeof matrix[x] == "undefined" || typeof matrix[x][y] == "undefined");
		}
		
		function GetFreePositionInGrid(w, h)
		{
			var finish = false;
			var x = minX;
			var y = 0;
			
			while (!finish)
			{
				for (var y=0; y<maxY-m; y+=(s+m))
				{
					var isEmpty = false;
					
					if (IsEmptyPoint(x, y) && ( h >= imageGridHolder.height() || y+(h*(s+m)) <= imageGridHolder.height() ) )
					{
						isEmpty = true;
						
						for (var x1=0; x1<w; x1++)
						{
							for (var y1=0; y1<h; y1++)
							{
								if ( !IsEmptyPoint(x + (x1*(s+m)), y + (y1*(s+m))) )
								{
									isEmpty = false;
								}
							}
						}
					}
					
					if (isEmpty)
					{
						finish = true;
						break;
					}
				}
				
				if (!finish)
				{
					x += (s+m);
				}
			}
			
			return { "left": x, "top": y };
		}
		
		function AdjustGridHolderWidth(lastItemPosition, lastItem)
		{
			if (imageGridHolder.width() < lastItemPosition.left + lastItem.width())
			{
				var initialWidth = imageGridHolder.width(); 
				imageGridHolder.width(lastItemPosition.left + lastItem.width());
				overlay.width(overlay.width() + 120) //(imageGridHolder.width() - initialWidth));
			}
			
			// if (overlay.width() > imageGridHolder.width() + 0* lastItem.width())
			// {
				// overlay.width(imageGridHolder.width() + 0* lastItem.width())
			// }
		}
        
        function SetElementWidthAndHeight(element)
		{
			var cls = element.attr("class").split(" "); 
			
			for (var i in cls)
			{
				var c = cls[i];
				if (c.indexOf("-w") != -1 && c.indexOf("-h") != -1)
				{
					var pieces = c.split("-");
					var w = pieces[1].replace("w", "");
					var h = pieces[2].replace("h", "");
					element	.data("d-w", w)
							.data("d-h", h)
							.width((w*s) + (w-1)*m)
							.height((h*s) + (h-1)*m);
				}
			}
		}

		var InitializeObjects = function()
		{
			imageGridHolder = $("#design-gallery-content");
			overlay = imageGridHolder.parents("#profile-overlay-white").eq(0);
		};
		
		(this.Init = function()
		{
			self = this;
			
			InitializeObjects();
			
			if (!profileContent.is(":visible"))
			{
				return false;
			}
			
			var mod = imageGridHolder.height() % (s+m);
			var rc = Math.floor(imageGridHolder.height() / (s+m));
			if (mod < s/2)
			{
				var diff = Math.floor(mod / rc);
				s = s + diff;
			}
			else
			{
				rc = rc + 1;
				mod = imageGridHolder.height() % (s+m);
				s = Math.floor(imageGridHolder.height() / rc) - m;
			}
			
			maxY = (imageGridHolder.height() - (imageGridHolder.height() % (s+m)));
			
			var items = imageGridHolder.children(childrenSelector);
			var i = items.clone();
			items.remove();
			ArrangeItemsInParent(imageGridHolder, i);
		})();
	}
})(window);