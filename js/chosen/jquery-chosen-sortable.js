/*
 * http://antom.github.io/jquery-chosen-sortable/old/
 */

! function(a) {
    a.fn.chosenClassPrefix = function() {
        return a(this).is('[class^="chzn-"]') ? "chzn" : "chosen"
    }, a.fn.chosenOrder = function() {
        var b = this.filter("." + this.chosenClassPrefix() + "-sortable[multiple]").first(),
            c = b.siblings("." + this.chosenClassPrefix() + "-container");
        return a(c.find("." + this.chosenClassPrefix() + '-choices li[class!="search-field"]').map(function() {
            text = a(this).html();            
            text = text.replace(/<b class="group-name">(.*)<\/b>/, '').replace(/<\/?[^>]+(>|$)/g, "");
            
            var value = false;
            b.find("option:contains(" + text + ")").each(function(){
            	if($(this).html()==text)
            	{	
            		value = this;            		
            	}
            })
            
            return this ?  value : void 0
        }))
    }, a.fn.chosenSortable = function() {
        var b = this.filter("." + this.chosenClassPrefix() + "-sortable[multiple]");
        b.each(function() {
            chosen_order = (a(this).attr('chosen_order') ? a(this).attr('chosen_order').split(',') : new Array());
            a(this).setSelectionOrder(chosen_order);
            var b = a(this),
                c = b.siblings("." + b.chosenClassPrefix() + "-container");
            a.ui ? (c.find("." + b.chosenClassPrefix() + "-choices").bind("mousedown", function(b) {
                a(b.target).is("span") && b.stopPropagation()
            }), c.find("." + b.chosenClassPrefix() + "-choices").sortable({
                placeholder: "search-choice-placeholder",
                items: "li:not(.search-field)",
                tolerance: "pointer",
                start: function(a, b) {
                    b.placeholder.width(b.item.innerWidth()), b.placeholder.height(b.item.innerHeight())
                }
            }), b.closest("form") && b.closest("form").bind("submit", function() {
                var a = b.chosenOrder();
                b.children().remove(), b.append(a)  
                alert(b.closest("form").attr('id'))
            })) : console.error("jquery-chosen-sortable requires JQuery UI to have been initialised.")
        })
    }
}(jQuery);