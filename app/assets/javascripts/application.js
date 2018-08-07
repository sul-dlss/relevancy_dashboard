// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require Chart.min
//= require_tree .

function details_in_popup(link, div_id){
    $.ajax({
        url: link,
        success: function(response){
            $('#'+div_id).html(response);
        }
    });
    return '<div id="'+ div_id +'">Loading...</div>';
}

$(document).on('ready turbolinks:load', function(event) {
  $('.collapse').collapse();

  $('[data-toggle="popover"][data-ajax-content]').popover({
    trigger: 'click',
    content: function(){
        var div_id =  "tmp-id-" + $.now();
        var link = $(this).data('ajax-content');

        if(this && link.match(/__PLACEHOLDER__/)) {
          link = link.replace("__PLACEHOLDER__", $(this).closest('.explain-other').find('input').val())
        }

        return details_in_popup(link, div_id);
    }
  });
});
