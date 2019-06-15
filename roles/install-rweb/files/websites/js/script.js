    var sxsw = {

    full_bleed: function(boxWidth, boxHeight, imgWidth, imgHeight) {

        // Calculate new height and width...
        var initW = imgWidth;
        var initH = imgHeight;
        var ratio = initH / initW;

        imgWidth = boxWidth;
        imgHeight = boxWidth * ratio;

        // If the video is not the right height, then make it so...     
        if(imgHeight < boxHeight){
            imgHeight = boxHeight;
            imgWidth = imgHeight / ratio;
        }

        //  Return new size for video
        return {
            width: imgWidth,
            height: imgHeight
        };

    },

    init: function() {
        var browserHeight = Math.round(jQuery(window).height());
        var browserWidth = Math.round(jQuery(window).width());
        var videoHeight = jQuery('video').height();
        var videoWidth = jQuery('video').width();

        var new_size = sxsw.full_bleed(browserWidth, browserHeight, videoWidth, videoHeight);

        jQuery('video')
            .width(new_size.width)
            .height(new_size.height);  
    }

};
jQuery(document).ready(function($) {       

    /*
     * Full bleed background
     */

    sxsw.init();

    $(window).resize(function() {

        var browserHeight = Math.round($(window).height());
        var browserWidth = Math.round($(window).width());
        var videoHeight = $('.wd-thumb-list li a').eq(0).attr('data-wd-height');
        var videoWidth = $('.wd-thumb-list li a').eq(0).attr('data-wd-width');

        var new_size = sxsw.full_bleed(browserWidth, browserHeight, videoWidth, videoHeight);

        $('video')
            .width(new_size.width)
            .height(new_size.height);        
    });
