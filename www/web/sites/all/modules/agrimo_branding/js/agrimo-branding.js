(function ($, Drupal) {
  'use strict';

  Drupal.behaviors.agrimoBranding = {
    attach: function (context, settings) {
      // Replace all logo images
      $('img.site-logo, .gin-secondary-toolbar__brand img, .toolbar-bar img.toolbar-icon', context).once('agrimo-logo').each(function() {
        $(this).attr('src', '/sites/all/modules/agrimo_branding/images/agrimo-logo.png');
      });
      
      // Replace powered by text
      $('.farm-powered-by, .block-farm-powered-by-block, #block-farm-powered-by, #block-gin-powered', context).once('agrimo-powered').each(function() {
        $(this).html('<span>Powered by <a href="https://www.agrimo.ch" target="_blank">Agrimo</a></span>');
      });
      
      // Also check for any text containing "Powered by farmOS"
      $('*:contains("Powered by farmOS")', context).once('agrimo-text').each(function() {
        if ($(this).children().length === 0) {
          var text = $(this).text();
          if (text === 'Powered by farmOS') {
            $(this).html('Powered by <a href="https://www.agrimo.ch" target="_blank">Agrimo</a>');
          }
        }
      });
    }
  };

})(jQuery, Drupal);