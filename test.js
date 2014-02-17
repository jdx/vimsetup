(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['plugin.hbs'] = template({"1":function(depth0,helpers,partials,data) {
  return "vimsetup";
  },"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var stack1, helper, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression, buffer = "<div class=\"container\">\n  <h1>";
  stack1 = (helper = helpers['link-to'] || (depth0 && depth0['link-to']) || helperMissing,helper.call(depth0, "home", {"name":"link-to","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data}));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "</h1>\n  "
    + escapeExpression(((helper = helpers.html || (depth0 && depth0.html)),(typeof helper === functionType ? helper.call(depth0, {"name":"html","hash":{},"data":data}) : helper)))
    + "\n</div>\n";
},"useData":true});
})();